# =============================================================================
# Ingress de ArgoCD
# Modo: ArgoCD corre con --insecure (HTTP puro en puerto 80).
# El Ingress NGINX termina la conexión en HTTP y la proxea al backend.
#
# NOTA: ssl-passthrough NO se usa aquí porque el backend es HTTP.
# Si en el futuro se quita --insecure, cambiar:
#   - backend-protocol → HTTPS
#   - port             → 443
#   - añadir ssl-passthrough = "true"
# =============================================================================
resource "kubernetes_ingress_v1" "argocd_ingress" {
    metadata {
        name      = "argocd-ingress"
        namespace = "argocd"
        annotations = {
            # Selecciona el IngressClass correcto
            "kubernetes.io/ingress.class"                = "nginx"
            # Backend en HTTP porque ArgoCD arranca con --insecure
            "nginx.ingress.kubernetes.io/backend-protocol" = "HTTP"
        }
    }
    spec {
        rule {
            host = "argo.alfonso.local"
            http {
                path {
                    path      = "/"
                    path_type = "Prefix"
                    backend {
                        service {
                            name = "argocd-server"
                            port {
                                # Puerto 80: ArgoCD en modo --insecure usa HTTP
                                number = 80
                            }
                        }
                    }
                }
            }
        }
    }
}