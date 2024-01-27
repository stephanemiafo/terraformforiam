terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1" # var.region 
}


# Create IAM users
resource "aws_iam_user" "myusers" {
  count = 3                          # NUMBER OF IAM USERS
  name  = var.user_name[count.index] # NAME OF USERS IN ORDER AFTER CREATION
  tags = {
    Name = "${var.aws_iam_user_tags[count.index]}" # name in ligne 6 or referencing ligne 6 to tag.
  }
}

variable "user_name" {
  description = "allowed iam users name."
  type        = list(string) #MADE THIS CHOICE TO ALLOW THE "count-argument" TO LIST THEM IN ORDER USING THEIR INDEX.
  default     = ["engineer_test_user", "security_test_user", "operation_test_user"]
}

variable "aws_iam_user_tags" {
  description = "allowed iam users"
  type        = list(string) #MADE THIS CHOICE TO ALLOW THE "count-argument" TO LIST THEM IN ORDER USING THEIR INDEX.
  default     = ["engineers_team_user", "security_team_user", "operations_team_user"]
}

output "iam_user_name" {
  value = aws_iam_user.myusers[*].name
}

# Create IAM groups.
resource "aws_iam_group" "user_groups" {
  count = 3
  name  = var.user_group_name[count.index] # NAME OF USERS IN ORDER AFTER CREATION
}

variable "user_group_name" {
  description = "allowed iam group name."
  type        = list(string) # MADE THIS CHOICE TO ALLOW THE "count-argument" TO LIST THEM IN ORDER USING THEIR INDEX.
  default     = ["engineer_team", "security_team", "operation_team"]
}

output "user_group_name" {
  value = aws_iam_group.user_groups[*].name
}

# Assign IAM users to IAM groups
resource "aws_iam_user_group_membership" "user_group_membership" {
  count  = 3
  user   = aws_iam_user.myusers[count.index].name
  groups = [aws_iam_group.user_groups[count.index].name]
}

# Create IAM user login profiles.
resource "aws_iam_user_login_profile" "team_user_login" {
  count                   = 3
  user                    = aws_iam_user.myusers[count.index].name
  password_length         = var.password_length[count.index] # Set the desired password length. Default is 20
  password_reset_required = true                             # Forcing the user to reset the password on first login.
}

variable "password_length" {
  description = "Password lengths for IAM users."
  type        = list(number)
  default     = [22, 25, 23]
}

output "automatic_password" {
  value = aws_iam_user_login_profile.team_user_login[*].password
}

# Create a list containing policies for each group.
locals {
  group_policies = [
    # Policy for engineers
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Action" : "*",
          "Effect" : "Allow",      
          "Resource" : "*"
        },
        {
          "Action" : "aws-portal:*",
          "Effect" : "Deny",
          "Resource" : "*"
        },
      ]
    },
    # Policy for security.
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : "*",
          "Resource" : "*"
        }
      ]
    },
    # Policy for operation.
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Action" : "*",
          "Resource" : "*",
          "Condition" : {
            "StringEquals" : {
              "aws:RequestedRegion" : "us-east-1"
            }
          }
        }
      ]
    }
  ]
}

# Create group policies.
resource "aws_iam_group_policy" "group_policies" {
  count   = 3         # This resource will iterate 3 times
  name    = var.group_policy_names[count.index]
  group   = aws_iam_group.user_groups[count.index].name   # Names of different groups affter iteration.
  policy  = jsonencode(local.group_policies[count.index])   # This is set based on the index using local.group_policies[count.index].
}

variable "group_policy_names" {
  description = "Names for IAM group policies."
  type        = list(string)
  default     = ["engineer_policy", "security_policy", "operation_policy"]
}

output "engineer_policy_name" {
  value = aws_iam_group_policy.group_policies[*].name
}