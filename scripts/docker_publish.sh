docker_push() {
	
	docker push $dockerRegistry/$dockerImageName:$JAVA_VERSION

        #Check Push is successful
        if [ $? -eq 0 ]; then
                echo "Push Successful!"
        else
                echo "Push Failed!"
                exit 1
        fi

	docker push $dockerRegistry/$dockerImageName

	#Check Push is successful
	if [ $? -eq 0 ]; then
		echo "Push Successful!"
	else
		echo "Push Failed!"
		exit 1
	fi

	# cleanup images
	docker rmi $dockerRegistry/$dockerImageName:$JAVA_VERSION
	docker rmi $dockerRegistry/$dockerImageName

}

buildAuditSuccessOrError() {
    returnCode=${1}
    nameOfImage=${2}
    if [ ${returnCode} -eq 0 ] ; then
        echo "The properties were successfully appeneded to the ${nameOfImage} Docker image in Artifactory."
    else
        echo "ERROR: The properties were NOT successfully appeneded to the ${nameOfImage} Docker image in Artifactory."
        exit 1
    fi
}

docker_push

# Adding the build audit trail
artInstance='https://artifactory.cwp.pnp-hcl.com/artifactory'
artRepo="$( echo ${dockerRegistry} | cut -d'.' -f1 )"
artURL=${artInstance}/api/storage/${artRepo}/${dockerImageName}/${JAVA_VERSION}
artLatestURL=${artInstance}/api/storage/${artRepo}/${dockerImageName}/latest
auditProperties="?properties=buildAgent=${buildAgent}%7CBUILD_URL=${BUILD_URL}%7CGIT_ACTUAL_COMMIT=${GIT_ACTUAL_COMMIT}%7CNODE_NAME=${NODE_NAME}%7CARTIFACTORY_USER=${ARTIFACTORY_USER}%7CHOSTNAME=${HOSTNAME}"
echo "Adding build audit trail to ${packageName}"
curl -k -s -u ${ARTIFACTORY_USER}\:${ARTIFACTORY_PASS} -X PUT ${artURL}${auditProperties}
buildAuditSuccessOrError $? $JAVA_VERSION
curl -k -s -u ${ARTIFACTORY_USER}\:${ARTIFACTORY_PASS} -X PUT ${artLatestURL}${auditProperties}
buildAuditSuccessOrError $? latest