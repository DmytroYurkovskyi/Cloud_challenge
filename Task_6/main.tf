resource "google_storage_bucket" "static-site" {
    name          = "dimon-uniquebucket123"
    location      = "EU"
    force_destroy = true
  
    uniform_bucket_level_access = false
  
    website {
      main_page_suffix = "index.html"
      not_found_page   = "404.html"
    }
    cors {
      origin          = ["http://image-store.com"]
      method          = ["GET", "HEAD", "PUT", "POST", "DELETE"]
      response_header = ["*"]
      max_age_seconds = 3600
    }

  }
  resource "google_storage_bucket_iam_member" "member" {
    bucket = "dimon-uniquebucket123"
    role = "roles/storage.admin"
    member = "allUsers"
  }


  
  resource "google_compute_instance" "dare-id-vm" {
    name         = "dymitr-vm-2"
    machine_type = "e2-small"
    zone         = "europe-west1-b"
  
    tags = ["dareit-public", "http-server", "https-server","dareit"]
  
    boot_disk {
      initialize_params {
        image = "debian-cloud/debian-11"
        labels = {
          managed_by_terraform = "true"
        }
      }
    }
  
    network_interface {
      network = "default"
  
      access_config {
        // Ephemeral public IP
      }
    }
  }



  resource "google_sql_database" "database" {
    name     = "dare-it"
    instance = "dare-it-instance"
    
  }
  resource "google_sql_user" "users" {
    name     = "dareit_user"
    instance = "dare-it-instance"
    password = "changeme"
  }
resource "google_sql_database_instance" "main" {
    name             = "dare-it-instance"
    database_version = "POSTGRES_14"
    region           = "us-central1"
  
    settings {
      # Second-generation instance tiers are based on the machine
      # type. See argument reference below.
      tier = "db-f1-micro"
    }
    deletion_protection  = "false"
  }
