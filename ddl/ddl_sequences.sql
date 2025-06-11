-- Purpose : Create sequences for Journal Entry
-- Author  : Diego
-- Date    : 2024-06-01
-- Version : 1.0

CREATE SEQUENCE sq_gl_header START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE sq_gl_lines  START WITH 1 INCREMENT BY 1;
-- Sequence per DOC_TYPE example for 'JE'
CREATE SEQUENCE sq_doc_JE START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE sq_gl_change_log START WITH 1 INCREMENT BY 1;
