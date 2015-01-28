#!/bin/bash

# IS_M2RELEASEBUILD=true
# MVN_ISDRYRUN={true|false}
# MVN_RELEASE_VERSION=0.4
# MVN_DEV_VERSION=0.5-SNAPSHOT

if [[ ${IS_M2RELEASEBUILD} == true && ${MVN_ISDRYRUN} == false ]] ; then
	REPO=$(git config --get remote.origin.url)

	REPO_PATH=${REPO##https://}
	HOSTNAME=${REPO_PATH%%/*}

	CREDENTIALS="https://${USERNAME}:${PASSWORD}@${HOSTNAME}"
	PUSH_REPO="https://${USERNAME}@${REPO_PATH}"

	CREDENTIAL_FILE=${WORKSPACE}/target/.git-credentials

cat <<EOF > ${CREDENTIAL_FILE}
${CREDENTIALS}
EOF

	git config credential.helper "store --store=${CREDENTIAL_FILE}"

	START_BRANCH=${GIT_BRANCH##origin/}
	RELEASE_BRANCH=release/${MVN_RELEASE_VERSION}
	MASTER_BRANCH=master

	git checkout ${MASTER_BRANCH}
	git merge --no-ff ${RELEASE_BRANCH}
	git tag -m "Versie ${MVN_RELEASE_VERSION}" v${MVN_RELEASE_VERSION}

	git checkout ${START_BRANCH}
	git merge --no-ff ${RELEASE_BRANCH}
	mvn versions:set -DnewVersion=${MVN_DEV_VERSION} versions:commit
	git commit -a -m "Verder op ${MVN_DEV_VERSION}"

	git push ${PUSH_REPO} refs/heads/${MASTER_BRANCH}:refs/heads/${MASTER_BRANCH}
	git push ${PUSH_REPO} refs/tags/v${MVN_RELEASE_VERSION}
	git push ${PUSH_REPO} refs/heads/${START_BRANCH}:refs/heads/${START_BRANCH}

	git branch -d ${RELEASE_BRANCH}

	rm ${CREDENTIAL_FILE}
	git config --unset credential.helper
fi