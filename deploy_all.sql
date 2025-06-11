-- Purpose : Master deployment script for Journal Entry module
-- Author  : Codex
-- Date    : 2024-06-01
-- Version : 1.0
-- 0 delete all objects before deployment
@ddl/dd_drop.sql
-- 1. Tables

@ddl/ddl_tables.sql

-- 2. Sequences
@ddl/ddl_sequences.sql

-- 3. Constraints and Indexes
@ddl/ddl_constraints.sql

-- 4. Views
@ddl/ddl_views.sql

-- 5. Packages
@pkg/gl_pkg.pks
@pkg/gl_pkg.pkb
@pkg/gl_ui_pkg.pks
@pkg/gl_ui_pkg.pkb
@pkg/gl_tax_pkg.pks
@pkg/gl_tax_pkg.pkb
@pkg/gl_report_pkg.pks
@pkg/gl_report_pkg.pkb

-- 6. Triggers
@triggers/tr_gl_header_log.sql
@triggers/tr_gl_lines_log.sql
@triggers/tr_gl_header_defaults.sql

-- 7. Scheduler jobs
@jobs/reverse_job.sql

-- 8. Seed data
@ddl/seed_data.sql
