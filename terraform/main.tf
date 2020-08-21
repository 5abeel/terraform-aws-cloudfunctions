provider "aws" {
  region = "us-east-1"
}

variable "s3_bucket_name" {
  default = "tform-srvrless-example"
}

data "archive_file" "src" {
  type        = "zip"
  source_dir  = "${path.root}/../src" # Directory where your Python source code is
  output_path = "${path.root}/../generated/src.zip"
}

resource "aws_s3_bucket_object" "file_upload" {
  bucket = var.s3_bucket_name
  #key    = "${data.archive_file.src.output_md5}.zip"
  key    = "src.zip"
  source = "${path.root}/../generated/src.zip"
}


resource "aws_lambda_function" "example" {
  function_name = "ServerlessExample2"

  # The bucket name as created earlier with "aws s3api create-bucket"
  s3_bucket = var.s3_bucket_name
  s3_key    = aws_s3_bucket_object.file_upload.key # depends on upload key


  # "main" is the filename within the zip file (main.js) and "handler"
  # is the name of the property under which the handler function was
  # exported in that file.
  handler = "main.http_handler"
  runtime = "python3.7"

  environment {
    variables = {
      FOO = "bar2"
    }
  }
  role = aws_iam_role.lambda_exec.arn
}

# IAM role which dictates what other AWS services the Lambda function
# may access.
resource "aws_iam_role" "lambda_exec" {
  name = "serverless_example_lambda"

  assume_role_policy = <<EOF
{
   "Version": "2012-10-17",
   "Statement": [
     {
       "Action": "sts:AssumeRole",
       "Principal": {
         "Service": "lambda.amazonaws.com"
       },
       "Effect": "Allow",
       "Sid": ""
     }
   ]
 }
 EOF

}

