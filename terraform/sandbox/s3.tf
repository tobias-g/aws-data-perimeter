module "bad_bucket" {
  source      = "../modules/not_secure_s3"
  environment = "sandbox"
}