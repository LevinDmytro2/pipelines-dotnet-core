resource "aws_secretsmanager_secret" "rds_password" {
  name = "rds_password-3"
  recovery_window_in_days = 0
}


resource "aws_secretsmanager_secret_version" "rds_password_version" {
  secret_id     = aws_secretsmanager_secret.rds_password.id
  secret_string = random_string.rds_password_string.result
  
}

resource "random_string" "rds_password_string" {
  length           = 16
  special          = false

}