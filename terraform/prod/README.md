# Prod AWS Account

Creates a badly configured S3 bucket in a for a prod account. We then use the
SCPs to;

1. Prevent identities from prod OUs sending data from prod buckets to sandbox
   OUs and;
2. Preserve the ability for prod identities to promote data from sandbox OUs to
   prod buckets
