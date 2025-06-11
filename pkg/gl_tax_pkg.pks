-- Purpose : Tax calculation package spec
-- Author  : Diego
-- Date    : 2024-06-01
-- Version : 1.0

CREATE OR REPLACE PACKAGE gl_tax_pkg AS
  -- calculate_tax
  -- p_tax_code : tax code defined in TAX_CODES
  -- p_base     : amount on which tax is calculated
  -- Returns the calculated tax amount
  -- Raises -20009 when TAX_CODE not found
  FUNCTION calculate_tax(p_tax_code IN VARCHAR2,
                         p_base     IN NUMBER)
    RETURN NUMBER;
END gl_tax_pkg;
/
