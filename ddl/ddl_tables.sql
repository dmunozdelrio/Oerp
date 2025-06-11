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
    status           CHAR(1)        DEFAULT 'B',
    tax_code         VARCHAR2(10),
    tax_rate         NUMBER(5,2)
);


CREATE TABLE gl_accounts (
    account_code    VARCHAR2(30) PRIMARY KEY,
    description     VARCHAR2(100),
    account_type    VARCHAR2(20),
    account_group   VARCHAR2(30),
    currency        VARCHAR2(3),
    tax_code        VARCHAR2(10),
    withholding_rule NUMBER,
    status          CHAR(1) DEFAULT 'A' CHECK (status IN ('A','I'))
);

CREATE TABLE gl_lines (
    gll_id        NUMBER        PRIMARY KEY,
    glh_id        NUMBER        NOT NULL,
    account_id    VARCHAR2(30)  NOT NULL,
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
    mandatory_fields VARCHAR2(200),
    account_code     VARCHAR2(30)
);

CREATE TABLE gl_split_rules (
    rule_id      NUMBER PRIMARY KEY,
    account_code VARCHAR2(30),
    segment_field VARCHAR2(30)
);

CREATE TABLE gl_workflow_states (
    state_id    VARCHAR2(10) PRIMARY KEY,
    description VARCHAR2(100),
    status      CHAR(1)    DEFAULT 'A' CHECK(status IN('A','I')),
    approver    VARCHAR2(50)
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

CREATE TABLE currencies (
  currency_code VARCHAR2(3) PRIMARY KEY,
  description   VARCHAR2(50)
);

CREATE TABLE gl_segments (
  segment_id   VARCHAR2(30) PRIMARY KEY,
  description  VARCHAR2(100)
);

CREATE TABLE users (
  user_id    VARCHAR2(50) PRIMARY KEY,
  username   VARCHAR2(50),
  full_name  VARCHAR2(100)
);

-- Tabla GL_HEADER
COMMENT ON TABLE gl_header IS 'Encabezados de asientos contables';
COMMENT ON COLUMN gl_header.glh_id IS 'PK: Identificador único del encabezado';
COMMENT ON COLUMN gl_header.doc_type IS 'Tipo de documento';
COMMENT ON COLUMN gl_header.doc_no IS 'Número de documento';
COMMENT ON COLUMN gl_header.glh_exchange_rate IS 'Tipo de cambio';
COMMENT ON COLUMN gl_header.glh_state IS 'Estado del encabezado';
COMMENT ON COLUMN gl_header.approver IS 'Usuario que aprueba';
COMMENT ON COLUMN gl_header.approval_date IS 'Fecha de aprobación';
COMMENT ON COLUMN gl_header.period_id IS 'FK a gl_periods para el periodo contable';
COMMENT ON COLUMN gl_header.status IS 'Estado: B= Borrador, A= Aprobado';
COMMENT ON COLUMN gl_header.tax_code IS 'Código de impuesto asociado al encabezado';
COMMENT ON COLUMN gl_header.tax_rate IS 'Tasa del impuesto copiada del catálogo';

-- Tabla GL_LINES
COMMENT ON TABLE gl_lines IS 'Líneas de detalle de cada asiento';
COMMENT ON COLUMN gl_lines.line_id IS 'PK: Identificador único de la línea';
COMMENT ON COLUMN gl_lines.header_id IS 'FK a gl_header para relacionar líneas';
COMMENT ON COLUMN gl_lines.account_id IS 'FK a la cuenta contable afectada';

-- Tabla GL_PERIODS
COMMENT ON TABLE gl_periods IS 'Periodos contables con estado abierto o cerrado';
COMMENT ON COLUMN gl_periods.period_id IS 'PK: Año y mes del periodo (YYYYMM)';
COMMENT ON COLUMN gl_periods.start_date IS 'Fecha de inicio del periodo';
COMMENT ON COLUMN gl_periods.end_date IS 'Fecha de fin del periodo';
COMMENT ON COLUMN gl_periods.status IS 'Estado: O=Open, C=Closed';

-- Tabla GL_ACCOUNTS
COMMENT ON TABLE gl_accounts IS 'Cuentas contables definidas en el sistema';
COMMENT ON COLUMN gl_accounts.account_code IS 'PK: Código único de la cuenta';
COMMENT ON COLUMN gl_accounts.description IS 'Descripción de la cuenta contable';
COMMENT ON COLUMN gl_accounts.account_type IS 'Tipo de cuenta (Activo, Pasivo, etc.)';
COMMENT ON COLUMN gl_accounts.account_group IS 'Grupo contable al que pertenece la cuenta';
COMMENT ON COLUMN gl_accounts.currency IS 'Moneda de la cuenta, si aplica';
COMMENT ON COLUMN gl_accounts.tax_code IS 'Código de impuesto asociado a la cuenta';
COMMENT ON COLUMN gl_accounts.withholding_rule IS 'Regla de retención asociada a la cuenta';
COMMENT ON COLUMN gl_accounts.status IS 'Estado de la cuenta: A=Activo, I=Inactivo';

-- Tabla GL_DOC_TYPES
COMMENT ON TABLE gl_doc_types IS 'Tipos de documentos contables';
COMMENT ON COLUMN gl_doc_types.doc_type IS 'PK: Tipo de documento';
COMMENT ON COLUMN gl_doc_types.description IS 'Descripción del tipo de documento';
COMMENT ON COLUMN gl_doc_types.num_range_start IS 'Inicio del rango de números';
COMMENT ON COLUMN gl_doc_types.num_range_end IS 'Fin del rango de números';

-- Tabla GL_POST_KEYS
COMMENT ON TABLE gl_post_keys IS 'Claves de contabilización para las líneas';
COMMENT ON COLUMN gl_post_keys.key_id IS 'PK: Identificador de la clave de contabilización';
COMMENT ON COLUMN gl_post_keys.description IS 'Descripción de la clave de contabilización';
COMMENT ON COLUMN gl_post_keys.dr_cr_flag IS 'Indica si es Débito (D) o Crédito (C)';
COMMENT ON COLUMN gl_post_keys.mandatory_fields IS 'Campos obligatorios para esta clave';
COMMENT ON COLUMN gl_post_keys.account_code IS 'Código de la cuenta asociada a la clave';

-- Tabla GL_SPLIT_RULES
COMMENT ON TABLE gl_split_rules IS 'Reglas para dividir cuentas en segmentos';
COMMENT ON COLUMN gl_split_rules.rule_id IS 'PK: Identificador de la regla de división';
COMMENT ON COLUMN gl_split_rules.account_code IS 'Código de la cuenta a dividir';
COMMENT ON COLUMN gl_split_rules.segment_field IS 'Campo de segmento para la división';

-- Tabla GL_WORKFLOW_STATES
COMMENT ON TABLE gl_workflow_states IS 'Estados del flujo de trabajo para aprobaciones';
COMMENT ON COLUMN gl_workflow_states.state_id IS 'PK: Identificador del estado';
COMMENT ON COLUMN gl_workflow_states.description IS 'Descripción del estado del flujo de trabajo';
COMMENT ON COLUMN gl_workflow_states.status IS 'Estado del flujo de trabajo: A=Activo, I=Inactivo';
COMMENT ON COLUMN gl_workflow_states.approver IS 'Usuario encargado de aprobar el flujo';

-- Tabla TAX_CODES
COMMENT ON TABLE tax_codes IS 'Códigos de impuestos aplicables a las cuentas';
COMMENT ON COLUMN tax_codes.tax_code IS 'PK: Código de impuesto';
COMMENT ON COLUMN tax_codes.description IS 'Descripción del impuesto';
COMMENT ON COLUMN tax_codes.rate IS 'Tasa del impuesto (porcentaje)';

-- Tabla WITHHOLDING_RULES
COMMENT ON TABLE withholding_rules IS 'Reglas de retención aplicables a las cuentas';
COMMENT ON COLUMN withholding_rules.rule_id IS 'PK: Identificador de la regla de retención';
COMMENT ON COLUMN withholding_rules.description IS 'Descripción de la regla de retención';
COMMENT ON COLUMN withholding_rules.rate IS 'Tasa de retención (porcentaje)';

-- Tabla GL_CHANGE_LOG
COMMENT ON TABLE gl_change_log IS 'Registro de cambios en las tablas del módulo GL';
COMMENT ON COLUMN gl_change_log.log_id IS 'PK: Identificador único del registro de cambio';
COMMENT ON COLUMN gl_change_log.table_name IS 'Nombre de la tabla afectada';
COMMENT ON COLUMN gl_change_log.operation IS 'Operación realizada (INSERT, UPDATE, DELETE)';
COMMENT ON COLUMN gl_change_log.row_id_val IS 'Valor del ID de la fila afectada';
COMMENT ON COLUMN gl_change_log.changed_by IS 'Usuario que realizó el cambio';
COMMENT ON COLUMN gl_change_log.changed_date IS 'Fecha y hora del cambio';

-- Tabla GL_PERIODS
COMMENT ON TABLE gl_periods IS 'Periodos contables con estado abierto o cerrado';
COMMENT ON COLUMN gl_periods.period_id IS 'PK: Identificador único del periodo contable';
COMMENT ON COLUMN gl_periods.start_date IS 'Fecha de inicio del periodo contable';
COMMENT ON COLUMN gl_periods.end_date IS 'Fecha de fin del periodo contable';
COMMENT ON COLUMN gl_periods.status IS 'Estado del periodo: O=Abierto, C=Cerrado';
