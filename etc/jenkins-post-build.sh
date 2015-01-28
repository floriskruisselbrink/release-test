#!/bin/bash

DIR=$(cd "$(dirname "$0")" && pwd)
source $DIR/jenkins-functions.sh

if is_releasebuild ; then
	init_variables
	init_credential_helper

	finish_release
	push_changes
fi