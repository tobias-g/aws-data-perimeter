# Sandbox AWS Account

Creates a badly configured S3 bucket in a for a sandbox account. We then use the
SCPs to;

1. Prevent identities from sandbox OUs accessing data the bucket in prod and;
2. Prevent identities from sandbox OUs promoting data to the bucket in prod
