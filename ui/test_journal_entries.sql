-- Purpose : Example PL/SQL to create and post journals per doc type
-- Author  : Diego
-- Date    : 2024-06-01
-- Version : 1.0

SET SERVEROUTPUT ON
DECLARE
  v_glh_id gl_header.glh_id%TYPE;
BEGIN
  FOR r IN (SELECT doc_type FROM gl_doc_types) LOOP
    gl_pkg.init_header(p_doc_type      => r.doc_type,
                       p_period_id     => 202401,
                       p_exchange_rate => 1,
                       p_glh_id        => v_glh_id);

    gl_pkg.add_line(p_glh_id       => v_glh_id,
                    p_account_code => '1000',
                    p_post_key     => '40',
                    p_cost_center  => 'CC1',
                    p_tax_code     => 'VAT',
                    p_debit_amount => 100,
                    p_credit_amount => NULL);

    gl_pkg.add_line(p_glh_id       => v_glh_id,
                    p_account_code => '2000',
                    p_post_key     => '50',
                    p_cost_center  => 'CC1',
                    p_tax_code     => 'VAT',
                    p_debit_amount => NULL,
                    p_credit_amount => 100);

    gl_pkg.validate_header(v_glh_id);

    gl_pkg.apply_splits(v_glh_id);
    gl_pkg.post_journal(v_glh_id, 'SYSTEM');
  END LOOP;
END;
/
