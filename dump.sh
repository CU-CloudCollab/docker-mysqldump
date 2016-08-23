#!/bin/bash

echo DB_HOST: $DB_HOST
echo DB_USER: $DB_USER
echo BUCKET: $BUCKET
echo DB_NAME: $DB_NAME

NOW=`date +%Y-%m-%d-%H-%M`
FILENAME=mysql-dump.$NOW.sql

# --add-drop-trigger is not a known option to this mysqldump verion
mysqldump --all-databases --add-drop-database --add-drop-table \
  --create-options --compact --routines \
  --host=$DB_HOST --user=$DB_USER --password=$DB_PASSWORD  \
  > /tmp/$FILENAME

# creates $FILENAME.gz
gzip /tmp/$FILENAME

# ensure the bucket is present
aws s3 mb s3://$BUCKET --region us-east-1

aws s3 cp /tmp/$FILENAME.gz s3://$BUCKET/mysql-dump/$DB_NAME/$FILENAME.gz

aws s3 ls s3://$BUCKET/mysql-dump/$DB_NAME/$FILENAME.gz



