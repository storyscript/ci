# ---------------------------------------------------------------------------------------------------------------------
# DEPLOY A GKE PRIVATE CLUSTER IN GOOGLE CLOUD PLATFORM
# This is an example of how to use the gke-cluster module to deploy a private Kubernetes cluster in GCP
# ---------------------------------------------------------------------------------------------------------------------

terraform {
  # The modules used in this example have been updated with 0.12 syntax, additionally we depend on a bug fixed in
  # version 0.12.7.
  required_version = ">= 0.12.7"
}

# ---------------------------------------------------------------------------------------------------------------------
# DEFINE VARIABLES
# ---------------------------------------------------------------------------------------------------------------------

variable "credentials" {
  description = "The GCP JSON Credentials."
  type        = string
}

variable "project" {
  description = "The project ID where all resources will be launched."
  type        = string
}

variable "region" {
  description = "The region for the network. If the cluster is regional, this must be the same region. Otherwise, it should be the region of the zone."
  type        = string
}

variable "dns_zone_name" {
  description = "The name of the DNS zone for DNS records to be created under."
  type        = string
}

variable "domain" {
  description = "The domain under which to record this environment"
  type        = string
}

variable "env_name" {
  description = "The name of the GitHub App."
  type        = string
}

variable "platform_name" {
  description = "The name of the Kubernetes cluster."
  type        = string
}

# ---------------------------------------------------------------------------------------------------------------------
# PREPARE PROVIDERS
# ---------------------------------------------------------------------------------------------------------------------

provider "google" {
  credentials = var.credentials
  version = "~> 2.9.0"
  project = var.project
  region  = var.region
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE A DNS RECORD FOR THIS ENVIRONMENT
# ---------------------------------------------------------------------------------------------------------------------

resource "google_dns_record_set" "default" {
  name = "auth.${var.env_name}.${var.domain}."
  type = "CNAME"
  ttl = 300

  managed_zone = var.dns_zone_name
  rrdatas = [ "auth.${var.platform_name}.${var.domain}." ]
}
