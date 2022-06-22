# ----------------------------------------------------------------------------------------------------------------------
# Apply Manifests
# ----------------------------------------------------------------------------------------------------------------------
resource "kubectl_manifest" "install_manifests" {
    yaml_body = file("${path.module}/manifests/manifest.yaml")

    depends_on = [
      kubernetes_namespace.cluster_1
    ]
}

resource "kubectl_manifest" "install_populate_jobs" {
    yaml_body = file("${path.module}/populate-jobs/manifest.yaml")
    
    depends_on = [
      kubernetes_namespace.cluster_1
    ]
}