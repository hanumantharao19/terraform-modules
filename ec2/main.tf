
resource "aws_instance" "this" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.vpc_security_group_ids
  iam_instance_profile        = var.iam_instance_profile
  key_name                    = var.key_name
  associate_public_ip_address = var.associate_public_ip_address
  monitoring                  = var.monitoring
  disable_api_termination     = var.disable_api_termination

  user_data = var.user_data

  # Require IMDSv2 to reduce metadata-service exposure.
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
  }

  root_block_device {
    volume_size           = var.root_volume_size
    volume_type           = var.root_volume_type
    encrypted             = true
    kms_key_id            = var.kms_key_id
    delete_on_termination = var.delete_root_volume_on_termination

    iops = (
      var.root_volume_type == "gp3" ?
      var.root_volume_iops : null
    )

    throughput = (
      var.root_volume_type == "gp3" ?
      var.root_volume_throughput : null
    )

    tags = merge(
      var.tags,
      {
        Name = "${var.name}-root"
      }
    )
  }

  tags = merge(
    var.tags,
    {
      Name = var.name
    }
  )

  lifecycle {
    precondition {
      condition = (
        var.root_volume_type != "gp3" ||
        (
          (var.root_volume_iops == null ||
            (var.root_volume_iops >= 3000 &&
              var.root_volume_iops <= 16000)) &&
          (var.root_volume_throughput == null ||
            (var.root_volume_throughput >= 125 &&
              var.root_volume_throughput <= 1000))
        )
      )
      error_message = "For gp3, IOPS must be between 3000 and 16000 and throughput between 125 and 1000 MiB/s when specified."
    }
  }
}

