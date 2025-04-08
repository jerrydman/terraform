resource "aws_kms_key" "key" {
  multi_region             = var.multi_region
  description              = var.description
  key_usage                = var.key_usage
  customer_master_key_spec = var.cmk_spec
  deletion_window_in_days  = var.deletion_window_in_days
  is_enabled               = var.is_enabled
  enable_key_rotation      = var.enable_key_rotation
}