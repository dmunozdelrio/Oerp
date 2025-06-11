-- Purpose : Add constraints and indexes for Journal Entry
-- Author  : Diego
-- Date    : 2024-06-01
-- Version : 1.0

-- Constraints para GL_HEADER
ALTER TABLE gl_header 
  ADD CONSTRAINT fk_glh_doctype FOREIGN KEY (doc_type)
    REFERENCES gl_doc_types(doc_type);

ALTER TABLE gl_header 
  ADD CONSTRAINT fk_glh_state FOREIGN KEY (glh_state)
    REFERENCES gl_workflow_states(state_id);

ALTER TABLE gl_header 
  ADD CONSTRAINT fk_glh_tax_code FOREIGN KEY (tax_code)
    REFERENCES tax_codes(tax_code);

ALTER TABLE gl_header 
  ADD CONSTRAINT fk_glh_period FOREIGN KEY (period_id)
    REFERENCES gl_periods(period_id);

CREATE INDEX idx_gl_header_period ON gl_header(period_id);
CREATE INDEX idx_gl_header_state ON gl_header(glh_state);

-- Constraints para GL_LINES
ALTER TABLE gl_lines 
  ADD CONSTRAINT fk_gll_header FOREIGN KEY (glh_id)
    REFERENCES gl_header(glh_id);

ALTER TABLE gl_lines 
  ADD CONSTRAINT fk_gll_tax FOREIGN KEY (tax_code)
    REFERENCES tax_codes(tax_code);

ALTER TABLE gl_lines 
  ADD CONSTRAINT fk_gll_account FOREIGN KEY (account_id)
    REFERENCES gl_accounts(account_id);

ALTER TABLE gl_lines 
  ADD CONSTRAINT fk_gll_post_key FOREIGN KEY (post_key)
    REFERENCES gl_post_keys(key_id);

CREATE INDEX idx_gl_lines_header ON gl_lines(glh_id);
CREATE INDEX idx_gl_lines_post_key ON gl_lines(post_key);
CREATE INDEX idx_gl_lines_account ON gl_lines(account_id);

-- Constraints para GL_ACCOUNTS
ALTER TABLE gl_accounts 
  ADD CONSTRAINT chk_account_status CHECK (status IN ('A','I'));

ALTER TABLE gl_accounts 
  ADD CONSTRAINT fk_account_currency FOREIGN KEY (currency)
    REFERENCES currencies(currency_code);

ALTER TABLE gl_accounts 
  ADD CONSTRAINT fk_account_tax_code FOREIGN KEY (tax_code)
    REFERENCES tax_codes(tax_code);

ALTER TABLE gl_accounts 
  ADD CONSTRAINT fk_account_withholding_rule FOREIGN KEY (withholding_rule)
    REFERENCES withholding_rules(rule_id);

-- Constraints para GL_POST_KEYS
ALTER TABLE gl_post_keys 
  ADD CONSTRAINT chk_dr_cr_flag CHECK (dr_cr_flag IN ('D','C'));

ALTER TABLE gl_post_keys 
  ADD CONSTRAINT fk_post_key_account FOREIGN KEY (account_id)
    REFERENCES gl_accounts(account_id);

-- Constraints para GL_SPLIT_RULES
ALTER TABLE gl_split_rules 
  ADD CONSTRAINT fk_split_rule_account FOREIGN KEY (account_id)
    REFERENCES gl_accounts(account_id);

ALTER TABLE gl_split_rules 
  ADD CONSTRAINT fk_split_rule_segment FOREIGN KEY (segment_field)
    REFERENCES gl_segments(segment_id);

-- Constraints para GL_WORKFLOW_STATES
ALTER TABLE gl_workflow_states 
  ADD CONSTRAINT chk_state_status CHECK (status IN ('A','I'));

ALTER TABLE gl_workflow_states 
  ADD CONSTRAINT fk_state_approver FOREIGN KEY (approver)
    REFERENCES users(user_id);

CREATE INDEX idx_gl_header_period ON gl_header(period_id);
CREATE INDEX idx_gl_header_state ON gl_header(glh_state);
CREATE INDEX idx_gl_lines_header ON gl_lines(glh_id);
CREATE INDEX idx_gl_lines_post_key ON gl_lines(post_key);
CREATE INDEX idx_gl_lines_account ON gl_lines(account_id);