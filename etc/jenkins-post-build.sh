#!/bin/bash

# IS_M2RELEASEBUILD=true
# MVN_ISDRYRUN={true|false}
# MVN_RELEASE_VERSION=0.4
# MVN_DEV_VERSION=0.5-SNAPSHOT

set +x
REPO="https://${USERNAME}:${PASSWORD}@github.com/vloris/release-test.git"
set -x

function git_push {
	set +x
	BRANCH=$1

	if [[ ${BRANCH} == tag ]]; then
		TAG=$2

		echo git push **** refs/tags/${TAG}
		git push ${REPO} refs/tags/${TAG}
	else
		echo git push **** refs/heads/${BRANCH}:refs/heads/${BRANCH}
		git push ${REPO} refs/heads/${BRANCH}:refs/heads/${BRANCH}
	fi

	set -x
}

if [[ ${IS_M2RELEASEBUILD} == true && ${MVN_ISDRYRUN} == false ]] ; then
	START_BRANCH=${GIT_BRANCH##origin/}
	RELEASE_BRANCH=release/${MVN_RELEASE_VERSION}
	MASTER_BRANCH=master

	git checkout ${MASTER_BRANCH}
	git merge --no-ff ${RELEASE_BRANCH}
	git tag -m "Versie ${MVN_RELEASE_VERSION}" v${MVN_RELEASE_VERSION}
	git_push ${MASTER_BRANCH}
	git_push tag v${MVN_RELEASE_VERSION}

	git checkout ${START_BRANCH}
	git merge --no-ff ${RELEASE_BRANCH}
	mvn versions:set -DnewVersion=${MVN_DEV_VERSION} versions:commit
	git commit -a -m "Verder op ${MVN_DEV_VERSION}"

	git_push ${START_BRANCH}

	git branch -d ${RELEASE_BRANCH}
fi