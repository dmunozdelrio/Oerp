-- Purpose : Seed lookup tables and chart of accounts
-- Author  : Diego
-- Date    : 2024-06-01
-- Version : 1.1

-- Tipo de comprobante
INSERT INTO gl_doc_types(doc_type, description, num_range_start, num_range_end)
VALUES ('JE', 'Journal Entry', 1, 999999);

-- Claves de contabilización (se asignan account_id de las cuentas correspondientes)
INSERT INTO gl_post_keys(key_id, description, dr_cr_flag, mandatory_fields, account_id)
VALUES ('40', 'Debit Post', 'D', 'COST_CENTER', 1);
INSERT INTO gl_post_keys(key_id, description, dr_cr_flag, mandatory_fields, account_id)
VALUES ('50', 'Credit Post', 'C', 'COST_CENTER', 2);

-- Estados del flujo del asiento
INSERT INTO gl_workflow_states(state_id, description)
VALUES ('N', 'New');
INSERT INTO gl_workflow_states(state_id, description)
VALUES ('P', 'Posted');

-- Códigos de impuesto
INSERT INTO tax_codes(tax_code, description, rate)
VALUES ('VAT', 'Value Added Tax', 5);

-- Reglas de retención
INSERT INTO withholding_rules(rule_id, description, rate)
VALUES (1, 'Default WH', 10);

-- Chart of Accounts: se asigna account_id de forma explícita junto con account_code
INSERT INTO gl_accounts(account_id, account_code, description, account_type)
VALUES (1, '1000', 'Cash', 'ASSET');
INSERT INTO gl_accounts(account_id, account_code, description, account_type)
VALUES (2, '1100', 'Accounts Receivable', 'ASSET');
INSERT INTO gl_accounts(account_id, account_code, description, account_type)
VALUES (3, '1200', 'Inventory - Retail', 'ASSET');
INSERT INTO gl_accounts(account_id, account_code, description, account_type)
VALUES (4, '1250', 'Raw Materials Inventory', 'ASSET');
INSERT INTO gl_accounts(account_id, account_code, description, account_type)
VALUES (5, '1400', 'Lab Equipment', 'ASSET');
INSERT INTO gl_accounts(account_id, account_code, description, account_type)
VALUES (6, '1500', 'Software Assets', 'ASSET');
INSERT INTO gl_accounts(account_id, account_code, description, account_type)
VALUES (7, '2000', 'Accounts Payable', 'LIABILITY');
INSERT INTO gl_accounts(account_id, account_code, description, account_type)
VALUES (8, '2100', 'Accrued Expenses', 'LIABILITY');
INSERT INTO gl_accounts(account_id, account_code, description, account_type)
VALUES (9, '3000', 'Equity Capital', 'EQUITY');
INSERT INTO gl_accounts(account_id, account_code, description, account_type)
VALUES (10, '4000', 'Product Sales Revenue', 'REVENUE');
INSERT INTO gl_accounts(account_id, account_code, description, account_type)
VALUES (11, '4100', 'Drug Sales Revenue', 'REVENUE');
INSERT INTO gl_accounts(account_id, account_code, description, account_type)
VALUES (12, '4200', 'Biotech Services Revenue', 'REVENUE');
INSERT INTO gl_accounts(account_id, account_code, description, account_type)
VALUES (13, '4300', 'Software License Revenue', 'REVENUE');
INSERT INTO gl_accounts(account_id, account_code, description, account_type)
VALUES (14, '5000', 'Cost of Goods Sold', 'EXPENSE');
INSERT INTO gl_accounts(account_id, account_code, description, account_type)
VALUES (15, '5100', 'Research & Development Expense', 'EXPENSE');
INSERT INTO gl_accounts(account_id, account_code, description, account_type)
VALUES (16, '5200', 'Software Development Expense', 'EXPENSE');
INSERT INTO gl_accounts(account_id, account_code, description, account_type)
VALUES (17, '5300', 'Marketing Expense', 'EXPENSE');
INSERT INTO gl_accounts(account_id, account_code, description, account_type)
VALUES (18, '5400', 'General & Administrative Expense', 'EXPENSE');

-- Periodo contable
INSERT INTO gl_periods(period_id, start_date, end_date, status)
VALUES (202401, DATE '2024-01-01', DATE '2024-01-31', 'O');

COMMIT;
