-- Purpose : Reporting package body
-- Author  : Codex
-- Date    : 2024-06-01
-- Version : 1.0

CREATE OR REPLACE PACKAGE BODY gl_report_pkg AS
  FUNCTION get_journal_list(p_date_from IN DATE, p_date_to IN DATE, p_state IN VARCHAR2)
    RETURN SYS_REFCURSOR IS
    v_cur SYS_REFCURSOR;
  BEGIN
    OPEN v_cur FOR
      SELECT * FROM gl_header_v
       WHERE approval_date BETWEEN p_date_from AND p_date_to
         AND NVL(glh_state,'N') = NVL(p_state, glh_state);
    RETURN v_cur;
  END get_journal_list;
END gl_report_pkg;
/
