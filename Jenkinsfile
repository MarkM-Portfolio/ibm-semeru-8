// Quickstart v3 <https://github.ibm.com/connections/quickstart>

@Library('quickstart') _

qs {
    plugin = 'default'
    deployOwner = 'connections'
    deployBranch = 'master'
    dockerRegistry = 'connections-docker.artifactory.cwp.pnp-hcl.com'
    dockerImageTags = ["1.8.0_332"]
    dockerScript = 'scripts/docker_build.sh'
    dockerImageName="base/docker-base-images/ibm-semeru-8"
    validate = false
    deploy = false
    pack = false
    upload = false
    publish = true
    publishScript = 'scripts/docker_publish.sh'
    JAVA_VERSION = '1.8.0_332'
}
