-- Purpose : Tax calculation package spec
-- Author  : Diego
-- Date    : 2024-06-01
-- Version : 1.0

CREATE OR REPLACE PACKAGE gl_tax_pkg AS
  FUNCTION calculate_tax(p_tax_code IN VARCHAR2, p_base IN NUMBER) RETURN NUMBER;
END gl_tax_pkg;
/
