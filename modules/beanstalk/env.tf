resource "aws_elastic_beanstalk_environment" "ebslab_env" {
  name = format("%s-%s", var.ebs_app_name, var.env)
  application = aws_elastic_beanstalk_application.ebslab_app.name
  solution_stack_name = var.solution_stack_name
  version_label = "${aws_elastic_beanstalk_application_version.app_version.name}"
  
  setting {
      namespace = "aws:ec2:vpc"
      name      = "VPCId"
      value     = var.vpc_id
  }

  setting {
      namespace = "aws:ec2:vpc"
      name      = "Subnets"
      value     = join(",", var.public_subnet_ids)
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = "LoadBalanced"
  }

  setting {
    namespace = "aws:ec2:instances"
    name = "InstanceTypes"
    value = var.instance_type
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "ServiceRole"
    value     = var.service_role_arn
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = aws_iam_instance_profile.instance_profile.name
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "SecurityGroups"
    value     = var.beanstalk_sg_id[0]
  }

  setting {
  namespace = "aws:elasticbeanstalk:environment"
  name      = "LoadBalancerType"
  value     = "application"
  }

  setting {
    namespace = "aws:elbv2:loadbalancer"
    name      = "SecurityGroups"
    value     = var.alb_sg_id[0]
  }

  setting {
    namespace = "aws:elbv2:listener:443"
    name      = "ListenerEnabled"
    value     = true
  }

  setting {
    namespace = "aws:elbv2:listener:443"
    name      = "Protocol"
    value     = "HTTPS"
  }

  setting {
    namespace = "aws:elbv2:listener:443"
    name      = "SSLCertificateArns"
    value     = var.ssl_certificate_arn
  }

  setting {
    namespace = "aws:elbv2:listener:443"
    name      = "SSLPolicy"
    value     = "ELBSecurityPolicy-2016-08"
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "DB_HOST"
    value     = var.db_host
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "DB_PORT"
    value     = var.db_port
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "DB_NAME"
    value     = var.db_name
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "DB_USER"
    value     = var.db_user
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "DB_PASSWORD"
    value     = var.db_password
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "APP_DNS"
    value     = var.zone_name
  }

  setting{
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "DJANGO_PROJECT_URL"
    value     = var.django_project_url
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "APP_IMAGE_URI"
    value     = var.image_uri
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "APP_IMAGE_TAG"
    value     = var.image_tag
  }

  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "DJANGO_PROJECT_NAME"
    value     = "${local.django_project_name}"
  }  

  setting {
    namespace = "aws:autoscaling:asg"
    name      = "Availability Zones"
    value     = "Any"
  }

  tags = {
        "environment-name" = format("%s-%s", var.ebs_app_name, var.env)
  }
  
  depends_on = [ 
    var.ssl_certificate_arn,
    var.ecr_readiness,
    null_resource.get_django_project_name
   ]
}

resource "aws_iam_instance_profile" "instance_profile" {
  name = "aws-elasticbeanstalk-ec2-instance-profile"
  role = var.service_role_name
}

resource "null_resource" "get_django_project_name" {
  provisioner "local-exec" {
    command = <<EOT
    ${path.module}/scripts/find_django_project.sh ${local.django_app_path} > ${local.django_app_path}/project_name.txt
    EOT
  }
  
  triggers = {
    app_version   = aws_elastic_beanstalk_application_version.app_version.name
    django_app_url = var.django_project_url
  }
}

data "local_file" "django_project_name" {
  depends_on = [null_resource.get_django_project_name]
  filename   = "${local.django_app_path}/project_name.txt"
}

locals {
  django_project_name = trimspace(data.local_file.django_project_name.content)
  django_app_path = "${path.root}/django-app"
}
