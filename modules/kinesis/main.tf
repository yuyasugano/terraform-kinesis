resource "aws_s3_bucket" "bucket" {
    bucket = "${lookup(var.kinesis, "${terraform.env}.destination_bucket_name", var.kinesis["default.destination_bucket_name"])}"
    acl = "${lookup(var.kinesis, "${terraform.env}.destination_bucket_acl", var.kinesis["default.destination_bucket_acl"])}"
}

resource "aws_iam_role" "firehose_role" {
    name = "firehose_test_role"

    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "firehose.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_kinesis_firehose_delivery_stream" "test_stream" {
    name = "${lookup(var.kinesis, "${terraform.env}.name", var.kinesis["default.name"])}"
    destination = "${lookup(var.kinesis, "${terraform.env}.destination", var.kinesis["default.destination"])}"

    s3_configuration {
        role_arn = "${aws_iam_role.firehose_role.arn}"
        bucket_arn = "${aws_s3_bucket.bucket.arn}"
    }
}



