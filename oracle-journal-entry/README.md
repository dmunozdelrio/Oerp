# Oracle Journal Entry Module

PL/SQL package [`gl_pkg`](../pkg/gl_pkg.pks) implements the Journal Entry
workflow used throughout this project:

* `init_header` creates a journal header.
* `add_line` inserts lines for accounts and amounts.
* `validate_header` checks that the entry is balanced and that mandatory fields
  such as cost centers are provided.
* `post_journal` marks the entry as posted after approval.
* `apply_splits` expands lines according to configured split rules.
* `reverse_entries` generates reversing journals and is typically invoked by the
  scheduler job defined in [`../jobs/reverse_job.sql`](../jobs/reverse_job.sql).
