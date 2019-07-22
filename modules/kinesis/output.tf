output "kinesis" {
  value = "${
    map(
      "arn", "${aws_kinesis_firehose_delivery_stream.test_stream.arn}"
    )
  }"
}

