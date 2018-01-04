#!/bin/bash
#
# Test DB for general health.
#

pushd ../../etl/db
  . common.sh
popd

# Shorthand func to call InfluxDB REST Query API
function query() {
  DB=$1
  QUERY="$2"
  echo "db=$DB - query: ${QUERY}"
  # See https://docs.influxdata.com/influxdb/v1.4/guides/querying_data/
  curl -G 'http://localhost:8086/query?pretty=true' \
  -u ${influx_admin_user}:${influx_admin_password} \
     --data-urlencode "db=${DB}" --data-urlencode \
     "q=${QUERY}"
}

query _internal "SHOW GRANTS FOR ${influx_se_writer}"
query _internal "SHOW GRANTS FOR ${influx_se_reader}"

query _internal "SHOW GRANTS FOR ${influx_as_writer}"
query _internal "SHOW GRANTS FOR ${influx_as_reader}"

query _internal "SHOW DATABASES"
query _internal "SHOW USERS"

query airsenseur "SELECT * from Geonovum1 limit 2"
query smartemission "SELECT * from rivm limit 2"