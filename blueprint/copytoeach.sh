#!/bin/bash

#cat output.tf.egress  >> ../blueprint_networking_shared_egress/output.tf 
#cat blueprint.tf.egress  >> ../blueprint_networking_shared_egress/blueprint.tf
#mv blueprint_networking_shared_egress.sandpit.auto.tfvars ../
#mv F5/F5BIGIP_Egress.tf ../
#mv F5/blueprint_f5bigip_egress ../

cat output.tf.transit >> ../blueprint_networking_shared_transit/output.tf 
cat blueprint.tf.transit >> ../blueprint_networking_shared_transit/blueprint.tf
mv blueprint_networking_shared_transit.sandpit.auto.tfvars ../
mv F5/F5BIGIP_Transit.tf ../
mv F5/blueprint_f5bigip_transit ../

mv F5/F5BIGIP_Member_Transit.tf ../
mv F5/blueprint_f5bigip_members_transit ../

sudo yum install -y expect
sudo yum install -y wget

