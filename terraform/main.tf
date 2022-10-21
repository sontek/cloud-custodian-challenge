provider "aws" {
    access_key = "c7n"
    secret_key = "left"
    region     = "us-east-1"

    # https://registry.terraform.io/providers/hashicorp/aws/latest/docs#s3_use_path_style
    s3_use_path_style           = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_requesting_account_id  = true

    endpoints {
        s3             = "http://localhost:4566"
    }

}

resource "aws_s3_bucket" "unencrypted-bucket" {
    bucket = "my-unencrypted-bucket"
}
