-- Purpose : Core business package body for Journal Entry
-- Author  : Diego
-- Date    : 2024-06-01
-- Version : 1.0

CREATE OR REPLACE PACKAGE BODY gl_pkg AS

  PROCEDURE init_header(
    p_doc_type      IN gl_header.doc_type%TYPE,
    p_period_id     IN gl_header.period_id%TYPE,
    p_exchange_rate IN gl_header.glh_exchange_rate%TYPE,
    p_glh_id        OUT gl_header.glh_id%TYPE
  ) IS
    v_seq_name VARCHAR2(30);
    v_doc_no   NUMBER;
  BEGIN
    -- Determina la secuencia para el número de documento
    SELECT 'SQ_DOC_' || p_doc_type
      INTO v_seq_name
      FROM gl_doc_types
     WHERE doc_type = p_doc_type;

    -- Obtiene el siguiente valor para el ID de cabecera
    SELECT sq_gl_header.NEXTVAL
      INTO p_glh_id
      FROM dual;

    -- Ejecuta la secuencia dinámica para el número de documento
    EXECUTE IMMEDIATE
      'SELECT ' || v_seq_name || '.NEXTVAL FROM dual'
      INTO v_doc_no;

    -- Inserta la cabecera con el número de documento separado
    INSERT INTO gl_header(
      glh_id,
      doc_type,
      doc_no,
      glh_exchange_rate,
      period_id,
      glh_state
    )
    VALUES(
      p_glh_id,
      p_doc_type,
      v_doc_no,
      p_exchange_rate,
      p_period_id,
      'N'
    );

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20001, 'Invalid DOC_TYPE');
  END init_header;


  PROCEDURE add_line(
    p_glh_id        IN gl_lines.glh_id%TYPE,
    p_account_id  IN gl_lines.account_id%TYPE,  -- se recibe el valor de cuenta
    p_post_key      IN gl_lines.post_key%TYPE,
    p_cost_center   IN gl_lines.cost_center%TYPE,
    p_tax_code      IN gl_lines.tax_code%TYPE,
    p_debit_amount  IN gl_lines.debit_amount%TYPE,
    p_credit_amount IN gl_lines.credit_amount%TYPE
  ) IS
    v_mandatory VARCHAR2(200);
    v_flag      CHAR(1);
  BEGIN
    SELECT mandatory_fields,
           dr_cr_flag
      INTO v_mandatory,
           v_flag
      FROM gl_post_keys
     WHERE key_id = p_post_key;

    IF v_flag = 'D' AND (p_debit_amount IS NULL OR p_debit_amount <= 0) THEN
      RAISE_APPLICATION_ERROR(-20002, 'Debit amount required');
    ELSIF v_flag = 'C' AND (p_credit_amount IS NULL OR p_credit_amount <= 0) THEN
      RAISE_APPLICATION_ERROR(-20003, 'Credit amount required');
    END IF;

    IF INSTR(v_mandatory, 'COST_CENTER') > 0
       AND p_cost_center IS NULL
    THEN
      RAISE_APPLICATION_ERROR(-20004, 'Cost center mandatory');
    END IF;

    INSERT INTO gl_lines(
      gll_id,
      glh_id,
      account_id,  -- se modifica para insertar en ACCOUNT_ID
      post_key,
      cost_center,
      tax_code,
      debit_amount,
      credit_amount
    )
    VALUES(
      sq_gl_lines.NEXTVAL,
      p_glh_id,
      p_account_id,   -- valor pasado a través de p_account_id
      p_post_key,
      p_cost_center,
      p_tax_code,
      p_debit_amount,
      p_credit_amount
    );

  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20005, 'Invalid POST_KEY');
  END add_line;


  PROCEDURE validate_header(
    p_glh_id IN gl_header.glh_id%TYPE
  ) IS
    v_debits    NUMBER;
    v_credits   NUMBER;
    v_doc_type  gl_header.doc_type%TYPE;
    v_period_id gl_header.period_id%TYPE;
    v_count     NUMBER;
    v_status    CHAR(1);
  BEGIN
    -- Verifica que débitos y créditos estén balanceados
    SELECT SUM(NVL(debit_amount,0)),
           SUM(NVL(credit_amount,0))
      INTO v_debits,
           v_credits
      FROM gl_lines
     WHERE glh_id = p_glh_id;

    IF v_debits <> v_credits THEN
      RAISE_APPLICATION_ERROR(-20006, 'Journal not balanced');
    END IF;

    -- Obtiene tipo de documento y periodo
    SELECT doc_type,
           period_id
      INTO v_doc_type,
           v_period_id
      FROM gl_header
     WHERE glh_id = p_glh_id;

    -- Valida que el tipo exista
    SELECT COUNT(*)
      INTO v_count
      FROM gl_doc_types
     WHERE doc_type = v_doc_type;
    IF v_count = 0 THEN
      RAISE_APPLICATION_ERROR(-20007, 'Invalid DOC_TYPE');
    END IF;

    -- Verifica que el periodo esté abierto ('O')
    SELECT status
      INTO v_status
      FROM gl_periods
     WHERE period_id = v_period_id;
    IF v_status <> 'O' THEN
      RAISE_APPLICATION_ERROR(-20010, 'Period closed');
    END IF;

    -- Valida claves de asiento
    SELECT COUNT(*)
      INTO v_count
      FROM gl_lines l
     WHERE l.glh_id = p_glh_id
       AND NOT EXISTS (
         SELECT 1
           FROM gl_post_keys pk
          WHERE pk.key_id = l.post_key
       );
    IF v_count > 0 THEN
      RAISE_APPLICATION_ERROR(-20011, 'Invalid POST_KEY in lines');
    END IF;

    -- Verifica campos obligatorios (p.ej. COST_CENTER)
    SELECT COUNT(*)
      INTO v_count
      FROM gl_lines l
      JOIN gl_post_keys pk
        ON pk.key_id = l.post_key
     WHERE l.glh_id = p_glh_id
       AND INSTR(pk.mandatory_fields, 'COST_CENTER') > 0
       AND l.cost_center IS NULL;
    IF v_count > 0 THEN
      RAISE_APPLICATION_ERROR(-20012, 'Cost center missing');
    END IF;

    -- Comprueba montos negativos o cero
    SELECT COUNT(*)
      INTO v_count
      FROM gl_lines l
     WHERE l.glh_id = p_glh_id
       AND (
         (l.debit_amount IS NOT NULL AND l.debit_amount <= 0) OR
         (l.credit_amount IS NOT NULL AND l.credit_amount <= 0)
       );
    IF v_count > 0 THEN
      RAISE_APPLICATION_ERROR(-20013, 'Negative amounts found');
    END IF;

  END validate_header;


  PROCEDURE post_journal(
    p_glh_id   IN gl_header.glh_id%TYPE,
    p_approver IN gl_header.approver%TYPE
  ) IS
  BEGIN
    UPDATE gl_header
       SET glh_state    = 'P',
           approver     = p_approver,
           approval_date= SYSDATE
     WHERE glh_id = p_glh_id;
  END post_journal;


  PROCEDURE apply_splits(
    p_glh_id IN gl_header.glh_id%TYPE
  ) IS
  BEGIN
    FOR r IN (
      SELECT gll_id, account_id
        FROM gl_lines
       WHERE glh_id = p_glh_id
    ) LOOP
      FOR s IN (
        SELECT segment_field
          FROM gl_split_rules
         WHERE account_id = r.account_id
      ) LOOP
        INSERT INTO gl_lines(
          gll_id,
          glh_id,
          account_id,
          post_key,
          cost_center,
          tax_code,
          debit_amount,
          credit_amount
        )
        VALUES(
          sq_gl_lines.NEXTVAL,
          p_glh_id,
          r.account_id,
          'SPLIT',
          s.segment_field,
          NULL,
          0,
          0
        );
      END LOOP;
    END LOOP;
  END apply_splits;


  PROCEDURE reverse_entries(
    p_period_id IN NUMBER
  ) IS
  BEGIN
    FOR h IN (
      SELECT glh_id
        FROM gl_header
       WHERE period_id = p_period_id
    ) LOOP
      FOR l IN (
        SELECT *
          FROM gl_lines
         WHERE glh_id = h.glh_id
      ) LOOP
        INSERT INTO gl_lines(
          gll_id,
          glh_id,
          account_id,
          post_key,
          cost_center,
          tax_code,
          debit_amount,
          credit_amount
        )
        VALUES(
          sq_gl_lines.NEXTVAL,
          h.glh_id,
          l.account_id,
          l.post_key,
          l.cost_center,
          l.tax_code,
          -NVL(l.debit_amount,0),
          -NVL(l.credit_amount,0)
        );
      END LOOP;
    END LOOP;
  END reverse_entries;

END gl_pkg;
/
