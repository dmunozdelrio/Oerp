-- Purpose : Reporting package spec
-- Author  : Diego
-- Date    : 2024-06-01
-- Version : 1.0

CREATE OR REPLACE PACKAGE gl_report_pkg AS
  FUNCTION get_journal_list(p_date_from IN DATE, p_date_to IN DATE, p_state IN VARCHAR2)
    RETURN SYS_REFCURSOR;
END gl_report_pkg;
/
