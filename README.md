# Oerp

## Running test scripts

Use SQL*Plus or a compatible client. From the project root run:

```
sqlplus user/password@db @testing/exception_flow_tests.sql
sqlplus user/password@db @testing/approval_flow_test.sql
sqlplus user/password@db @testing/apply_splits_test.sql
```

Replace `user/password@db` with your connection details.
