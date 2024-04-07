variable "server_port" {
  description = "The port that the server will use to handle HTTP requests"
  default     = 8080
  type        = number

  validation {
    condition     = var.server_port > 0 && var.server_port < 65536
    error_message = "The port number must be between 1 - 65535"
  }

  sensitive = true
}
