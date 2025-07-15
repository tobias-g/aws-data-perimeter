# AWS Config + S3 Data Perimeter Rule

Terraform module to encapsulate the provisioning of AWS config and a Lambda
function used for the rule to check if S3 bucket policies are compliant with our
data perimeter.

The function checks if the bucket has a policy and that policy blocks all access
from identities outside our current AWS org.
