# Hipster Click To Deploy

Requirement: **GCP PROJECT INTO WHICH TO DEPLOY**

# Tool Setup Guide

[Tool Install Guide](tools/ReadMe.md)

# Environment Setup
* Install tools
* Run the following commands to login to gcloud:
```
gcloud auth login
gcloud auth application-default login
```

This will setup your permissions for terraform to run.

# Deploy guide
```
cd terraform
terraform init
terraform plan
terraform apply
```

# After it has applied time to apply kubernetes yaml
```
mv main8.tfx main.tf
terraform init --upgrade
terrafrom plan
terraform apply
```