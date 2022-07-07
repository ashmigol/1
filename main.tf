terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.75.0"
    }
  }

  backend "s3" {
    endpoint   = "storage.yandexcloud.net"
    bucket     = "ashmigol"
    region     = "ru-central1-a"
    key        = "issue1/lemp.tfstate"
    access_key = "YCAJE5pqwMTUNr5su4c6feJ4_"
    secret_key = "YCOPl5fXJ-k6o2cz0wyedWWK1AKyKI1SPuLFEwlx"


    skip_region_validation      = true
    skip_credentials_validation = true
  }
}

provider "yandex" {
  token     = "AQAAAABiZOW0AATuwU5bE9RlsUIyiEsopOIq6Pg"
  cloud_id  = "b1gvp97p176eglfpbqv9"
  folder_id = "b1gr1in1jn1mqa5glht0"
  zone      = "ru-central1-a"
}

# Создаем сервис-аккаунт SA
# resource "yandex_iam_service_account" "sa" {
#  folder_id = var.folder_id
#   name      = "sa-skillfactory"
# }

# Даем права на запись для этого SA
# resource "yandex_resourcemanager_folder_iam_member" "sa-editor" {
#  folder_id = var.folder_id
#  role      = "storage.editor"
#  member    = "serviceAccount:${yandex_iam_service_account.sa.id}"
#}

# Создаем ключи доступа Static Access Keys
#resource "yandex_iam_service_account_static_access_key" "sa-static-key" {
#  service_account_id = yandex_iam_service_account.sa.id
#  description        = "static access key for object storage"
#}

# Use keys to create bucket
#resource "yandex_storage_bucket" "ashmigol" {
#  access_key =  yandex_iam_service_account_static_access_key.sa-static-key.access_key
#  secret_key =  yandex_iam_service_account_static_access_key.sa-static-key.secret_key
#  bucket = "ashmigol"
#}


resource "yandex_vpc_network" "foo" {
  name = "foo"
}

resource "yandex_vpc_subnet" "foo" {
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.foo.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}


resource "yandex_vpc_subnet" "foo2" {
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.foo.id
  v4_cidr_blocks = ["192.168.11.0/24"]
}


module "ya_instance_1" {
  source                = "./modules"
  instance_family_image = "lemp"
  vpc_subnet_id         = yandex_vpc_subnet.foo.id
}

module "ya_instance_2" {
  source                = "./modules"
  instance_family_image = "lamp"
  vpc_subnet_id         = yandex_vpc_subnet.foo2.id
}

