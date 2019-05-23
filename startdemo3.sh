#!/bin/bash
# changes unganged links in project name
variable_new_proj=$(grep "project" variables.tf -A1 | grep default | awk '{print $3}')
variable_cloud_serv=$(grep "service_key" variables.tf -A1 |grep .json | awk '{print $3}')
variable_private_key=$(grep "priv_key_path" variables.tf -A2 |grep .pem | awk '{print $3}')

#v1=$(echo $variable_new_proj | sed -s "s/^\(\(\"\(.*\)\"\)\|\('\(.*\)'\)\)\$/\\3\\5/g")
#v2=$(echo $variable_cloud_serv | sed -s "s/^\(\(\"\(.*\)\"\)\|\('\(.*\)'\)\)\$/\\3\\5/g")
#v3=$(echo $variable_private_key | sed -s "s/^\(\(\"\(.*\)\"\)\|\('\(.*\)'\)\)\$/\\3\\5/g")

#sed -i -e "s+\042google_project_name\042+${variable_new_proj}+g" ./ansible/kubernetes/deployment-frontend.yml

##sed -i -e "s+google_project_name+${v1}+g" ./ansible/kubernetes/deployment-frontend.yml
##sed -i -e "s+google_project_name+${v1}+g" ./ansible/kubernetes/deployment-backend.yml

sed -i -e "s+google_project_name+${variable_new_proj}+g" ./ansible/kubernetes/deployment-frontend.yml
sed -i -e "s+google_project_name+${variable_new_proj}+g" ./templates/job_backend.tpl
sed -i -e "s+google_project_name+${variable_new_proj}+g" ./templates/job_frontend.tpl

sed -i -e "s+service_account.json+${variable_cloud_serv}+g" ./templates/job_backend.tpl
sed -i -e "s+service_account.json+${variable_cloud_serv}+g" ./templates/job_frontend.tpl

sed -i -e "s+ansible/.ssh/private_key.pem+${v3}+g" ./templates/jenkins.plugins.publish_over_ssh.BapSshPublisherPlugin.tpl


terraform plan
terraform apply
