# OCR task list notification

This document provides an overview of the task list notifications application and its technical infrastructure, as developed and provided by Office of Clinical Research at University of Florida.

## Architecture

The email notifications application is written in Ruby and is scheduled to run daily at 6:00 AM. The application connects to OnCore database and reads the task list data. The queries used to retrieve the data are stored as environmental variables.

## Deployment

Docker public image id available for the task list notifications app. This image serves as an environment to execute the task list notifications in the server you wish.

### Prerequisites
- Docker Engine >= 1.10.0
- Docker Compose is recommended with a version 1.6.0 or later.
- Access to the OnCore database servers

### How to use this image
`Note: The URL's point to the developer's image the global image will be updated soon`

Create a bash script task-list-notification.sh

Include the below lines in your script

    #!/bin/bash
    docker run  -p 5200:5000 --env-file {your_env_file_locations} -v {your_log_file_dir}:$log_dir hkoranne/ocr-task-notification:latest

Schedule a cronjob for the bash script as per the institutions requirement.

### variables
- your_env_file_location: the location of the environment file. This file includes all the required environmental variables
- your_log_file_dir: the location to the folder where you desire to volume the log files

### Environment variables
The following variables and required:

    Database connection variables:
        username: This variable provides the OnCore database user name
        password: This variable provides the OnCore database password
        hostname: This variable provides the OnCore database hostname
        sid: This variable provides the OnCore serviceid
    
    Email specific variables:
        from: This variable provides the from email address
        subject: This variable provides the subject of the email
        address: This variable provides the smtp server information
    Other variables:
        userquery: This variable provides the query to retrive all the active users in OnCore
        tasklistquery: This variable provides the query to retreive all the active task list items for the OnCore user 
        log_dir: This variable provides the location of the applications log directory

### Image variants
`hkoranne/ocr-task-notification:latest`

This image is based on the latest stable version

`hkoranne/ocr-task-notification:<version>`

This image is based on the given stable version

`hkoranne/ocr-task-notification:develop`

This image is based on the current state and is used to test out the developments before publishing

## Implementation and Maintenance

The application depends on the queries provided in the environment file. During OnCore upgrades time and resources need to be allocated to ensure the queries continue to work as expected.