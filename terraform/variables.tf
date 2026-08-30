variable "region" {
  type        = string
  description = "The target aws region"
  default     = "us-east-1"
}

variable "domain" {
  type        = string
  description = "The target domain the repository is served from"
  default     = "axr.frigon.app"
}

variable "zone" {
  type        = string
  description = "The target zone to add records to"
  default     = "frigon.app"
}
