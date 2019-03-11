# OCR task list notification
- Task list notification was developed to send daily digest of active tasks to the OnCore staff
- A batch job is scheduled to run the notification app every weekday at 6:55 AM
- Task list is maintained by the OCR OnCore Development Team

## Prerequisites
- Ruby Version 2.0 or higher
- OnCore 15.0 or higher

## Installation
- Clone this repo into your machine.
- Rename dummy-config.php to config.php file
- Update your config settings in config.php file
- Run `bundle install` to install dependencies
- Run `ruby mail.rb` to test your application
- After a successful test schedule batch job as per your requirements
