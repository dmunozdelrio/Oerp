-- Purpose : Test journal approval flow
-- Author  : Diego Muñoz
-- Date    : 2025-06-12

SET SERVEROUTPUT ON SIZE 1000000

DECLARE
  v_glh_id      gl_header.glh_id%TYPE;
  v_state       gl_header.glh_state%TYPE;
  v_approver    gl_header.approver%TYPE;
  v_approval_dt gl_header.approval_date%TYPE;
BEGIN
  gl_pkg.init_header('JE', 202401, 1, v_glh_id);
  gl_pkg.add_line(v_glh_id, 1, '40', 'CC1', 'VAT', 100, NULL);
  gl_pkg.add_line(v_glh_id, 2, '50', 'CC1', 'VAT', NULL, 100);
  gl_pkg.validate_header(v_glh_id);

  gl_pkg.post_journal(v_glh_id, 'DEV_USER');

  SELECT glh_state, approver, approval_date
    INTO v_state, v_approver, v_approval_dt
    FROM gl_header
   WHERE glh_id = v_glh_id;

  DBMS_OUTPUT.PUT_LINE('State='||v_state||' Approver='||v_approver||' Date='||TO_CHAR(v_approval_dt,'YYYY-MM-DD HH24:MI:SS'));
  ROLLBACK;
END;
/
