# docker-mysql-dump

A simple Docker container to dump the contents of a MySQL database (using mysqldump) and copy it into S3.

## Using It

**Build the image**

```
docker build -t dump .
```

**Run the image**

```
docker run -it --rm --name dump -e "DB_USER=root" -e "DB_PASSWORD=XXXXXXX" -e "DB_HOST=mydb.XXXXX.us-east-1.rds.amazonaws.com" -e "AWS_PROFILE=my-aws-profile" -e "BUCKET=my-project-bucket" -e "DB_NAME=my-db" -v ~/.aws:/root/.aws dump
```

* Environment Variables Required
  * DB_USER - MySQL user that has enough privileges to mysqldump the target MySQL database.
  * DB_PASSWORD - the password for the DB_USER
  * DB_HOST - FQDN or IP address of the MySQL instance
  * DB_NAME - a label to associate with this backup
  * BUCKET - target S3 bucket
* AWS CLI Environment Variables
  * Any of the methods of specifying AWS CLI credentials (as discussed in [AWS documentation](https://blogs.aws.amazon.com/security/post/Tx3D6U6WSFGOK2H/A-New-and-Standardized-Way-to-Manage-Credentials-in-the-AWS-SDKs)). E.g., AWS_PROFILE, AWS_

## Implementation Notes

* Dumps use the "--all-databases" option of mysqldump.
* Dumps are gzipped.
* The S3 bucket is created if it does not exist. "us-east-1" region is assumed.
* Dumps are stored in s3://BUCKET/mysql-dump/DB_NAME/mysql-dump.YYYY-MM-DD-HH-MM.sql.gz.
* Whatever AWS credentials are supplied, they must have permission to put objects into the bucket.

## Future Improvements

* Allow specifying the region to use for the bucket, if it is created.
* Provide a "dry-run" option to testing MySQL permissions and S3 permissions without actually doing the export.

