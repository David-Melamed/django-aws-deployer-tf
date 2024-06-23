output "ssl_certificate_arn" {
  value = aws_acm_certificate.web_cert.arn
}