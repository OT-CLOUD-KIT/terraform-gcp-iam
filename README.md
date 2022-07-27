# GCP cloud Storage

[![Opstree Solutions][opstree_avatar]][opstree_homepage]<br/>[Opstree Solutions][opstree_homepage] 

  [opstree_homepage]: https://opstree.github.io/
  [opstree_avatar]: https://img.cloudposse.com/150x150/https://github.com/opstree.png

  - This terraform module will create storage buckets.
  - This project is a part of opstree's ot-gcp initiative for terraform modules.

# Overview of GCP IAM
IAM lets you grant granular access to specific Google Cloud resources and helps prevent access to other resources. IAM lets you adopt the security principle of least privilege, which states that nobody should have more permissions than they actually need.

## Usage

```
terraform {
  required_providers {
    google = {
      version = "~> 4.19.0"
    }
  }
  required_version = "~>1.1.3"
}

# Configure the GCP Provider

provider "google" {
  credentials = file("<service_account_key_json/p12_file")
  project     = "<project-id>"
  region      = "<region>"
}

#Basic use of this module:


### Contributors


  [neelamnegi_homepage]: https://github.com/neeelamnegi
