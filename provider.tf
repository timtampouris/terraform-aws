/* Setup AWS provider */
provider "aws" {
  version     = "1.28"
  region      = "${var.aws_region}"
  access_key  = "YOUR-ACCESS-KEY"
  secret_key  = "YOUR-ACCESS-SECRET-KEY"
  max_retries = 3
}
