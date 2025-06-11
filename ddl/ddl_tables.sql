-- Purpose : Create core tables for Journal Entry
-- Author  : Diego
-- Date    : 2024-06-01
-- Version : 1.0

CREATE TABLE gl_header (
    glh_id           NUMBER         PRIMARY KEY,
    doc_type         VARCHAR2(10)   NOT NULL,
    doc_no           NUMBER,
    glh_exchange_rate NUMBER(10,5),
    glh_state        VARCHAR2(2),
    approver         VARCHAR2(50),
    approval_date    DATE,
    period_id        NUMBER         NOT NULL,
    status           CHAR(1)        DEFAULT 'B'
);

CREATE TABLE gl_accounts (
    account_code  VARCHAR2(30) PRIMARY KEY,
    description   VARCHAR2(100),
    account_type  VARCHAR2(20)
);

CREATE TABLE gl_lines (
    gll_id        NUMBER        PRIMARY KEY,
    glh_id        NUMBER        NOT NULL,
    account_code  VARCHAR2(30)  NOT NULL,
    post_key      VARCHAR2(10)  NOT NULL,
    cost_center   VARCHAR2(30),
    tax_code      VARCHAR2(10),
    debit_amount  NUMBER(15,2),
    credit_amount NUMBER(15,2)
);

CREATE TABLE gl_doc_types (
    doc_type        VARCHAR2(10) PRIMARY KEY,
    description     VARCHAR2(100),
    num_range_start NUMBER,
    num_range_end   NUMBER
);

CREATE TABLE gl_post_keys (
    key_id           VARCHAR2(10) PRIMARY KEY,
    description      VARCHAR2(100),
    dr_cr_flag       CHAR(1) CHECK (dr_cr_flag IN ('D','C')),
    mandatory_fields VARCHAR2(200)
);

CREATE TABLE gl_split_rules (
    rule_id      NUMBER PRIMARY KEY,
    account_code VARCHAR2(30),
    segment_field VARCHAR2(30)
);

CREATE TABLE gl_workflow_states (
    state_id    VARCHAR2(10) PRIMARY KEY,
    description VARCHAR2(100)
);

CREATE TABLE tax_codes (
    tax_code    VARCHAR2(10) PRIMARY KEY,
    description VARCHAR2(100),
    rate        NUMBER(5,2)
);

CREATE TABLE withholding_rules (
    rule_id     NUMBER PRIMARY KEY,
    description VARCHAR2(100),
    rate        NUMBER(5,2)
);

CREATE TABLE gl_change_log (
    log_id       NUMBER PRIMARY KEY,
    table_name   VARCHAR2(30),
    operation    VARCHAR2(10),
    row_id_val   NUMBER,
    changed_by   VARCHAR2(50),
    changed_date DATE
);

CREATE TABLE gl_periods (
    period_id NUMBER PRIMARY KEY,
    start_date DATE,
    end_date DATE,
    status CHAR(1) -- 'O' for open, 'C' for closed
);
