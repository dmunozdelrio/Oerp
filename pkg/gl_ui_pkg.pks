-- Purpose : UI helpers package spec
-- Author  : Codex
-- Date    : 2024-06-01
-- Version : 1.0

CREATE OR REPLACE PACKAGE gl_ui_pkg AS
  FUNCTION validate_post_key(p_post_key IN gl_post_keys.key_id%TYPE)
    RETURN VARCHAR2;
END gl_ui_pkg;
/
