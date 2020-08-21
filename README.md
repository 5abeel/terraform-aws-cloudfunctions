# terraform-aws-cloudfunctions
Terraform AWS Cloud Functions (Lambda) Example

Note: Assumes that AWS S3 bucket is created.

Setup:

Create bucket:
```
aws s3api create-bucket --bucket=tform-srvrless-example --region=us-east-1
```

Terraform init & apply
```
cd terraform
terraform init
terraform apply
```

Invoke/test (can also test via web console)
```
aws lambda invoke --region=us-east-1 --function-name=ServerlessExample2 output.tx
```

Cleanup
Empty/delete bucket
```
aws s3 rm s3://tform-srvrless-example --recursive
aws s3 rb s3://tform-srvrless-example --force  
```