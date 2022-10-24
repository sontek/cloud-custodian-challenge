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

resource "aws_s3_bucket" "aes-encrypted-bucket" {
    bucket = "my-aes-encrypted-bucket"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "aes-encrypted-configuration" {
  bucket = aws_s3_bucket.aes-encrypted-bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
    }
  }
}

resource "aws_s3_bucket" "kms-encrypted-bucket" {
    bucket = "my-kms-encrypted-bucket"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "kms-encrypted-configuration" {
  bucket = aws_s3_bucket.kms-encrypted-bucket.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_dynamodb_table" "cool-dynamo-table" {
  name             = "TestTable"
  hash_key         = "BrodoBaggins"
  billing_mode     = "PAY_PER_REQUEST"
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  attribute {
    name = "BrodoBaggins"
    type = "S"
  }
}

resource "aws_dynamodb_table" "non-replicated-dynamo-table" {
  name             = "UnreplicatedTable"
  hash_key         = "NoReplication"
  billing_mode     = "PAY_PER_REQUEST"
  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"

  attribute {
    name = "NoReplication"
    type = "S"
  }
}

resource "aws_dynamodb_table_replica" "cool-dynamo-table-replica" {
  global_table_arn = aws_dynamodb_table.cool-dynamo-table.arn
}

resource "aws_dynamodb_tag" "label-cool-dynamo" {
  resource_arn = aws_dynamodb_table.cool-dynamo-table.arn
  key          = "owner"
  value        = "sontek"
}
