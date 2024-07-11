resource "aws_s3_bucket" "back_end_state" {
    bucket_prefix = "practice-state-bucket"
}

resource "local_file" "state_bucket_name" {
    content  = aws_s3_bucket.back_end_state.bucket
    filename = "state_bucket_name.txt"
}