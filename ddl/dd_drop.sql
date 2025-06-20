-- 1) Eliminar el Scheduler Job

BEGIN
  DBMS_SCHEDULER.DROP_JOB('REVERSE_RUN', TRUE);
  DBMS_SCHEDULER.DROP_JOB('TDAGRICORP.REVERSE_RUN', TRUE);
END;
/

-- 2) Eliminar Triggers
DROP TRIGGER TDAGRICORP.TR_GL_HEADER_LOG;
DROP TRIGGER TDAGRICORP.TR_GL_LINES_LOG;
DROP TRIGGER TDAGRICORP.TR_GL_HEADER_DEFAULTS;


-- 3) Eliminar Packages (spec y body)
DROP PACKAGE TDAGRICORP.GL_REPORT_PKG;
DROP PACKAGE TDAGRICORP.GL_TAX_PKG;
DROP PACKAGE TDAGRICORP.GL_UI_PKG;
DROP PACKAGE TDAGRICORP.GL_PKG;

-- 4) Eliminar Views
DROP VIEW TDAGRICORP.GL_HEADER_V;
DROP VIEW TDAGRICORP.GL_LINES_V;

-- 5) Eliminar Indexes
DROP INDEX TDAGRICORP.IDX_GL_LINES_HEADER;
DROP INDEX TDAGRICORP.IDX_GL_LINES_POST_KEY;
DROP INDEX TDAGRICORP.IDX_GL_LINES_ACCOUNT;
DROP INDEX TDAGRICORP.IDX_GL_HEADER_PERIOD;
DROP INDEX TDAGRICORP.IDX_GL_HEADER_STATE;

-- 6) Eliminar Secuencias
DROP SEQUENCE TDAGRICORP.SQ_GL_HEADER;
DROP SEQUENCE TDAGRICORP.SQ_GL_LINES;
DROP SEQUENCE TDAGRICORP.SQ_DOC_JE;
DROP SEQUENCE TDAGRICORP.SQ_GL_CHANGE_LOG;

-- 7) Eliminar Tablas (en orden para resolver dependencias)
DROP TABLE TDAGRICORP.GL_LINES            CASCADE CONSTRAINTS;
DROP TABLE TDAGRICORP.GL_CHANGE_LOG       CASCADE CONSTRAINTS;
DROP TABLE TDAGRICORP.GL_HEADER           CASCADE CONSTRAINTS;
DROP TABLE TDAGRICORP.GL_ACCOUNTS         CASCADE CONSTRAINTS;
DROP TABLE TDAGRICORP.GL_DOC_TYPES        CASCADE CONSTRAINTS;
DROP TABLE TDAGRICORP.GL_POST_KEYS        CASCADE CONSTRAINTS;
DROP TABLE TDAGRICORP.GL_SPLIT_RULES      CASCADE CONSTRAINTS;
DROP TABLE TDAGRICORP.GL_WORKFLOW_STATES  CASCADE CONSTRAINTS;
DROP TABLE TDAGRICORP.TAX_CODES           CASCADE CONSTRAINTS;
DROP TABLE TDAGRICORP.WITHHOLDING_RULES   CASCADE CONSTRAINTS;
DROP TABLE TDAGRICORP.GL_PERIODS          CASCADE CONSTRAINTS;
DROP TABLE TDAGRICORP.CURRENCIES          CASCADE CONSTRAINTS;
DROP TABLE TDAGRICORP.GL_SEGMENTS         CASCADE CONSTRAINTS;
DROP TABLE TDAGRICORP.USERS               CASCADE CONSTRAINTS;
