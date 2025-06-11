-- Purpose : Audit trigger for GL_LINES
-- Author  : Codex
-- Date    : 2024-06-01
-- Version : 1.0

CREATE OR REPLACE TRIGGER tr_gl_lines_log
AFTER INSERT OR UPDATE OR DELETE ON gl_lines
FOR EACH ROW
BEGIN
  IF INSERTING THEN
    INSERT INTO gl_change_log(log_id, table_name, operation, row_id_val, changed_by, changed_date)
    VALUES(sq_gl_change_log.NEXTVAL, 'GL_LINES', 'INSERT', :NEW.gll_id, USER, SYSDATE);
  ELSIF UPDATING THEN
    INSERT INTO gl_change_log(log_id, table_name, operation, row_id_val, changed_by, changed_date)
    VALUES(sq_gl_change_log.NEXTVAL, 'GL_LINES', 'UPDATE', :OLD.gll_id, USER, SYSDATE);
  ELSIF DELETING THEN
    INSERT INTO gl_change_log(log_id, table_name, operation, row_id_val, changed_by, changed_date)
    VALUES(sq_gl_change_log.NEXTVAL, 'GL_LINES', 'DELETE', :OLD.gll_id, USER, SYSDATE);
  END IF;
END;
/
