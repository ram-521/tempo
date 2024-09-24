provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

# Reference existing observability namespace
data "kubernetes_namespace" "observability" {
  metadata {
    name = "observability"
  }
}
# Tempo (using local chart or pre-installed chart)
resource "helm_release" "tempo" {
  name      = "tempo"
  namespace = "observability"

  # Path to your local Helm chart directory for Tempo
  chart      = "/home/ram/tempo/grafana-tempo"

  values = [
    file("/home/ram/tempo/grafana-tempo/values.yaml")
  ]
}

# Grafana (using local chart or pre-installed chart)
resource "helm_release" "grafana" {
  name      = "grafana"
  namespace = "observability"

  # Path to your local Helm chart directory for Grafana
  chart      = "/home/ram/tempo/grafana-tempo"

  values = [
    file("/home/ram/tempo/grafana-tempo/values.yaml")
  ]
}

# Apply the OpenTelemetry Collector YAML file (if needed)
#resource "kubernetes_manifest" "otel_collector" {
 # yaml_body = file("/app/tempo/otel-collector.yaml")
  #depends_on = [helm_release.opentelemetry_operator]
#}

