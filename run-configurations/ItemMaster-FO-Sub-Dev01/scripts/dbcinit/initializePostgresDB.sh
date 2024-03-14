#!/bin/sh
# shellcheck disable=SC3043

# This script creates all webmethods DB components
SAG_HOME=${SAG_HOME:-/opt/softwareag}

createDbAssets(){

    local logPfx="initializePostgresDb.sh::createDbAssets()"

    if ! nc -z "${DBSERVER_HOSTNAME}" "${DBSERVER_PORT}"; then
        echo "$logPfx - Cannot reach socket ${DBSERVER_HOSTNAME}:${DBSERVER_PORT}, database initialization failed!"
        return 1
    fi

    local lDBC_DB_URL="jdbc:wm:postgresql://${DBSERVER_HOSTNAME}:${DBSERVER_PORT};databaseName=${DBSERVER_DATABASE_NAME}"
    local lDbcSh="${SAG_HOME}/common/db/bin/dbConfigurator.sh"

    local lCmdCatalog="${lDbcSh} --action catalog"
    local lCmdCatalog="${lCmdCatalog} --dbms pgsql"
    local lCmdCatalog="${lCmdCatalog} --user '${DBSERVER_USER_NAME}'"
    local lCmdCatalog="${lCmdCatalog} --password '${DBSERVER_PASSWORD}'"
    local lCmdCatalog="${lCmdCatalog} --url '${lDBC_DB_URL}'"

    echo "$logPfx - Checking if product database exists"
    eval "${lCmdCatalog}"

    local resCmdCatalog=$?
    if [ ! "${resCmdCatalog}" -eq 0 ];then
        echo "$logPfx - ERROR - Database not reachable! Result: ${resCmdCatalog}"
        echo "$logPfx - Command was ${lCmdCatalog}"
        return 2
    fi
    # for now this test counts as connectivity.
    # As per product's properties, we consider the "create" action as idempotent

    echo "$logPfx - Initializing database ${DBSERVER_DATABASE_NAME} on server ${DBSERVER_HOSTNAME}:${DBSERVER_PORT} ..."

    local lDbInitCmd="${lDbcSh} --action create"
    local lDbInitCmd="${lDbInitCmd} --dbms pgsql"
    local lDbInitCmd="${lDbInitCmd} --component ${DBC_COMPONENT_NAME}"
    local lDbInitCmd="${lDbInitCmd} --version ${DBC_COMPONENT_VERSION}"
    local lDbInitCmd="${lDbInitCmd} --url '${lDBC_DB_URL}'"
    local lDbInitCmd="${lDbInitCmd} --user '${DBSERVER_USER_NAME}'"
    local lDbInitCmd="${lDbInitCmd} --password '${DBSERVER_PASSWORD}'"
    local lDbInitCmd="${lDbInitCmd} --printActions"

    eval "${lDbInitCmd}"

    local resInitDb=$?
    if [ "${resInitDb}" -ne 0 ];then
        echo "$logPfx - ERROR - Database initialization failed! Result: ${resInitDb}"
        echo "$logPfx - Executed command was: ${lDbInitCmd}"
        return 3
    fi
}

sleep 10

createDbAssets
