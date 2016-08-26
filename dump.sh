#!/bin/bash

echo DB_HOST: $DB_HOST
echo DB_USER: $DB_USER
echo BUCKET: $BUCKET
echo DB_NAME: $DB_NAME

NOW=`date +%Y-%m-%d-%H-%M`
FILENAME=mysql-dump.$NOW.sql
ERRORFILE=mysql-dump.$NOW.error.log

# --add-drop-trigger is not a known option to this mysqldump when run against a
#   5.7.11 MySQL RDS instance.
#
# --opt is enabled be default which is shorthand for the following:
#   --add-drop-table --add-locks --create-options
#   --disable-keys --extended-insert --lock-tables --quick --set-charset
mysqldump --all-databases --add-drop-database \
  --compact --routines \
  --host=$DB_HOST --user=$DB_USER --password=$DB_PASSWORD  \
  --log-error=/tmp/$ERRORFILE \
  > /tmp/$FILENAME

# creates $FILENAME.gz
gzip /tmp/$FILENAME
gzip /tmp/$ERRORFILE

# ensure the bucket is present
aws s3 mb s3://$BUCKET --region us-east-1

aws s3 cp /tmp/$FILENAME.gz s3://$BUCKET/mysql-dump/$DB_NAME/$FILENAME.gz
aws s3 cp /tmp/$ERRORFILE.gz s3://$BUCKET/mysql-dump/$DB_NAME/$ERRORFILE.gz

aws s3 ls s3://$BUCKET/mysql-dump/$DB_NAME/$FILENAME.gz
aws s3 ls s3://$BUCKET/mysql-dump/$DB_NAME/$ERRORFILE.gz

/bin/rm -f /tmp/$FILENAME.gz
/bin/rm -f /tmp/$ERRORFILE.gz



