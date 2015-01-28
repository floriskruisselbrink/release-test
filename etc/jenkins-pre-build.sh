#!/bin/bash

# IS_M2RELEASEBUILD=true
# MVN_ISDRYRUN={true|false}
# MVN_RELEASE_VERSION=0.4
# MVN_DEV_VERSION=0.5-SNAPSHOT

DIR=$(cd "$(dirname "$0")" && pwd)
source $DIR/jenkins-functions.sh

if [[ ${IS_M2RELEASEBUILD} == true && ${MVN_ISDRYRUN} == false ]] ; then
	init_variables

	start_release
fi