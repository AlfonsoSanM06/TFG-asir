# =============================================================================
# backend.tf — Configuración del backend de estado de Terraform.
#
# OPCIÓN A (activa): backend local — el .tfstate se guarda en disco.
#   ✔ Válido para laboratorio / desarrollo.
#   ✗ No compartido entre miembros del equipo.
#
# OPCIÓN B (comentada): backend S3-compatible (MinIO, AWS S3, etc.)
#   Descomenta y ajusta para entornos de equipo / CI-CD.
#
# OPCIÓN C (comentada): Terraform Cloud / HCP Terraform
#   Descomenta y ajusta si usáis la plataforma SaaS de HashiCorp.
# =============================================================================

terraform {
  # ---------------------------------------------------------------------------
  # OPCIÓN A — Estado local (por defecto)
  # ---------------------------------------------------------------------------
  # No se requiere configuración explícita; Terraform usa terraform.tfstate
  # en el directorio de trabajo. Asegúrate de que .gitignore lo excluye.

  # ---------------------------------------------------------------------------
  # OPCIÓN B — Backend S3-compatible (MinIO en el homelab, AWS S3 en la nube)
  # ---------------------------------------------------------------------------
  # backend "s3" {
  #   bucket                      = "tfg-terraform-state"
  #   key                         = "arq3d/infrastructure/terraform.tfstate"
  #   region                      = "us-east-1"          # Requerido por el SDK aunque sea MinIO
  #   endpoint                    = "http://192.168.10.50:9000"
  #   skip_credentials_validation = true
  #   skip_metadata_api_check     = true
  #   skip_region_validation      = true
  #   force_path_style            = true
  #   access_key                  = "REEMPLAZA_MINIO_ACCESS_KEY"
  #   secret_key                  = "REEMPLAZA_MINIO_SECRET_KEY"
  # }

  # ---------------------------------------------------------------------------
  # OPCIÓN C — Terraform Cloud / HCP Terraform
  # ---------------------------------------------------------------------------
  # backend "remote" {
  #   hostname     = "app.terraform.io"
  #   organization = "arq3d"
  #   workspaces {
  #     name = "arq3d-infrastructure"
  #   }
  # }
}
