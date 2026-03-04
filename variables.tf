# variables.tf — team-specific configuration

variable "fridhemfighters" {
  description = "Your team's Kubernetes namespace"
  type        = string
  # Replace with your namespace:
  default     = "fridhemfighters"
}

variable "team_name" {
  description = "Your team's display name"
  type        = string
  default     = "FridhemFighters"
}

variable "monitor_api_key" {
  description = "API-nyckeln för Team Flags"
  type        = string
  sensitive   = true  # Detta gör att värdet döljs i loggarna
}