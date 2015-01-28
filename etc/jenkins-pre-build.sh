#!/bin/bash

# IS_M2RELEASEBUILD=true
# MVN_ISDRYRUN={true|false}
# MVN_RELEASE_VERSION=0.4
# MVN_DEV_VERSION=0.5-SNAPSHOT

if [[ ${IS_M2RELEASEBUILD} == true && ${MVN_ISDRYRUN} == false ]] ; then
	START_BRANCH=${GIT_BRANCH##origin/}
	RELEASE_BRANCH=release/${MVN_RELEASE_VERSION}

	git checkout ${START_BRANCH}
	git checkout -b ${RELEASE_BRANCH}
	mvn versions:set -DnewVersion=${MVN_RELEASE_VERSION} versions:commit
	git commit -a -m "Versie ${MVN_RELEASE_VERSION}"
fi