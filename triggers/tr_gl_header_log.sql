-- Purpose : Audit trigger for GL_HEADER
-- Author  : Codex
-- Date    : 2024-06-01
-- Version : 1.0

CREATE OR REPLACE TRIGGER tr_gl_header_log
AFTER INSERT OR UPDATE OR DELETE ON gl_header
FOR EACH ROW
BEGIN
  IF INSERTING THEN
    INSERT INTO gl_change_log(log_id, table_name, operation, row_id_val, changed_by, changed_date)
    VALUES(sq_gl_header.NEXTVAL, 'GL_HEADER', 'INSERT', :NEW.glh_id, USER, SYSDATE);
  ELSIF UPDATING THEN
    INSERT INTO gl_change_log(log_id, table_name, operation, row_id_val, changed_by, changed_date)
    VALUES(sq_gl_header.NEXTVAL, 'GL_HEADER', 'UPDATE', :OLD.glh_id, USER, SYSDATE);
  ELSIF DELETING THEN
    INSERT INTO gl_change_log(log_id, table_name, operation, row_id_val, changed_by, changed_date)
    VALUES(sq_gl_header.NEXTVAL, 'GL_HEADER', 'DELETE', :OLD.glh_id, USER, SYSDATE);
  END IF;
END;
/
