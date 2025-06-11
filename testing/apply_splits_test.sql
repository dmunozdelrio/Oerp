-- Purpose : Test apply_splits procedure
-- Author  : Diego Muñoz
-- Date    : 2025-06-12

SET SERVEROUTPUT ON SIZE 1000000

DECLARE
  v_glh_id gl_header.glh_id%TYPE;
BEGIN
  -- Setup data for split rules
  INSERT INTO gl_segments(segment_id, description) VALUES('SEG1','Test segment');
  INSERT INTO gl_split_rules(rule_id, account_id, segment_field)
  VALUES(1, 1, 'SEG1');
  INSERT INTO gl_post_keys(key_id, description, dr_cr_flag, mandatory_fields, account_id)
  VALUES('SPLIT','Auto Split','D',NULL,1);

  gl_pkg.init_header('JE', 202401, 1, v_glh_id);
  gl_pkg.add_line(v_glh_id, 1, '40', 'CC1', 'VAT', 50, NULL);
  gl_pkg.add_line(v_glh_id, 2, '50', 'CC1', 'VAT', NULL, 50);
  gl_pkg.validate_header(v_glh_id);

  gl_pkg.apply_splits(v_glh_id);

  DBMS_OUTPUT.PUT_LINE('Lines after apply_splits:');
  FOR r IN (
    SELECT gll_id, post_key, cost_center
      FROM gl_lines
     WHERE glh_id = v_glh_id
     ORDER BY gll_id
  ) LOOP
    DBMS_OUTPUT.PUT_LINE('Line '||r.gll_id||' PK='||r.post_key||' CC='||NVL(r.cost_center,'-'));
  END LOOP;
  ROLLBACK;
END;
/
