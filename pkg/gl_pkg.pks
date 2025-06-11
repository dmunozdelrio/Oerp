-- Purpose : Core business package spec for Journal Entry
-- Author  : Diego
-- Date    : 2024-06-01
-- Version : 1.0

CREATE OR REPLACE PACKAGE gl_pkg AS
  -- init_header
  -- p_doc_type      : document type (must exist in GL_DOC_TYPES)
  -- p_period_id     : accounting period for the header
  -- p_exchange_rate : rate applied to all lines
  -- p_glh_id  (OUT) : generated header ID
  -- Raises -20001 if DOC_TYPE does not exist
  PROCEDURE init_header(p_doc_type      IN gl_header.doc_type%TYPE,
                        p_period_id     IN gl_header.period_id%TYPE,
                        p_exchange_rate IN gl_header.glh_exchange_rate%TYPE,
                        p_glh_id        OUT gl_header.glh_id%TYPE);

  -- add_line
  -- p_glh_id        : header ID that owns the line
  -- p_account_id    : account being posted
  -- p_post_key      : posting key controlling validation
  -- p_cost_center   : optional cost center
  -- p_tax_code      : optional tax code for line
  -- p_debit_amount  : debit amount when POST_KEY flag = 'D'
  -- p_credit_amount : credit amount when POST_KEY flag = 'C'
  -- Raises -20002/-20003 when amount missing,
  --        -20004 when cost center required,
  --        -20005 when POST_KEY is invalid
  PROCEDURE add_line(
                      p_glh_id       IN gl_lines.glh_id%TYPE,
                      p_account_id   IN gl_lines.account_id%TYPE,
                      p_post_key     IN gl_lines.post_key%TYPE,
                      p_cost_center  IN gl_lines.cost_center%TYPE,
                      p_tax_code     IN gl_lines.tax_code%TYPE,
                      p_debit_amount IN gl_lines.debit_amount%TYPE,
                      p_credit_amount IN gl_lines.credit_amount%TYPE
                      );
                  
  -- validate_header
  -- p_glh_id : header to validate
  -- Checks journal balance, document type, open period and
  -- mandatory fields. Raises errors -20006 .. -20013 when
  -- inconsistencies are found
  PROCEDURE validate_header(p_glh_id IN gl_header.glh_id%TYPE);

  -- post_journal
  -- p_glh_id  : journal header to post
  -- p_approver: user approving the journal
  PROCEDURE post_journal(p_glh_id IN gl_header.glh_id%TYPE,
                         p_approver IN gl_header.approver%TYPE);

  -- apply_splits
  -- p_glh_id : journal header whose lines will be split based on
  --            GL_SPLIT_RULES
  PROCEDURE apply_splits(p_glh_id IN gl_header.glh_id%TYPE);

  -- reverse_entries
  -- p_period_id : period whose entries will be reversed in place
  PROCEDURE reverse_entries(p_period_id IN NUMBER);
END gl_pkg;
/
