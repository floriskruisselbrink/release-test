#!/bin/bash

CURRENT_BRANCH=$(git symbolic-ref --short -q HEAD)
MASTER_BRANCH=master

git commit -a -m "Versie ${RELEASE_VERSION}"
git push origin ${CURRENT_BRANCH}

git checkout ${MASTER_BRANCH}
git merge --no-ff ${CURRENT_BRANCH}
git tag -m "Versie ${RELEASE_VERSION}" v${RELEASE_VERSION}
git push --tags origin ${MASTER_BRANCH}

git checkout ${CURRENT_BRANCH}
mvn versions:set -DnewVersion=${NEXT_VERSION} versions:commit
git commit -a -m "Verder op ${NEXT_VERSION}"
git push origin ${CURRENT_BRANCH}