# Apigee Kickstart docker image based on Google PHP base image 

This project uses the [giteshk/drupal8-gcp-docker](https://github.com/giteshk/drupal8-gcp-docker) to build 
Apigee Kickstart project
 
If you want to use this image you can download it from docker hub

    docker pull giteshk/apigee-kickstart-gcp

## Running this setup locally
<a id="run-this-setup"></a>

1. Create a volume for the drupal files
    ```
        docker volume create devportal-public-files
        docker volume create devportal-private-files
    ```
2.  Create a mariadb database.
    You can setup the mariadb docker container as shown below:
    ```
        docker pull mariadb
    
        docker run --name=devportal-dbserver \
            -e MYSQL_ROOT_PASSWORD=rootpassword \
            -e MYSQL_DATABASE=devportal \
            -e MYSQL_USER=devportal_user \
            -e MYSQL_PASSWORD=devportal_passw0rd \
            -p3306:3306 mariadb
    ```    
3. Update the MYSQL_DB_HOST with the IP Address the environment.txt file. Now run the image you just built
    ```
    docker pull giteshk/apigee-kickstart-gcp

    docker run -v devportal-public-files:/drupal-files/public \
        -v devportal-private-files:/drupal-files/private \
        --name=devportal-drupal  \
        --env-file=./environment.txt \
        -p3000:80 giteshk/apigee-kickstart-gcp:latest 
    ```
4. Open a browser and go to [http://localhost:3000](http://localhost:3000)

## Remove your docker containers

    docker stop devportal-drupal
    docker container rm devportal-drupal
    docker stop devportal-dbserver
    docker container rm devportal-dbserver
    docker volume rm devportal-public-files
    docker volume rm devportal-private-files

## How to manage customizations to the kickstart project?

1. Copy this project
2. Copy the composer.json file from https://github.com/giteshk/drupal8-gcp-docker/blob/master/composer.json
3. Add you dependencies into the project and build your own image using `docker build` command