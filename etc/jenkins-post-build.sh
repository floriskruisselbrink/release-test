#!/bin/bash

# IS_M2RELEASEBUILD=true
# MVN_ISDRYRUN={true|false}
# MVN_RELEASE_VERSION=0.4
# MVN_DEV_VERSION=0.5-SNAPSHOT

if [[ ${IS_M2RELEASEBUILD} == true && ${MVN_ISDRYRUN} == false ]] ; then
	REPO="https://${USERNAME}:${PASSWORD}@github.com/vloris/release-test.git"
	START_BRANCH=${GIT_BRANCH##origin/}
	RELEASE_BRANCH=release/${MVN_RELEASE_VERSION}
	MASTER_BRANCH=master

	git checkout ${MASTER_BRANCH}
	git merge --no-ff ${RELEASE_BRANCH}
	git tag -m "Versie ${MVN_RELEASE_VERSION}" v${MVN_RELEASE_VERSION}
	git push ${REPO} refs/heads/${MASTER_BRANCH}:refs/heads/${MASTER_BRANCH}
	git push ${REPO} refs/tags/v${MVN_RELEASE_VERSION}

	git checkout ${START_BRANCH}
	git merge --no-ff ${RELEASE_BRANCH}
	mvn versions:set -DnewVersion=${MVN_DEV_VERSION} versions:commit
	git commit -a -m "Verder op ${MVN_DEV_VERSION}"

	git push ${REPO} refs/heads/${START_BRANCH}:refs/heads/${START_BRANCH}

	git branch -d ${RELEASE_BRANCH}
fi