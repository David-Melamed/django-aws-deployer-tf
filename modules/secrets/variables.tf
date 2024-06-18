variable "kms_alias" {}

variable "db_name" {
  description = "Database name"
  type        = string
  sensitive   = true
  default     = ""
}

variable "db_username" {
  description = "Database username"
  type        = string
  sensitive   = true
  default     = ""
}

variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
  default     = ""
}

variable "credentials" {
  type = map(string)
  default = {
    db_name     = ""
    db_username = ""
    db_password = ""
  }
}