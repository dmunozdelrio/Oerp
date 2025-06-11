-- Purpose : Test validation exceptions
-- Author  : Diego Muñoz
-- Date    : 2025-06-12

SET SERVEROUTPUT ON SIZE 1000000

-- Unbalanced journal -> ORA-20006
DECLARE
  v_glh_id gl_header.glh_id%TYPE;
BEGIN
  DBMS_OUTPUT.PUT_LINE('Unbalanced journal test');
  gl_pkg.init_header('JE', 202401, 1, v_glh_id);
  gl_pkg.add_line(v_glh_id, 1, '40', 'CC1', NULL, 100, NULL);
  gl_pkg.add_line(v_glh_id, 2, '50', 'CC1', NULL, NULL, 50);
  BEGIN
    gl_pkg.validate_header(v_glh_id);
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Raised: '||SQLERRM);
  END;
  ROLLBACK;
END;
/

-- Closed period -> ORA-20010
DECLARE
  v_glh_id gl_header.glh_id%TYPE;
BEGIN
  DBMS_OUTPUT.PUT_LINE('Closed period test');
  INSERT INTO gl_periods(period_id, start_date, end_date, status)
  VALUES(202312, DATE '2023-12-01', DATE '2023-12-31', 'C');
  gl_pkg.init_header('JE', 202312, 1, v_glh_id);
  gl_pkg.add_line(v_glh_id, 1, '40', 'CC1', NULL, 50, NULL);
  gl_pkg.add_line(v_glh_id, 2, '50', 'CC1', NULL, NULL, 50);
  BEGIN
    gl_pkg.validate_header(v_glh_id);
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Raised: '||SQLERRM);
  END;
  ROLLBACK;
END;
/

-- Invalid post key -> ORA-20005
DECLARE
  v_glh_id gl_header.glh_id%TYPE;
BEGIN
  DBMS_OUTPUT.PUT_LINE('Invalid post key test');
  gl_pkg.init_header('JE', 202401, 1, v_glh_id);
  BEGIN
    gl_pkg.add_line(v_glh_id, 1, '99', 'CC1', NULL, 10, NULL);
    gl_pkg.validate_header(v_glh_id);
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Raised: '||SQLERRM);
  END;
  ROLLBACK;
END;
/

-- Missing cost center -> ORA-20004
DECLARE
  v_glh_id gl_header.glh_id%TYPE;
BEGIN
  DBMS_OUTPUT.PUT_LINE('Missing cost center test');
  gl_pkg.init_header('JE', 202401, 1, v_glh_id);
  BEGIN
    gl_pkg.add_line(v_glh_id, 1, '40', NULL, NULL, 20, NULL);
    gl_pkg.add_line(v_glh_id, 2, '50', 'CC1', NULL, NULL, 20);
    gl_pkg.validate_header(v_glh_id);
  EXCEPTION
    WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('Raised: '||SQLERRM);
  END;
  ROLLBACK;
END;
/
