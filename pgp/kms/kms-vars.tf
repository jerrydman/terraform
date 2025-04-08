variable "tag_map" {
description = "Tags"
}

variable "description" {
  description = "The description of the key as viewed in AWS console. Defaults to empty string."
  default     = ""
}

variable "key_usage" {
  description = "Specifies the intended use of the key. Defaults to ENCRYPT_DECRYPT, since it is the only valid value."
  default     = "ENCRYPT_DECRYPT"
}

variable "cmk_spec" {
  description = "Specifies whether the key contains a symmetric key or an asymmetric key pair and the encryption algorithms or signing algorithms that the key supports."
  default = "SYMMETRIC_DEFAULT"
}

variable "deletion_window_in_days" {
  description = "Duration in days after which the key is deleted after destruction."
  default     = 30
}

variable "is_enabled" {
  description = "Specifies whether the key is enabled. Defaults to true."
  default     = true
}

variable "enable_key_rotation" {
  description = "Specifies whether automatic key rotation is enabled. Defaults to true."
  default     = true
}

variable "multi_region" {
  description = "Enable multiregion kms key."
  default     = false
}