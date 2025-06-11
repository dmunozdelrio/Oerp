-- Purpose : UI helpers package spec
-- Author  : Diego
-- Date    : 2024-06-01
-- Version : 1.0

CREATE OR REPLACE PACKAGE gl_ui_pkg AS
  -- validate_post_key
  -- p_post_key : identifier of POST_KEY to validate
  -- Returns mandatory fields for UI
  -- Raises -20008 when POST_KEY not found
  FUNCTION validate_post_key(p_post_key IN gl_post_keys.key_id%TYPE)
    RETURN VARCHAR2;
END gl_ui_pkg;
/
