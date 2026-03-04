# API Deployment
resource "kubernetes_deployment" "api" {
  metadata {
    name      = "api"
    namespace = "fridhemfighters"
    labels = {
      app  = "api"
      tier = "backend"
    }
  }

  spec {
    replicas = 2

    selector {
      match_labels = {
        app = "api"
      }
    }

    template {
      metadata {
        labels = {
          app  = "api"
          tier = "backend"
        }
      }

      spec {
        image_pull_secrets {
          name = "gcr-secret"
        }

        container {
          name              = "api"
          image             = "gcr.io/chas-devsecops-2026/team-dashboard-api:v1"
          image_pull_policy = "Always"

          port {
            container_port = 3000
            name           = "http"
          }

          env_from {
            config_map_ref {
              name = "api-config"
            }
          }

          resources {
            requests = {
              cpu    = "100m"
              memory = "128Mi"
            }
            limits = {
              cpu    = "200m"
              memory = "256Mi"
            }
          }

          liveness_probe {
            http_get {
              path = "/health"
              port = "3000"
            }
            initial_delay_seconds = 10
            period_seconds        = 10
          }

          readiness_probe {
            http_get {
              path = "/health"
              port = "3000"
            }
            initial_delay_seconds = 5
            period_seconds        = 5
          }
        }
      }
    }
  }
}

# API Service
resource "kubernetes_service" "api_service" {
  metadata {
    name      = "api-service"
    namespace = "fridhemfighters"
    labels = {
      app = "api"
    }
  }

  spec {
    type = "ClusterIP"
    selector = {
      app = "api"
    }

    port {
      port        = 3000
      target_port = 3000
      protocol    = "TCP"
      name        = "http"
    }
  }
}
