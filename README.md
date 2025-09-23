# IBM Semeru 8 JVM base microservice image

Authored by https://git.cwp.pnp-hcl.com/cameron-bosnic

# History
Based off of our Alpine linux repo:
https://git.cwp.pnp-hcl.com/connections/alpine
published at connections-docker.artifactory.cwp.pnp-hcl.com/base/alpine

As a replacement for IBM Java 8 microservice
https://git.cwp.pnp-hcl.com/connections/java-eight
connections-docker.artifactory.cwp.pnp-hcl.com/base/docker-base-images/ibm-java8-alpine

Image uses Semeru provided by IBM at https://hub.docker.com/_/ibm-semeru-runtimes

Alpine is being used as official centos7 docker image is 598.35 Mb per
https://github.com/docker-library/repo-info/blob/master/repos/ibm-semeru-runtimes/local/open-11-jdk-centos7.md
vs Alpines approx 178 Mb

jvm-microservice inherits this base image and adds additional files like the launcher, certs
https://git.cwp.pnp-hcl.com/connections/jvm-microservice

# How to use this Image
To run a pre-built japp.jar file with the latest OpenJDK 11, use the following Dockerfile:
```
FROM ibm-semeru-runtimes:11
RUN mkdir /opt/app
COPY japp.jar /opt/app
CMD ["java", "-jar", "/opt/app/japp.jar"]
```

You can build and run the Docker Image as shown in the following example:
```
docker build -t japp .
docker run -it --rm japp
```

Using a different base Image
If you are using a distribution that we don't provide an image for you can copy the JDK using a similar Dockerfile to the one below:

```
FROM <base image>
ENV JAVA_HOME=/opt/ibm/java/jre
COPY --from=ibm-semeru-runtimes:11 $JAVA_HOME $JAVA_HOME
ENV PATH="${JAVA_HOME}/bin:${PATH}"
```
