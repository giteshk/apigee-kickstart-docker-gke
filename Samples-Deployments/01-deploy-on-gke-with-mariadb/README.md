# Deploy on GKE with MariaDB container

This will setup one MariaDB pod and one or more Apigee Kickstart Distribution on another pod running nginx and php 7.2.


## Installation steps

1. Create a cluster on GKE
2. Connect to that cluster on GKE
3. Run the following commands
```
   # Add the DB connection information to the kubernetes secrets
   kubectl create secret generic cloudsql-db-credentials\
        --from-literal=root-password=some-strong-root-password \
        --from-literal=username=drupal_db_user \
        --from-literal=password=drupal_db_password \
        --from-literal=dbname=drupal_db
```
