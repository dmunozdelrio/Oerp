-- Purpose : Add constraints and indexes for Journal Entry
-- Author  : Codex
-- Date    : 2024-06-01
-- Version : 1.0

ALTER TABLE gl_header ADD CONSTRAINT fk_glh_doctype FOREIGN KEY (doc_type)
    REFERENCES gl_doc_types(doc_type);

ALTER TABLE gl_lines ADD CONSTRAINT fk_gll_header FOREIGN KEY (glh_id)
    REFERENCES gl_header(glh_id);

ALTER TABLE gl_lines ADD CONSTRAINT fk_gll_tax FOREIGN KEY (tax_code)
    REFERENCES tax_codes(tax_code);

CREATE INDEX idx_gl_lines_header ON gl_lines(glh_id);
CREATE INDEX idx_gl_lines_post_key ON gl_lines(post_key);

ALTER TABLE gl_header ADD CONSTRAINT fk_glh_state FOREIGN KEY (glh_state)
    REFERENCES gl_workflow_states(state_id);
CREATE INDEX idx_gl_header_period ON gl_header(period_id);
CREATE INDEX idx_gl_header_state ON gl_header(glh_state);
