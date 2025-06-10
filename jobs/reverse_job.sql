-- Purpose : Scheduler job to reverse journal entries
-- Author  : Codex
-- Date    : 2024-06-01
-- Version : 1.0

-- Allow callers to override the start date and repeat interval.
-- Defaults run the job immediately and then daily.
DEFINE START_DATE      = SYSDATE
DEFINE REPEAT_INTERVAL = 'FREQ=DAILY'

BEGIN
  DBMS_SCHEDULER.CREATE_JOB(
      job_name        => 'REVERSE_RUN',
      job_type        => 'PLSQL_BLOCK',
      job_action      => q'[BEGIN gl_pkg.reverse_entries(ADD_MONTHS(TRUNC(SYSDATE,'MM'),-1)); END;]',
      start_date      => &START_DATE,
      repeat_interval => &REPEAT_INTERVAL,
      enabled         => TRUE);
END;
/
