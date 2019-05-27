resource "null_resource" remoteExecProvisionerWFolder {
   depends_on = ["google_sql_database_instance.instance"]
   count = 1
  connection {
    host = "${google_compute_instance.jenkins.*.network_interface.0.access_config.0.nat_ip}"
    type = "ssh"
    user = "centos"
    private_key = "${file("${var.priv_key}")}"
    agent = "false"
  }
  provisioner "file" {
     source = "${var.priv_key}"
     destination = "/home/centos/.ssh/id_rsa"
  }

  provisioner "remote-exec" {
    inline = [ "sudo chmod 600 /home/centos/.ssh/id_rsa" ]
  }
  provisioner "remote-exec" {
    inline = [ 
      "sudo rm -rf /workdir && sudo mkdir -p /workdir/ansible/.ssh /workdir/sonarqube /workdir/jenkins /home/centos/k8s /home/centos/eschool",
      "sudo chmod 777 -R /workdir /home/centos/k8s /home/centos/eschool"
      ]
  }
  provisioner "file" {
    source = "dockerimport"
    destination = "/home/centos/"
  }
  // provisioner "file" {
  //   source      = "dockerimport/Dockerfile"
  //   destination = "/home/centos/Dockerfile"
  // }

  // provisioner "file" {
  //   source      = "dockerimport/Dockerfile_frontend"
  //   destination = "/home/centos/Dockerfile_frontend"
  // }

  provisioner "file" {
     source = "${var.priv_key}"
     destination = "/workdir/ansible/${var.priv_key}"
  }
  provisioner "file" {
     source = "${var.service_key}"
     destination = "/workdir/ansible/${var.service_key}"
  }
  provisioner "file" {
    source = "ansible"
    destination = "/workdir/"
  }
  provisioner "file" {
    source = "sonarqube"
    destination = "/workdir/"
  }

  provisioner "file" {
   content = "${data.template_file.jenkins_conf.rendered}"
   destination = "/workdir/jenkins/jenkins.plugins.publish_over_ssh.BapSshPublisherPlugin.xml"
  }
  provisioner "file" {
   content = "${data.template_file.app_conf.rendered}"
   destination = "/workdir/jenkins/application.properties"
 }
  provisioner "file" {
   content = "${data.template_file.job_frontend.rendered}"
   destination = "/workdir/jenkins/job_frontend.xml"
 }
  provisioner "file" {
   content = "${data.template_file.job_backend.rendered}"
   destination = "/workdir/jenkins/job_backend.xml"
 }
 # provision a "k8s" group of four files >>
  provisioner "file" {
   content = "${data.template_file.deployment_frontend.rendered}"
   destination = "/home/centos/k8s/deployment_frontend.yml"
 }
  provisioner "file" {
   content = "${data.template_file.deployment_backend.rendered}"
   destination = "/home/centos/k8s/deployment_backend.yml"
 }
  provisioner "file" {
   content = "${data.template_file.service_frontend.rendered}"
   destination = "/home/centos/k8s/service_frontend.yml"
 }
  provisioner "file" {
   content = "${data.template_file.service_backend.rendered}"
   destination = "/home/centos/k8s/service_backend.yml"
 }
 # <<

}

resource "null_resource" inventoryFileWeb {
   depends_on = ["null_resource.remoteExecProvisionerWFolder"]
  count = 1
  connection {
    host = "${google_compute_instance.jenkins.*.network_interface.0.access_config.0.nat_ip}"
    type = "ssh"
    user = "centos"
    private_key = "${file("${var.priv_key}")}"
    agent = "false"
  }
  provisioner "remote-exec" {
   inline = ["echo ${var.instance_name}\tansible_ssh_host=${element(google_compute_instance.jenkins.*.network_interface.0.network_ip, count.index)}\tansible_user=centos\tansible_ssh_private_key_file=/home/centos/.ssh/id_rsa>>/workdir/ansible/hosts.txt"]
  }
}

resource "null_resource" "ansibleProvision" {
  depends_on = ["null_resource.remoteExecProvisionerWFolder", "null_resource.inventoryFileWeb"]
  count = 1
  connection {
    host = "${google_compute_instance.jenkins.*.network_interface.0.access_config.0.nat_ip}"
    type = "ssh"
    user = "centos"
    private_key = "${file("${var.priv_key}")}"
    agent = "false"
  }
  provisioner "remote-exec" {
    inline = ["sudo sed -i -e 's+#host_key_checking+host_key_checking+g' /etc/ansible/ansible.cfg"]
  }

  provisioner "remote-exec" {
    inline = ["ansible-playbook -i /workdir/ansible/hosts.txt /workdir/ansible/main.yml"]
  }
}