# Terraform

The IaC to setup demo buckets with badly configured policies that help demonstrate setting up an AWS data perimeter.

There are 3 folders each for different accounts.

1. `sandbox` to be deployed to a non-prod account creating a badly configured bucket
2. `prod` to be deployed to a prod account also creating a badly configured bucket
3. `management` to be deployed to the management account provisioning SCPs that help protect the badly configured buckets

The `sandbox` and `prod` folders both use the same S3 bucket module found in `modules`.
