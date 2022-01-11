resource "google_artifact_registry_repository" "hello-world-images" {
  provider = google-beta

  project       = var.gcp_project_id
  location      = var.gcp_region
  repository_id = "helloworld-${random_id.deploy_suffix.hex}"
  description   = "helloworld project repo"
  format        = "DOCKER"
}
resource "null_resource" "push-image" {
  provisioner "local-exec" {
    command = "gcloud builds submit --tag=gcr.io/${var.gcp_project_id}/${google_artifact_registry_repository.hello-world-images.repository_id}:latest ../"
  }

  depends_on = [google_artifact_registry_repository.hello-world-images]
}
