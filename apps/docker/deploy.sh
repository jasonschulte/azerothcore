#!/bin/bash
set -euo pipefail
cd "$(dirname "$0")"
source .env

function usage () {
    cat <<EOF
Wrapper for shell scripts to deploy azerothcore

usage: $(basename $0) ACTION [ ACTION... ] [ ACTION_ARG... ]

actions:
EOF
# the `-s` will remove the "#" and properly space the action and description
    cat <<EOF | column -t -s'#'
> sync:data             # Sync wow data to docker volume
> sync:config           # Sync acore config to docker volume
> sync:source           # Sync acore source (sql only) to docker volume
> sync:all              # Sync all acore data to docker volumes
> backup:db             # Backup the database and copy relevant tables to merge DB
> backup:config         # Backup acore config files
> backup:all            # Backup config and DB
> merge:db              # Merge relevant tables from merge DB
> build:ssh             # Build ssh container
> build:auth            # Build acore-auth container
> build:world           # Build acore-world container
> build:acore           # Build world and auth containers
> build:all             # Build all containers
> start:ssh             # Start ssh container
> start:auth            # Start acore-auth container
> start:world           # Start acore-world container
> start:all             # Start all containers
> connect:ssh           # Connect to SSH container
> update                # Build and deploy auth and world containers
> clean                 # Wipe DB, remove containers, and deploy update

EOF
}

function check_symlink () {
  if [ "$(readlink -f /azerothcore)" != "$(readlink -f ../../env/dist)" ]; then
    echo "In order for this script to work you must have the following symlink:"
    echo -e "\t /azerothcore -> $(readlink -f ../../env/dist)"
    echo "To create this symlink run the following command with appropriate permissions (i.e. root)"
    echo -e "\t> ln -s $(readlink -f ../../env/dist) /azerothcore"
    return 1
  else
    return 0
  fi
}

function backup () {
  DATETIME=$(date +"%F-%T")
  if [ "${1}" = "config" ] || [ "${1}" = "all" ]; then
    ssh $SSH_USER@$SSH_HOST "tar -cvzf /azerothcore/backups/config-${DATETIME}.tgz -C /azerothcore/etc/ ."
  fi
  if [ "${1}" = "database" ] || [ "${1}" = "all" ]; then
    ssh $SSH_USER@$SSH_HOST "mysqldump ${ACORE_AUTH_DATABASE} | gzip > /azerothcore/backups/${ACORE_AUTH_DATABASE}-${DATETIME}.sql.gz"
    ssh $SSH_USER@$SSH_HOST "mysqldump ${ACORE_WORLD_DATABASE} | gzip > /azerothcore/backups/${ACORE_WORLD_DATABASE}-${DATETIME}.sql.gz"
    ssh $SSH_USER@$SSH_HOST "mysqldump ${ACORE_CHARACTER_DATABASE} | gzip > /azerothcore/backups/${ACORE_CHARACTER_DATABASE}-${DATETIME}.sql.gz"
  fi
}

function start() {
  DOCKER_RUN_COMMON="-d \
    --name acore-${1} \
    -h acore-${1} \
    --network static --domainname 'local.in' --restart unless-stopped \
    -v acore_backups:/azerothcore/backups \
    -v acore_data:/azerothcore/data \
    -v acore_source:/azerothcore/source \
    -v acore_config:/azerothcore/etc \
    -v acore_logs:/azerothcore/logs"
  if [ "$(docker ps -f "name=acore-${1}" --format '{{.Names}}')" = "acore-${1}" ]; then
    echo "${1} is already running"
  elif [ -z "$(docker images -q jasonschulte/acore-${1}:latest 2> /dev/null)" ]; then
    echo "${1} container image does not exist.  Build container first."
  elif [ "${1}" = "ssh" ]; then
    docker start ssh 2> /dev/null || \
    docker run ${DOCKER_RUN_COMMON} \
      -v acore_ssh_config:/config \
      --ip "${SSH_HOST}" \
      -e PUBLIC_KEY="$(cat ~/.ssh/id_rsa.pub)" \
      jasonschulte/acore-ssh:latest
    sleep 3
  elif [ "${1}" = "auth" ]; then
    docker run ${DOCKER_RUN_COMMON} \
      --ip "${ACORE_AUTH_HOST}" \
      jasonschulte/acore-auth:latest
  elif [ "${1}" = "world" ]; then
    docker run ${DOCKER_RUN_COMMON} \
      --ip "${ACORE_WORLD_HOST}" \
      jasonschulte/acore-world:latest
  fi
}

function stop()
{
  CONTAINER_LIST=" "
  if [ "${1}" = "world" ] || [ "${1}" = "all" ] || [ "${1}" = "acore" ]; then
    CONTAINER_LIST="${CONTAINER_LIST} acore-world"
  fi
  if [ "${1}" = "auth" ] || [ "${1}" = "all" ] || [ "${1}" = "acore" ]; then
    CONTAINER_LIST="${CONTAINER_LIST} acore-auth"
  fi  
  if [ "${1}" = "ssh" ] || [ "${1}" = "all" ]; then
    CONTAINER_LIST="${CONTAINER_LIST} acore-ssh"
  fi
  docker stop ${CONTAINER_LIST} || true
}

function remove()
{
  CONTAINER_LIST=" "
  if [ "${1}" = "world" ] || [ "${1}" = "all" ] || [ "${1}" = "acore" ]; then
    CONTAINER_LIST="${CONTAINER_LIST} acore-world"
  fi
  if [ "${1}" = "auth" ] || [ "${1}" = "all" ] || [ "${1}" = "acore" ]; then
    CONTAINER_LIST="${CONTAINER_LIST} acore-auth"
  fi  
  if [ "${1}" = "ssh" ]; then
    CONTAINER_LIST="${CONTAINER_LIST} acore-ssh"
  fi
  docker rm ${CONTAINER_LIST} || true
}

MERGE_DB="acore_world_merge"
MYSQL="mysql -h $MYSQL_HOST -u $MYSQL_USER -P $MYSQL_PORT -p${MYSQL_PASSWORD}"
function wipe_world_db()
{  
  SQL="TRUNCATE TABLE \`${MERGE_DB}\`.\`creature\`; \
       TRUNCATE TABLE \`${MERGE_DB}\`.\`gameobject\`; \
       INSERT INTO \`${MERGE_DB}\`.\`creature\` SELECT * FROM \`${ACORE_WORLD_DATABASE}\`.\`creature\`; \
       INSERT INTO \`${MERGE_DB}\`.\`gameobject\` SELECT * FROM \`${ACORE_WORLD_DATABASE}\`.\`gameobject\`;"
  echo "Copying creatures and gameobjects to ${MERGE_DB}"
  $MYSQL -e "$SQL"
  TABLES=$($MYSQL -Nse "SHOW TABLES" $ACORE_WORLD_DATABASE)
  for TABLE in $TABLES; do
    echo "Dropping $TABLE from $ACORE_WORLD_DATABASE"
    # $MYSQL $ACORE_WORLD_DATABASE -e "DROP TABLE \`$TABLE\`"&
  done
  wait
}

function merge_world_db()
{
  SQL="INSERT INTO \`${ACORE_WORLD_DATABASE}\`.\`creature\` SELECT \
       NULL, \`src\`.\`id1\`, \`src\`.\`id2\`, \`src\`.\`id3\`, \`src\`.\`map\`, \`src\`.\`zoneId\`, \
       \`src\`.\`areaId\`, \`src\`.\`spawnMask\`, \`src\`.\`phaseMask\`, \`src\`.\`equipment_id\`, 
       \`src\`.\`position_x\`, \`src\`.\`position_y\`, \`src\`.\`position_z\`, \`src\`.\`orientation\`, \
       \`src\`.\`spawntimesecs\`, \`src\`.\`wander_distance\`, \`src\`.\`currentwaypoint\`, \
       \`src\`.\`curhealth\`, \`src\`.\`curmana\`, \`src\`.\`MovementType\`, \`src\`.\`npcflag\`, \
       \`src\`.\`unit_flags\`, \`src\`.\`dynamicflags\`, \`src\`.\`ScriptName\`, 
       \`src\`.\`VerifiedBuild\`, \`src\`.\`CreateObject\`, \`src\`.\`Comment\` \
       FROM \`${MERGE_DB}\`.\`creature\` as src LEFT JOIN \`${ACORE_WORLD_DATABASE}\`.\`creature\` as tgt \
       ON (\`src\`.\`id1\` = \`tgt\`.\`id1\` and \`src\`.\`phaseMask\` = \`tgt\`.\`phaseMask\`) \
       WHERE tgt.guid is null and (src.phaseMask > 10 or src.id1 >= 70000);"
  echo "Merging creatures from ${MERGE_DB} to ${ACORE_WORLD_DATABASE}"
  echo $SQL
  $MYSQL -e "$SQL"
  SQL="INSERT INTO \`${ACORE_WORLD_DATABASE}\`.\`gameobject\` SELECT \
       NULL, \`src\`.\`id\`, \`src\`.\`map\`, \`src\`.\`zoneId\`, \`src\`.\`areaId\`, \`src\`.\`spawnMask\`, \
       \`src\`.\`phaseMask\`, \`src\`.\`position_x\`, \`src\`.\`position_y\`, \`src\`.\`position_z\`, \
       \`src\`.\`orientation\`, \`src\`.\`rotation0\`, \`src\`.\`rotation1\`, \`src\`.\`rotation2\`, \
       \`src\`.\`rotation3\`, \`src\`.\`spawntimesecs\`, \`src\`.\`animprogress\`, \`src\`.\`state\`, \
       \`src\`.\`ScriptName\`, \`src\`.\`VerifiedBuild\`, \`src\`.\`Comment\` \
       FROM \`${MERGE_DB}\`.\`gameobject\` as src LEFT JOIN \`${ACORE_WORLD_DATABASE}\`.\`gameobject\` as tgt \
       ON (\`src\`.\`id\` = \`tgt\`.\`id\` and \`src\`.\`phaseMask\` = \`tgt\`.\`phaseMask\`) \
       WHERE tgt.guid is null and (src.phaseMask > 10);"
  echo "Merging gameobjects from ${MERGE_DB} to ${ACORE_WORLD_DATABASE}"
  echo $SQL
  $MYSQL -e "$SQL"
  wait
}

# If no args, just spit usage and exit
check_symlink && [[ $# -eq 0 ]] && usage && exit

# loop through commands passed
CURRENT_ARG=""
while [[ $# -gt 0 ]]; do
  CURRENT_ARG=$1
  case "$1" in
    update)
      $0 "build:acore"&
      backup "all" &
      $0 "sync:all" &      
      stop "acore"&
      remove "acore"&
      wait      
      start "auth"
      start "world"
      shift
      ;;

    clean)
      wipe_world_db
      $0 update
      stop "acore"
      merge_world_db
      start "auth"
      start "world"
      shift
      ;;

    build:all)
      $0 build:ssh build:auth build:world
      shift
      ;;

    build:acore)
      $0 build:auth build:world
      shift
      ;;

    build:ssh)
      docker build . --target acore-ssh -t jasonschulte/acore-ssh:latest
      shift
      ;;

    build:auth)
      rsync -avz /azerothcore/bin/ ./bin/
      docker build . --target acore-auth -t jasonschulte/acore-auth:latest \
              --build-arg "MYSQL_USER=${MYSQL_USER}" \
              --build-arg "MYSQL_PASSWORD=${MYSQL_PASSWORD}" \
              --build-arg "MYSQL_HOST=${MYSQL_HOST}" \
              --build-arg "MYSQL_PORT=${MYSQL_PORT}" \
              --build-arg "ACORE_AUTH_DATABASE=${ACORE_AUTH_DATABASE}" \
              --build-arg "ACORE_WORLD_DATABASE=${ACORE_WORLD_DATABASE}" \
              --build-arg "ACORE_CHARACTER_DATABASE=${ACORE_CHARACTER_DATABASE}"
      shift
      ;;

    build:world)
      rsync -avz /azerothcore/bin/ ./bin/
      docker build . --target acore-world -t jasonschulte/acore-world:latest \
              --build-arg "MYSQL_USER=${MYSQL_USER}" \
              --build-arg "MYSQL_PASSWORD=${MYSQL_PASSWORD}" \
              --build-arg "MYSQL_HOST=${MYSQL_HOST}" \
              --build-arg "MYSQL_PORT=${MYSQL_PORT}" \
              --build-arg "ACORE_AUTH_DATABASE=${ACORE_AUTH_DATABASE}" \
              --build-arg "ACORE_WORLD_DATABASE=${ACORE_WORLD_DATABASE}" \
              --build-arg "ACORE_CHARACTER_DATABASE=${ACORE_CHARACTER_DATABASE}"
      shift
      ;;

    start:all)
      start "ssh"
      start "auth"
      start "world"
      shift
      ;;

    start:ssh)
      start "ssh"
      shift
      ;;

    start:auth)
      start "auth"
      shift
      ;;

    start:world)
      start "world"
      shift
      ;;

    sync:all)
      $0 sync:data sync:source sync:config
      shift
      ;;

    sync:data)
      start "ssh"
      set -x
      rsync -avz /azerothcore/data/ $SSH_USER@$SSH_HOST:/azerothcore/data/
      set +x
      shift
      ;;
    
    sync:config)
      start "ssh"
      set -x
      ssh $SSH_USER@$SSH_HOST "cd /azerothcore/etc/ && git pull"
      set +x
      shift
      ;;

    sync:source)
      start "ssh"
      set -x
      rsync -avz ../../data $SSH_USER@$SSH_HOST:/azerothcore/source/
      rsync -avz --exclude=".git" ../../modules $SSH_USER@$SSH_HOST:/azerothcore/source/
      set +x
      shift
      ;;

    backup:config)
      start "ssh"
      backup "config"
      shift
      ;;

    backup:db)
      start "ssh"
      backup "database"
      shift
      ;;
    
    connect:ssh)
      start "ssh"
      exec ssh $SSH_USER@$SSH_HOST
      shift
      ;;

    backup:all)
      start "ssh"
      set -x
      backup "all"
      set +x
      shift
      ;;

    *)
      echo "Unknown or empty arg"
      usage
      exit 1
  esac
done
