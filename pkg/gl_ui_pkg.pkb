-- Purpose : UI helpers package body
-- Author  : Codex
-- Date    : 2024-06-01
-- Version : 1.0

CREATE OR REPLACE PACKAGE BODY gl_ui_pkg AS
  FUNCTION validate_post_key(p_post_key IN gl_post_keys.key_id%TYPE)
    RETURN VARCHAR2 IS
    v_fields VARCHAR2(200);
  BEGIN
    SELECT mandatory_fields INTO v_fields
      FROM gl_post_keys WHERE key_id = p_post_key;
    RETURN v_fields;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20008, 'Post key not found');
  END validate_post_key;
END gl_ui_pkg;
/
