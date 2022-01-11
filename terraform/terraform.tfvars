# GCP Settings
gcp_project_id = "sandbox-20211104-56a3rx"
gcp_region     = "us-east1"
gcp_auth_file  = "~/.gcloud-keys/sandbox-20211104-56a3rx-auto-report-sa.json" 

# Cloud Run application settings
db_username = "mainappuser"
debuglevel = "DEBUG"
max_scaling = "10" # Max instances at one time
server_port = "8080" # Container port (not external to web)
