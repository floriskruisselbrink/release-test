function stop_trace {
	OLD_TRACE=${-//[^x]/}
	set +x
}

function restart_trace {
	if [[ -n "$OLD_TRACE" ]]; then
		set -x
	fi
}

function init_variables {
	local REPO=$(git config --get remote.origin.url)

	PUSH_REPO="https://${USERNAME}@${REPO##https://}"
	START_BRANCH=${GIT_BRANCH##origin/}
	RELEASE_BRANCH=release/${MVN_RELEASE_VERSION}
	MASTER_BRANCH=master

	CREDENTIAL_FILE=${WORKSPACE}/target/.git-credentials
}

function start_release {
	git clean -f

	git checkout ${START_BRANCH}
	git checkout -b ${RELEASE_BRANCH}
	
	mvn versions:set -DnewVersion=${MVN_RELEASE_VERSION} versions:commit
	git commit -a -m "Versie ${MVN_RELEASE_VERSION}"
}

function finish_release {
	git clean -f

	git checkout ${MASTER_BRANCH}
	git merge --no-ff ${RELEASE_BRANCH}
	git tag -m "Versie ${MVN_RELEASE_VERSION}" v${MVN_RELEASE_VERSION}

	git checkout ${START_BRANCH}
	git merge --no-ff ${RELEASE_BRANCH}

	mvn versions:set -DnewVersion=${MVN_DEV_VERSION} versions:commit
	git commit -a -m "Verder op ${MVN_DEV_VERSION}"

	git branch -d ${RELEASE_BRANCH}
}

function push_changes {
	git push ${PUSH_REPO} refs/heads/${MASTER_BRANCH}:refs/heads/${MASTER_BRANCH}
	git push ${PUSH_REPO} refs/tags/v${MVN_RELEASE_VERSION}
	git push ${PUSH_REPO} refs/heads/${START_BRANCH}:refs/heads/${START_BRANCH}
}

function init_credential_helper {
	local REPOSITORY=$(git config --get remote.origin.url)
	local REPO_PATH=${REPO##https://}
	local REPO_HOST=${REPO_PATH%%/*}

	stop_trace
	CREDENTIALS="https://${USERNAME}:${PASSWORD}@${REPO_HOST}"

cat <<EOF > ${CREDENTIAL_FILE}
${CREDENTIALS}
EOF
	restart_trace

	git config credential.helper "store --file ${CREDENTIAL_FILE}"
}

function cleanup_credential_helper {
	rm ${CREDENTIAL_FILE}
	git config --unset credential.helper
}
