
# For loop we are not creating any Iam user resource

variable "user_names" {
  description = "IAM Usernames"
  type = list(string)
  default = [ "user1", "user2", "user3" ]
}

output "Print_the_names" {
  value = [for names in var.user_names :  name]
}