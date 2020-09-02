# not executable, to be sourced by setup.sh
# general installation defs
export HOST_RUNDIR=~/run/nhs
export CONT_RUNDIR=/run
export HOST_BINDIR=~/bin
export SETUP_MODE=podman

# database related definitions
export DBUSER=nhdb
export DBNAME=nhdb
export DBHOST=localhost
export FEEDER_DBUSER=nhdbfeeder
export STATS_DBUSER=nhdbstats
export PGDATA=/var/lib/postgresql/data/pgdata

# web definitions
export HOST_WEBDIR=~/www/nhs
export CONT_WEBDIR=${CONT_RUNDIR}/www
if [[ "$SETUP_MODE" == "host" ]]; then
    export WEBDIR=$HOST_WEBDIR
else
    export WEBDIR=$CONT_WEBDIR
fi
export HOST_WEBPORT=8080
export CONT_WEBPORT=80

# general defs related to containers,
# some will be listed here as just a comment
# containers will all be named nhdb or nhdb-something,
# the postgres container will be named nhdb,
# nginx web container nhdb-web,
# nhdb-feeder.pl container nhdb-feeder and nhdb-stats.pl
# will run in a container named nhdb-stats
# nhdb will also be the root of some other names e.g.
# volume nhdb-vol will contain persistent db information
# nhdb-pod will be the pod holding all the containers
if [[ "$SETUP_MODE" == "podman" ]]; then
    # these secrets will be mapped to /run/secrets/nhdb
    # inside containers, as a directory with root db pass,
    # and other passwords inside
    export secrets="$HOME/.secrets/containers/nhdb"
    export LABEL="main" # tag images with branch name label
    export AUTH_JSON_PATH="/run/secrets/nhdb/auth.json"
    export FEEDER_DEFAULT_CMD="./nhdb-feeder.pl --server=hdf,hfa,hfe"
    export auth_json_host="${secrets}/auth.json"
    
    # env vars for postgres container
    export pguser="POSTGRES_USER=$DBUSER"
    export pgdb="POSTGRES_DB=$DBNAME"
    #export pgauth_env="POSTGRES_HOST_AUTH_METHOD=password"
    export pgpass="POSTGRES_PASSWORD_FILE=/run/secrets/nhdb/root"
    
    # env vars for perl/cpan containers
    export perl_lib="PERL5LIB=/cpan-mods/lib/perl5"
fi