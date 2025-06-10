-- Purpose : Tax calculation package body
-- Author  : Codex
-- Date    : 2024-06-01
-- Version : 1.0

CREATE OR REPLACE PACKAGE BODY gl_tax_pkg AS
  FUNCTION calculate_tax(p_tax_code IN VARCHAR2, p_base IN NUMBER) RETURN NUMBER IS
    v_rate NUMBER;
  BEGIN
    SELECT rate INTO v_rate FROM tax_codes WHERE tax_code = p_tax_code;
    RETURN NVL(v_rate,0) * p_base / 100;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20009, 'Tax code not found');
  END calculate_tax;
END gl_tax_pkg;
/
