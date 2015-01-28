#!/bin/bash

# IS_M2RELEASEBUILD=true
# MVN_ISDRYRUN={true|false}
# MVN_RELEASE_VERSION=0.4
# MVN_DEV_VERSION=0.5-SNAPSHOT

DIR=$(cd "$(dirname "$0")" && pwd)
source $DIR/jenkins-functions.sh

if is_releasebuild ; then
	init_variables
	init_credential_helper

	finish_release
	push_changes
fi