## Create SA sa-storage-admin
resource "yandex_iam_service_account" "sa-storage-admin" {
  folder_id = var.yc_folder_id
  name      = "sa-storage-admin"
}

## Grant permissions 
resource "yandex_resourcemanager_folder_iam_member" "sa-storage-admin" {
  folder_id = var.yc_folder_id
  role      = "storage.admin"
  member    = "serviceAccount:${yandex_iam_service_account.sa-storage-admin.id}"
}

## Create Static Access Keys
resource "yandex_iam_service_account_static_access_key" "sa-storage-admin-static-key" {
  service_account_id = yandex_iam_service_account.sa-storage-admin.id
  description        = "static access key for object storage"
}

## Use keys to create bucket
resource "yandex_storage_bucket" "test-bucket" {
  access_key = yandex_iam_service_account_static_access_key.sa-storage-admin-static-key.access_key
  secret_key = yandex_iam_service_account_static_access_key.sa-storage-admin-static-key.secret_key
  bucket     = "test-bucket"
}

## Output values
output "access_key_sa_storage_admin_for_test_bucket" {
  description = "access_key sa-storage-admin for test-bucket"
  value = yandex_storage_bucket.test-bucket.access_key
  sensitive = true
}

output "secret_key_sa_storage_admin_for_test_bucket" {
  description = "secret_key sa-storage-admin for test-bucket"
  value = yandex_storage_bucket.test-bucket.secret_key
  sensitive = true
}

