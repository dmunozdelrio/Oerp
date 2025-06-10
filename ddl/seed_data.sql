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
