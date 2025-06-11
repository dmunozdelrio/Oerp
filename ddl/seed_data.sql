-- Purpose : Seed lookup tables
-- Author  : Codex
-- Date    : 2024-06-01
-- Version : 1.0

INSERT INTO gl_doc_types(doc_type, description, num_range_start, num_range_end)
VALUES('JE', 'Journal Entry', 1, 999999);

INSERT INTO gl_post_keys(key_id, description, dr_cr_flag, mandatory_fields)
VALUES('40', 'Debit Post', 'D', 'COST_CENTER');
INSERT INTO gl_post_keys(key_id, description, dr_cr_flag, mandatory_fields)
VALUES('50', 'Credit Post', 'C', 'COST_CENTER');

INSERT INTO gl_workflow_states(state_id, description)
VALUES('N', 'New');
INSERT INTO gl_workflow_states(state_id, description)
VALUES('P', 'Posted');

INSERT INTO tax_codes(tax_code, description, rate)
VALUES('VAT', 'Value Added Tax', 5);

INSERT INTO withholding_rules(rule_id, description, rate)
VALUES(1, 'Default WH', 10);

-- Chart of Accounts
INSERT INTO gl_accounts(account_code, description, account_type) VALUES('1000', 'Cash', 'ASSET');
INSERT INTO gl_accounts(account_code, description, account_type) VALUES('1100', 'Accounts Receivable', 'ASSET');
INSERT INTO gl_accounts(account_code, description, account_type) VALUES('1200', 'Inventory - Retail', 'ASSET');
INSERT INTO gl_accounts(account_code, description, account_type) VALUES('1250', 'Raw Materials Inventory', 'ASSET');
INSERT INTO gl_accounts(account_code, description, account_type) VALUES('1400', 'Lab Equipment', 'ASSET');
INSERT INTO gl_accounts(account_code, description, account_type) VALUES('1500', 'Software Assets', 'ASSET');
INSERT INTO gl_accounts(account_code, description, account_type) VALUES('2000', 'Accounts Payable', 'LIABILITY');
INSERT INTO gl_accounts(account_code, description, account_type) VALUES('2100', 'Accrued Expenses', 'LIABILITY');
INSERT INTO gl_accounts(account_code, description, account_type) VALUES('3000', 'Equity Capital', 'EQUITY');
INSERT INTO gl_accounts(account_code, description, account_type) VALUES('4000', 'Product Sales Revenue', 'REVENUE');
INSERT INTO gl_accounts(account_code, description, account_type) VALUES('4100', 'Drug Sales Revenue', 'REVENUE');
INSERT INTO gl_accounts(account_code, description, account_type) VALUES('4200', 'Biotech Services Revenue', 'REVENUE');
INSERT INTO gl_accounts(account_code, description, account_type) VALUES('4300', 'Software License Revenue', 'REVENUE');
INSERT INTO gl_accounts(account_code, description, account_type) VALUES('5000', 'Cost of Goods Sold', 'EXPENSE');
INSERT INTO gl_accounts(account_code, description, account_type) VALUES('5100', 'Research & Development Expense', 'EXPENSE');
INSERT INTO gl_accounts(account_code, description, account_type) VALUES('5200', 'Software Development Expense', 'EXPENSE');
INSERT INTO gl_accounts(account_code, description, account_type) VALUES('5300', 'Marketing Expense', 'EXPENSE');
INSERT INTO gl_accounts(account_code, description, account_type) VALUES('5400', 'General & Administrative Expense', 'EXPENSE');
