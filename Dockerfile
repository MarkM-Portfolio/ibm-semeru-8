###################################################################
#	HCL Confidential
#
#	OCO Source Materials
#
#	Copyright HCL Technologies Limited 2022
#
#	The source code for this program is not published or otherwise
#	divested of its trade secrets, irrespective of what has been
#	deposited with the U.S. Copyright Office.
###################################################################

FROM connections-docker.artifactory.cwp.pnp-hcl.com/base/alpine

MAINTAINER squad:energon (pipeline)
# https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.35-r0/glibc-2.35-r0.apk
RUN apk --update add --no-cache ca-certificates curl openssl binutils zstd\
    && GLIBC_VER="2.35-r0" \
    && ALPINE_GLIBC_REPO="https://github.com/sgerrand/alpine-pkg-glibc/releases/download" \
    && curl -Ls ${ALPINE_GLIBC_REPO}/${GLIBC_VER}/glibc-${GLIBC_VER}.apk > /tmp/${GLIBC_VER}.apk 
    # && apk add --allow-untrusted /tmp/${GLIBC_VER}.apk \
    # && curl -Ls https://www.archlinux.org/packages/core/x86_64/gcc-libs/download > /tmp/gcc-libs.tar.zst \
    # && mkdir /tmp/gcc \
    # && zstd -dc /tmp/gcc-libs.tar.zst | tar -x -C /tmp/gcc \
    # && mv /tmp/gcc/usr/lib/libgcc* /tmp/gcc/usr/lib/libstdc++* /usr/glibc-compat/lib \
    # && strip /usr/glibc-compat/lib/libgcc_s.so.* /usr/glibc-compat/lib/libstdc++.so* \
    # && apk del binutils \
    # && rm -rf /tmp/${GLIBC_VER}.apk /tmp/gcc /tmp/gcc-libs.tar.xz /var/cache/apk/*

ARG JAVA_VERSION

ENV JAVA_HOME=/opt/ibm/java/jre

#This is the recommended way to download, however, we are using artifactory to prevent supply chain attacks.
#If there was a way to mdsum this in the future I'd consider using it.
#COPY --from=ibm-semeru-runtimes:11 $JAVA_HOME $JAVA_HOME

#Extract semeru from artifactory
RUN set -eux; \
    curl -LfsSo /tmp/openjdk.tar.gz 'https://artifactory.cwp.pnp-hcl.com/artifactory/openlyAvailable-utils/JRE80_Semeru/ibm-semeru-open-jre_x64_linux_8u332b09_openj9-0.32.0.tar.gz'; \
    mkdir -p /opt/ibm/java/jre; \
    cd /opt/ibm/java/jre; \
    tar -xf /tmp/openjdk.tar.gz --strip-components=1; \
    rm -rf /var/cache/apk/*; \
    rm -rf /tmp/openjdk.tar.gz;

ENV PATH="${JAVA_HOME}/bin:${PATH}"
