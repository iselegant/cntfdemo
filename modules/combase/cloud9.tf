resource "aws_cloud9_environment_ec2" "management_env" {
  name                        = "${var.resource_id}-management-env"
  instance_type               = "t2.micro"
  automatic_stop_time_minutes = 30
  subnet_id                   = aws_subnet.management["a"].id

  # もしTerraform実行用AWSアクセスキー発行IAMユーザーからCloud9コンソールに
  # アクセスしない場合、owner_arnを指定すること。
  # Ref. https://www.terraform.io/docs/providers/aws/r/cloud9_environment_ec2.html
}
