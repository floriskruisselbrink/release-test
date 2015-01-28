#!/bin/bash

REPO="https://${USERNAME}:${PASSWORD}@github.com/vloris/release-test.git"
RELEASE_BRANCH=release/${RELEASE_VERSION}
MASTER_BRANCH=master

git checkout ${MASTER_BRANCH}
git merge --no-ff ${RELEASE_BRANCH}
git tag -m "Versie ${RELEASE_VERSION}" v${RELEASE_VERSION}
git push ${REPO} refs/heads/${MASTER_BRANCH}:refs/heads/${MASTER_BRANCH}
git push ${REPO} refs/tags/v${RELEASE_VERSION}

git checkout ${START_BRANCH}
git merge --no-ff ${RELEASE_BRANCH}
mvn versions:set -DnewVersion=${NEXT_VERSION} versions:commit
git commit -a -m "Verder op ${NEXT_VERSION}"

git push ${REPO} refs/heads/${START_BRANCH}:refs/heads/${START_BRANCH}

git branch -d ${RELEASE_BRANCH}