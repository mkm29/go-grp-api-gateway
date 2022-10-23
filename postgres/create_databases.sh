#!/bin/bash

set -e

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" <<-EOSQL
	CREATE DATABASE auth_svc;
  CREATE DATABASE product_svc;
  CREATE DATABASE order_svc;
  ALTER USER postgres WITH PASSWORD 'postgres';
EOSQL