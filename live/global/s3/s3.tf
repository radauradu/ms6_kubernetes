resource "aws_s3_bucket" "my_bucket" {
    bucket = var.bucket

    tags = {
        Name = var.bucket_name
    }
}

resource "aws_s3_bucket_acl" "acl"{
    bucket = aws_s3_bucket.my_bucket.id
    acl = "private"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
    bucket = aws_s3_bucket.my_bucket.id

    rule {
        apply_server_side_encryption_by_default {
            sse_algorithm = "AES256"
        }
    }
}

resource "aws_dynamodb_table" "t_l" {
    name = "student-rr-radaur_ms5_l"
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "LockID"

    attribute {
        name = "LockID"
        type = "S"
    }
}


