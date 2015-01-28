#!/bin/bash

RELEASE_BRANCH=release/${RELEASE_VERSION}

git checkout ${START_BRANCH}
git checkout -b ${RELEASE_BRANCH}
mvn versions:set -DnewVersion=${RELEASE_VERSION} versions:commit
git commit -a -m "Versie ${RELEASE_VERSION}"
