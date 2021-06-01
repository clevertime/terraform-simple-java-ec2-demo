resource "aws_iam_role" "this" {
  name = join("-", [var.name, "instance"])

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ssm" {
  role       = aws_iam_role.this.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "this" {
  name = join("-", [var.name, "instance"])
  role = aws_iam_role.this.name
}

data "aws_iam_policy_document" "this" {
  statement {
    actions = [
      "s3:List*",
      "s3:Get*",
    ]

    resources = [
      aws_s3_bucket.code.arn,
      join("", [aws_s3_bucket.code.arn, "/*"])
    ]
  }
}

resource "aws_iam_role_policy" "this" {
  name   = join("-", [var.name, "instance"])
  role   = aws_iam_role.this.id
  policy = data.aws_iam_policy_document.this.json
}
