variable "prod_org_path" {
  type        = string
  description = "An org path for prod AWS accounts"
}

variable "non_prod_ous" {
  type        = list(string)
  description = "List of OUs that contain non-prod AWS accounts"
}

variable "prod_ous" {
  type        = list(string)
  description = "List of OUs that contain prod AWS accounts"
}