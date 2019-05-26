resource "google_container_cluster" "primary" {
  name       = "${var.cluster_name}"
  location   = "${var.region}"
  network    = "${google_compute_network.my_vpc_network.name}"
  subnetwork = "${google_compute_subnetwork.private_subnetwork.name}"

  initial_node_count = 1
}