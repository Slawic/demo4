provider "google" {
  credentials = "${file("${service_key}")}"
  project     = "${var.project}"
  region      = "${var.region}"
  zone        = "${var.zone}"
}
