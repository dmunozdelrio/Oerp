-- Purpose : Default values for GL_HEADER from reference tables
-- Author  : Codex
-- Date    : 2024-06-02
-- Version : 1.0

CREATE OR REPLACE TRIGGER tr_gl_header_defaults
BEFORE INSERT OR UPDATE ON gl_header
FOR EACH ROW
BEGIN
  IF :NEW.tax_code IS NOT NULL THEN
    BEGIN
      SELECT rate
        INTO :NEW.tax_rate
        FROM tax_codes
       WHERE tax_code = :NEW.tax_code;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20014, 'Tax code not found');
    END;
  ELSE
    :NEW.tax_rate := NULL;
  END IF;
END;
/
