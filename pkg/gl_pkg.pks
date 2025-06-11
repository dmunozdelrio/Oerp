-- Purpose : Core business package spec for Journal Entry
-- Author  : Diego
-- Date    : 2024-06-01
-- Version : 1.0

CREATE OR REPLACE PACKAGE gl_pkg AS
  PROCEDURE init_header(p_doc_type      IN gl_header.doc_type%TYPE,
                        p_period_id     IN gl_header.period_id%TYPE,
                        p_exchange_rate IN gl_header.glh_exchange_rate%TYPE,
                        p_glh_id        OUT gl_header.glh_id%TYPE);

  PROCEDURE add_line(
                      p_glh_id       IN gl_lines.glh_id%TYPE,
                      p_account_id   IN gl_lines.account_id%TYPE,  -- se recibe el valor de cuenta
                      p_post_key     IN gl_lines.post_key%TYPE,
                      p_cost_center  IN gl_lines.cost_center%TYPE,
                      p_tax_code     IN gl_lines.tax_code%TYPE,
                      p_debit_amount IN gl_lines.debit_amount%TYPE,
                      p_credit_amount IN gl_lines.credit_amount%TYPE
                      );
                  
  PROCEDURE validate_header(p_glh_id IN gl_header.glh_id%TYPE);
  PROCEDURE post_journal(p_glh_id IN gl_header.glh_id%TYPE,
                         p_approver IN gl_header.approver%TYPE);
  PROCEDURE apply_splits(p_glh_id IN gl_header.glh_id%TYPE);
  PROCEDURE reverse_entries(p_period_id IN NUMBER);
END gl_pkg;
/
