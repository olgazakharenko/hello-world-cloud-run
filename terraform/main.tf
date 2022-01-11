resource "google_cloud_run_service" "default" {
  provider = google-beta
  name     = "hello-world"
  location = var.gcp_region
  template {
    spec {
      containers {
        image = "gcr.io/${var.gcp_project_id}/${google_artifact_registry_repository.hello-world-images.repository_id}:latest"
      }
    }

    metadata {
      annotations = {
        "autoscaling.knative.dev/maxScale"      = 10
        "run.googleapis.com/client-name"        = "terraform"
      }
    }
  }
  # Cloud Run actually runs in a Google owned Kubernetes cluster, this tells it to run in the Beta version
  # Beta version is needed for Google Secrets Manager (still in Beta)
  metadata {
    annotations = {
      generated-by = "magic-modules"
      "run.googleapis.com/launch-stage" = "BETA"
    }
  }
  
  traffic {
    percent         = 100
    latest_revision = true
  }

  autogenerate_revision_name = true
  
  lifecycle {
    ignore_changes = [
        metadata.0.annotations,
    ]
  }

  depends_on = [null_resource.push-image]
}

# Cloud Run Acess permissions
data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

resource "google_cloud_run_service_iam_policy" "noauth" {
  location    = google_cloud_run_service.default.location
  project     = google_cloud_run_service.default.project
  service     = google_cloud_run_service.default.name

  policy_data = data.google_iam_policy.noauth.policy_data
}

# For adding unique ID to a given instantiation
resource "random_id" "deploy_suffix" {
  byte_length = 4
}