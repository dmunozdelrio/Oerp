# Oerp

## Oracle Journal Entry Module

This project contains PL/SQL code for capturing and managing General Ledger
journal entries. Procedures in [`gl_pkg`](pkg/gl_pkg.pks) allow you to:

* initialize journal headers and add transaction lines;
* validate that a journal is balanced and complete;
* post journals once approved;
* split lines according to configured rules; and
* generate reversing entries via the scheduler job in
  [`jobs/reverse_job.sql`](jobs/reverse_job.sql).

## Running test scripts

Use an Oracle client that provides the `sqlplus` command. Ensure typical
environment variables such as `ORACLE_HOME` and `PATH` are set so the client
tools can be found. From the project root run:

```
sqlplus user/password@db @testing/exception_flow_tests.sql
sqlplus user/password@db @testing/approval_flow_test.sql
sqlplus user/password@db @testing/apply_splits_test.sql
```

Replace `user/password@db` with your connection details.
