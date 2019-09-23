# OCR task list notification
- Task list notification was developed to send daily digest of active tasks to the OnCore staff
- A batch job is scheduled to run the notification app every weekday at 6:55 AM
- Task list is maintained by the OCR OnCore Development Team

## Prerequisites
- OnCore 15.0 or higher

# docker-ruby-oracle-Oncore-task-list
This docker images serves as an environment to execute a OCR-TASKLIST-NOTIFICATION.

All the configurable variables are set up in environmental file

Your environment file must contain the following variables:

```
from=

subject=

address=

username=

password=

hostname=

sid=

userquery=

log_dir=

```

Deploy the docker image
1. docker pull hkoranne/ocr-task-notification:1.0
2. docker run -p 5200:5000 --env-file {your_env_file_location} -v {desired location for logs}:/opt/data/task-list-notification/logs hkoranne/ocr-task-notification:1.0

