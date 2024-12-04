provider "aws" {
  region = "us-east-2"  # Specify your region
}



resource "aws_ssm_document" "ansible_attach" {
  name          = "Install-Apache"
  document_type = "Command"
  content = jsonencode({
    schemaVersion = "2.2"
    description   = "Test Install with Hello World"
    mainSteps = [
      {
        action = "aws:runShellScript"
        name   = "attachToAnsible"
        inputs = {
          runCommand = [
              "sudo dnf update -y",
              "sudo dnf install ansible -y ",
              "sudo dnf install  python3  python-pip -y ",
              "ansible-pull -U githubrepo yml_file"
          ]
        }
      }
    ]
  })
}
