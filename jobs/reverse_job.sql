-- Purpose : Scheduler job to reverse journal entries
-- Author  : Codex
-- Date    : 2024-06-01
-- Version : 1.0

BEGIN
  DBMS_SCHEDULER.CREATE_JOB(
      job_name        => 'REVERSE_RUN',
      job_type        => 'PLSQL_BLOCK',
      job_action      => 'BEGIN gl_pkg.reverse_entries(ADD_MONTHS(TRUNC(SYSDATE,''MM''),-1)); END;',
      start_date      => SYSDATE,
      repeat_interval => 'FREQ=DAILY',
      enabled         => TRUE);
END;
/
