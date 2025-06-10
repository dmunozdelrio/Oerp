-- Purpose : Create views for Journal Entry
-- Author  : Codex
-- Date    : 2024-06-01
-- Version : 1.0

CREATE OR REPLACE VIEW gl_header_v AS
SELECT h.*, d.description AS doc_description
  FROM gl_header h
  LEFT JOIN gl_doc_types d ON h.doc_type = d.doc_type;

CREATE OR REPLACE VIEW gl_lines_v AS
SELECT l.*, h.doc_no, h.doc_type
  FROM gl_lines l
  JOIN gl_header h ON l.glh_id = h.glh_id;
