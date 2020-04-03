# Apigee Kickstart docker image based on Google App Engine Flex PHP runtime

_This is an open-source project. It is not covered by Apigee support contracts. 
 For help, please open an issue in this GitHub project. You are also always welcome to submit a pull request._

This is a sample project to show you how to setup 
[Apigee Developer Portal Kickstart](https://www.drupal.org/project/apigee_devportal_kickstart) on Google Kubernetes Engine

The reason we used the [GCP PHP docker base image](https://github.com/GoogleCloudPlatform/php-docker/tree/master/php-onbuild)
 is to take advantage of the updates GCP team provides and also to use integrations with other GCP tools

## Running this setup on GKE

1. This repository is setup as a [Template Repository](https://help.github.com/en/github/creating-cloning-and-archiving-repositories/creating-a-repository-from-a-template) to allow you to easily clone for multiple projects
2. Clone this repository and set it up on [Cloud Source Repositories](https://source.cloud.google.com/) for your GCP project
3. Create a trigger using [Cloud Build](https://console.cloud.google.com/cloud-build/triggers).
   Use the cloudbuild.yaml file provided with this project or make appropriate modifications for your project.
4. You may choose to set this up on [Docker Hub](https://hub.docker.com) make sure to set the Dockerfile location 
   to `container-assets/Dockerfile` and the Build Context to `/`
5. Setup the Database
   - Create a [Cloud SQL instance (MySQL)](https://console.cloud.google.com/sql/create-instance-mysql)
   - Create a database with the name `apigee_devportal`
   - Create a User e.g. `portal_dbuser` and set a password
   - **Make sure that to assign a private IP to this instance and removing public access** 
   - You can choose to run the following gcloud commands instead of configuring from the UI
   ```
    MYSQL_INSTANCE_NAME=apigee-devportal-instance
    COMPUTE_REGION=us-east1
    COMPUTE_ZONE=us-east1-c
    DRUPAL_DB_NAME=apigee_devportal
    DRUPAL_DB_USER=portal_dbuser
    DRUPAL_DB_PASS=portal_dbpassword

    gcloud beta sql instances create $MYSQL_INSTANCE_NAME \
        --tier=db-n1-standard-2 --region=$COMPUTE_REGION  --network=default --no-assign-ip
    
    gcloud sql databases create $DRUPAL_DB_NAME --instance=$MYSQL_INSTANCE_NAME
    
    gcloud sql users create $DRUPAL_DB_USER \
       --host=% --instance=$MYSQL_INSTANCE_NAME --password=$DRUPAL_DB_PASS
    ```
6. Drupal needs a file system to store the uploaded content and the generated assets. To allow GKE to spin multiple 
   replicas of the container we are going to setup a [Filestore Instance](https://console.cloud.google.com/filestore/locations/-/instances/new).
   
   You may choose to use the following gcloud command
   ```
    gcloud filestore instances create apigee-devportal-files-instance \
       --zone=$COMPUTE_ZONE --file-share=capacity=1TB,name=portal_files --network=name=default
    ```
7. [Create a Kubenetes cluster](https://console.cloud.google.com/kubernetes/add) or you may choose to deploy this application to an existing cluster

8. Modify the configuration files in the kubenetes folder
   - pvc.yaml 
     - Replace <IP_ADDRESS> with the IP address of the newly create Filestore instance
     - If you modifled the file-share name replace `/portal_files` with your value (`/` prefix required).
   - deployment.yaml
     - Replace the < IMAGE > with the image url from Container Registry or Docker Hub that you setup. 
     Add the appropriate tag as needed (Cloudbuild defaults to `latest`).

   _You can choose to commit kubernetes config file changes to your repository so you can setup Automated Deployments on GKE_

9. Setup the ConfigMap to configure the environment variables
   ```
    MYSQL_INSTANCE_IP_ADDRESS=$(gcloud sql instances describe $MYSQL_INSTANCE_NAME --format="value(ipAddresses[0].ipAddress)")
   
    kubectl create configmap apigee-devportal-configuration\
        --from-literal=database-host=$MYSQL_INSTANCE_IP_ADDRESS \
        --from-literal=database-port=3306 \
        --from-literal=database-name=$DRUPAL_DB_NAME \
        --from-literal=database-driver=mysql    
    ```
10. Setup the Kubenetes Secret to configure the Database username and password
    ```
    kubectl create secret generic apigee-devportal-credentials \
        --from-literal=dbusername=$DRUPAL_DB_USER \
        --from-literal=dbpassword=$DRUPAL_DB_PASS
    ```

11. Create the deployment using the following command
    ```
    kubectl apply -f kubernetes/
    ```

12. Get the Load Balancer IP from the Services. Use that to start the install process from the browser.


## Running this setup locally
<a id="run-this-setup"></a>
> You will need docker-compose to run this setup locally. Installation instructions [here](https://docs.docker.com/compose/install/)

> Please note Docker on Mac could be slow. 

1. To setup the local project run `./setup-project.sh`
   - This will run "composer install" and setup the `code` directory and the drupal-files directory locally.
   - You may choose to check in your entire `code` directory to the repository. This will ensure that your
   container image is built with the version in source control.
   - code/sites/default/files and drupal-files directory should not be added to source control. 
   Since these are typically files that user uploads. 
   You can choose to copy them over to your local files to Filestore instance after finishing development
    - code/sites/default/files content should be copied over the the filestore_instance/public
    - drupal-files/private content should be copied over to filestore_instance/private
    - drupal-files/config content should be copied over to filestore_instance/config
    
2. To start the project run `docker-compose up`. Once the services are up you can navigate to [http://localhost:5000](http://localhost:5000)

3. You can run through the install from the browser.

4. To stop the project run `docker-compose down`. 

5. To delete the database you can delete the volume that is created or run `docker-compose down -v`. This will let you run through a fresh install. 
   You may need to delete the files in drupal-files/private , drupal-files/private, code/web/sites/default/files directory 

6. To update the dependencies you can run `./update-project.sh` and then commit all the updates in the `code` directory to source control.

7. To ssh into the Drupal container use 
    ```
        docker-compose exec apigee-kickstart /bin/bash
   ```
    - You can run drush commands or composer install commands from the /app/code directory
    - code and the drupal-files directories are mounted to /app/code or /app/drupal-files directories on the container. 
    So any changes you make will be automatically reflected in that directory.

8. To get access to the database you can run 
    ```
    docker-compose exec apigee-kickstart drush sqlc
   ```
   
## Remove your local docker containers, images, volumes

    docker-compose down -v
