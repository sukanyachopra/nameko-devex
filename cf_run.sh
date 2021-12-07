#!/bin/bash

# setting up cf environment
echo "Retrieving Production Environment Variables in CF.."

export AMQP_URI=$(echo ${VCAP_SERVICES} | jq -r '."p.rabbitmq"[0].credentials.uri')

# need to reconstruct URI for postgres to use postgresql:// instead of postgres:// from credentials.uri
DB_HOST=$(echo ${VCAP_SERVICES} | jq -r '."aws-rds-postgres"[0].credentials.hostname')
DB_USR=$(echo ${VCAP_SERVICES} | jq -r '."aws-rds-postgres"[0].credentials.username')
DB_PWD=$(echo ${VCAP_SERVICES} | jq -r '."aws-rds-postgres"[0].credentials.password')
DB_PORT=$(echo ${VCAP_SERVICES} | jq -r '."aws-rds-postgres"[0].credentials.port')
DB_NAME=$(echo ${VCAP_SERVICES} | jq -r '."aws-rds-postgres"[0].credentials.database')
export POSTGRES_URI=postgresql://${DB_USR}:${DB_PWD}@${DB_HOST}:${DB_PORT}/${DB_NAME}
# export POSTGRES_URI=$(echo ${VCAP_SERVICES} | jq -r '."aws-rds-postgres"[0].credentials.uri')

REDIS_HOST=$(echo ${VCAP_SERVICES} | jq -r '."p.redis"[0].credentials.host')
REDIS_PWD=$(echo ${VCAP_SERVICES} | jq -r '."p.redis"[0].credentials.password')
REDIS_PORT=$(echo ${VCAP_SERVICES} | jq -r '."p.redis"[0].credentials.port')
export REDIS_URI=redis://:${REDIS_PWD}@${REDIS_HOST}:${REDIS_PORT}/dev
# export REDIS_URI=$(echo ${VCAP_SERVICES} | jq -r '.redis[0].credentials.uri')

# # create dbname for postgres

# python -c """
# import psycopg2 as db
# from urllib.parse import urlparse
# result = urlparse('${POSTGRES_URI}')
# username = result.username
# password = result.password
# database = result.path[1:]
# hostname = result.hostname
# port = result.port
# con=db.connect(dbname='postgres',host=hostname,user=username,password=password)
# con.autocommit=True;con.cursor().execute('CREATE DATABASE devex')
# """

./run.sh $@ 