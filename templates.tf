
data "template_file" "jenkins_conf" {
  template = "${file("${path.module}/modules/jobs/jenkins.plugins.publish_over_ssh.BapSshPublisherPlugin.tpl")}"
  vars {
 #   web_server = "${element(google_compute_instance.jenkins.*.network_interface.0.network_ip, count.index)}"
    jenkins = "${google_compute_instance.jenkins.network_interface.0.network_ip}"
    job_priv_key = "/workdir/ansible/${var.priv_key}"
  }
}
data "template_file" "app_conf" {
  template = "${file("${path.module}/modules/jobs/application.properties.tpl")}"
  depends_on = ["google_sql_database_instance.instance"]
  vars {
    database_server = "${google_sql_database_instance.instance.ip_address.0.ip_address}"
    database_name = "${var.database_name}"
    database_user = "${var.user_name}"
    database_pass = "${var.user_password}"
  }
}
data "template_file" "job_frontend" {
  template = "${file("${path.module}/modules/jobs/job_frontend.tpl")}"
  vars {
    lb_backend = "${google_compute_address.address.address}"
    project = "${var.project}"
    activate_key = "/workdir/ansible/${var.service_key}"
  }
}

data "template_file" "job_backend" {
  template = "${file("${path.module}/modules/jobs/job_backend.tpl")}"
  vars {
    project = "${var.project}"
    activate_key = "/workdir/ansible/${var.service_key}"
    region = "${var.region}"
    user_password = "${var.user_password}"    
  }
}
## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ## ##
data "template_file" "deployment_backend" {
  template = "${file("${path.module}/modules/infrastructure/deployment_backend.yml")}"
  depends_on = ["google_sql_database_instance.instance"]
  vars {
    project = "${var.project}"
    region  = "${var.region}"
    sql_instance = "${google_sql_database_instance.instance.name}"
  }
}
data "template_file" "deployment_frontend" {
  template = "${file("${path.module}/modules/infrastructure/deployment_frontend.yml")}"
  vars {
    project = "${var.project}"
  }
}
data "template_file" "service_backend" {
  template = "${file("${path.module}/modules/infrastructure/service_backend.yml")}"
  vars {
    lb_backend = "${google_compute_address.address.address}"
  }
}
data "template_file" "service_frontend" {
  template = "${file("${path.module}/modules/infrastructure/service_frontend.yml")}"
  vars {
    lb_backend = "${google_compute_address.address.address}"
  }
}