#!/bin/bash

get_id () {
    echo `$@ | awk '/ id / { print $4 }'`
}

export OS_SERVICE_TOKEN="ADMIN_TOKEN"
export OS_SERVICE_ENDPOINT="http://192.168.59.103:35357/v2.0"


SERVICE_ID=$(get_id keystone service-create --name=barbican --type="key-manager" --description="Key_Management_Service")
keystone endpoint-create \
    --region RegionOne \
    --service-id=$SERVICE_ID \
    --publicurl=http://localhost:9311 \
    --adminurl=http://localhost:9312 \
    --internalurl=http://localhost:9313 

#
# create admin and service admin user
#
ADMIN_ROLE=$(get_id keystone role-get admin)
tenant_id=$(get_id keystone tenant-create --name="service")
user_id=$(get_id keystone user-create --name="barbican" --pass="barbican" --email=admin@domain.com)
keystone user-role-add --user $user_id --role $ADMIN_ROLE --tenant $tenant_id

service_admin_role=$(get_id keystone role-create --name="key-manager:service-admin")
user_id=$(get_id keystone user-create --name="service-admin" --pass="secretservice" --email=serviceadmin@domain.com)
keystone user-role-add --user $user_id --role $service_admin_role --tenant $tenant_id


################################
# create stuff we need for RBAC
################################
 
#
# create tenants
#
tenant_a_id=$(get_id keystone tenant-create --name="project_a")
tenant_b_id=$(get_id keystone tenant-create --name="project_b")

#
# create the roles we need
#
admin_role=$(get_id keystone role-get admin)
creator_role=$(get_id keystone role-create --name="creator")
observer_role=$(get_id keystone role-create --name="observer")
audit_role=$(get_id keystone role-create --name="audit")

#
# create admin_a user
#
user_id=$(get_id keystone user-create --name="project_a_admin" --pass="barbican" --email=project_a_admin@domain.com)
keystone user-role-add --user $user_id --role $admin_role --tenant $tenant_a_id

#
# create creator_a user
#
user_id=$(get_id keystone user-create --name="project_a_creator" --pass="barbican" --email=project_a_creator@domain.com)
keystone user-role-add --user $user_id --role $creator_role --tenant $tenant_a_id

#
# create observer_a user
#
user_id=$(get_id keystone user-create --name="project_a_observer" --pass="barbican" --email=project_a_observer@domain.com)
keystone user-role-add --user $user_id --role $observer_role --tenant $tenant_a_id

#
# create auditor_a user
#
user_id=$(get_id keystone user-create --name="project_a_auditor" --pass="barbican" --email=project_a_auditor@domain.com)
keystone user-role-add --user $user_id --role $audit_role --tenant $tenant_a_id

#
# create admin_b user
#
user_id=$(get_id keystone user-create --name="project_b_admin" --pass="barbican" --email=project_b_admin@domain.com)
keystone user-role-add --user $user_id --role $admin_role --tenant $tenant_b_id

#
# create creator_b user
#
user_id=$(get_id keystone user-create --name="project_b_creator" --pass="barbican" --email=project_b_creator@domain.com)
keystone user-role-add --user $user_id --role $creator_role --tenant $tenant_b_id

#
# create observer_b user
#
user_id=$(get_id keystone user-create --name="project_b_observer" --pass="barbican" --email=project_b_observer@domain.com)
keystone user-role-add --user $user_id --role $observer_role --tenant $tenant_b_id

#
# create auditor_b user
#
user_id=$(get_id keystone user-create --name="project_b_auditor" --pass="barbican" --email=project_b_auditor@domain.com)
keystone user-role-add --user $user_id --role $audit_role --tenant $tenant_b_id
