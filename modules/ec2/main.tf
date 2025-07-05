locals {
  name = "${var.environment}-${var.project_name}-${var.instance_name}"
}
resource "aws_instance" "example" {
  ami                    = var.ami
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = var.security_groups
  monitoring             = var.monitoring
  subnet_id              = var.subnet_id
  iam_instance_profile   = var.iam_instance_profile
  # user_data = var.user_data != null ? var.user_data : null
  tags = merge(
    {
      Name = local.name
    },
    var.common_tags
  )
  lifecycle {
    create_before_destroy = true
  }
}

resource "null_resource" "user_data_exec" {
  count = var.use_null_resource_for_userdata && var.user_data != null ? 1 : 0

  connection {
    type        = "ssh"
    user        = var.remote_exec_user
    private_key = var.private_key
    host        = aws_instance.example.public_ip
  }

  provisioner "remote-exec" {
    inline = [var.user_data]
  }

  depends_on = [aws_instance.example]
  triggers = {
    always_run = timestamp()
  }
}


# userdata was executes during the creation of the instance it does not require ssh access
# when we are using null_resource for userdata execution it requires ssh access


# userdata runs inside the EC2 at launch time and does not need SSH access. 
# But null_resource with remote-exec connects from Terraform using SSH, so it needs port 22 open, key pair, and public access. 
# That’s why user_data is more reliable and preferred for initial configuration during provisioning.
