-- Purpose : Simulate a journal entry, print report, then rollback
-- Author  : Diego Muñoz
-- Date    : 2025-06-11

SET SERVEROUTPUT ON SIZE 1000000

DECLARE
  v_glh_id        gl_header.glh_id%TYPE;
  v_doc_type      gl_header.doc_type%TYPE;
  v_doc_no        gl_header.doc_no%TYPE;
  v_descr         gl_header.glh_description%TYPE;
  v_rate          gl_header.glh_exchange_rate%TYPE;
  v_state         gl_header.glh_state%TYPE;
  v_status        gl_header.status%TYPE;
  v_period        gl_header.period_id%TYPE;
  v_approver      gl_header.approver%TYPE;
  v_approval_date gl_header.approval_date%TYPE;
BEGIN
  -- 1) Simulate inserts
  gl_pkg.init_header(
    p_doc_type      => 'JE',
    p_period_id     => 202401,
    p_exchange_rate => 1,
    p_glh_id        => v_glh_id
  );
  gl_pkg.add_line(
    p_glh_id        => v_glh_id,
    p_account_id    => 1,        -- se pasa el account_id correspondiente (ej. 1 para '1000')
    p_post_key      => '40',
    p_cost_center   => 'CC1',
    p_tax_code      => 'VAT',
    p_debit_amount  => 150.00,
    p_credit_amount => NULL
  );
  gl_pkg.add_line(
    p_glh_id        => v_glh_id,
    p_account_id    => 2,        -- se pasa el account_id correspondiente (ej. 2 para '2000')
    p_post_key      => '50',
    p_cost_center   => 'CC1',
    p_tax_code      => 'VAT',
    p_debit_amount  => NULL,
    p_credit_amount => 150.00
  );
  gl_pkg.validate_header(v_glh_id);

  -- 2) Fetch and print header
  SELECT doc_type, doc_no, glh_description,
         glh_exchange_rate, glh_state, status,
         period_id, approver, approval_date
    INTO v_doc_type, v_doc_no, v_descr,
         v_rate, v_state, v_status,
         v_period, v_approver, v_approval_date
    FROM gl_header
   WHERE glh_id = v_glh_id;

  DBMS_OUTPUT.PUT_LINE('=== Journal Entry Simulation Report ===');
  DBMS_OUTPUT.PUT_LINE('ID: '||v_glh_id||'   Type/No: '||v_doc_type||'/'||v_doc_no);
  DBMS_OUTPUT.PUT_LINE('Desc: '||NVL(v_descr,'<none>'));
  DBMS_OUTPUT.PUT_LINE('Rate: '||v_rate||'   State/Status: '||v_state||'/'||v_status);
  DBMS_OUTPUT.PUT_LINE('Period: '||v_period||'   Approver: '||NVL(v_approver,'<none>'));
  DBMS_OUTPUT.PUT_LINE('Approval: '||NVL(TO_CHAR(v_approval_date,'YYYY-MM-DD HH24:MI:SS'),'<none>'));
  DBMS_OUTPUT.PUT_LINE('---------------------------------------');

  -- 3) Fetch and print lines
  FOR rec IN (
    SELECT gll_id, account_id, post_key, cost_center, debit_amount, credit_amount, tax_code
      FROM gl_lines
     WHERE glh_id = v_glh_id
     ORDER BY gll_id
  ) LOOP
    DBMS_OUTPUT.PUT_LINE(
      'Line '||LPAD(rec.gll_id,3,' ')||
      ' | Acct='||rec.account_id||
      ' | PK='||rec.post_key||
      ' | CC='||NVL(rec.cost_center,'-')||
      ' | Dr='||NVL(TO_CHAR(rec.debit_amount,'FM999,999,990.00'),'0.00')||
      ' | Cr='||NVL(TO_CHAR(rec.credit_amount,'FM999,999,990.00'),'0.00')||
      ' | Tax='||NVL(rec.tax_code,'-')
    );
  END LOOP;

  -- 4) Rollback simulation
  ROLLBACK;  
  DBMS_OUTPUT.PUT_LINE('All simulated changes have been rolled back.');

END;
/

SELECT COUNT(*) AS header_count
  FROM gl_header
 WHERE glh_id = 1;

 SELECT COUNT(*) AS lines_count
  FROM gl_lines
 WHERE glh_id = 1;