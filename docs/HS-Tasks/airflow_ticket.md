airflow web server
has a ui and uses hive metastore and minio

go to bitwarden

is there the command to port forwaring and the credentials to acess om localhost 8080


a lock is created on hivemeta to the postgres db


export the postgress pasww
and then run psq;with that psswoord

we have to run in the postgress namespace
once there we show the logs, we should not have logs as the must be temporarz
we delete the logs
we go back to airflow uI and run the dag again 'trigger tag with config'

it will ope the logical date and we have to change it to 2am wit 5 min and then trigger button


we go in airflow documentaion


trino should use minio and posgress
