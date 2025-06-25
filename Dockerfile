#
# filebot Dockerfile
#
# https://github.com/jlesage/docker-filebot
#

# Docker image version is provided via build arg.
ARG DOCKER_IMAGE_VERSION=

# Define software versions.
ARG FILEBOT_VERSION=5.1.7

# Define software download URLs.
ARG FILEBOT_URL=https://get.filebot.net/filebot/FileBot_${FILEBOT_VERSION}/FileBot_${FILEBOT_VERSION}-portable.tar.xz

# Get Dockerfile cross-compilation helpers.
FROM --platform=$BUILDPLATFORM tonistiigi/xx AS xx

# Get FileBot
FROM --platform=$BUILDPLATFORM alpine:3.16 AS filebot
ARG FILEBOT_URL
RUN \
    apk --no-cache add curl && \
    # Download sources.
    mkdir /tmp/filebot && \
    curl -# -L -f ${FILEBOT_URL} | tar xJ -C /tmp/filebot && \
    # Install.
    mkdir /opt/filebot && \
    cp -Rv /tmp/filebot/jar /opt/filebot/

# Pull base image.
FROM jlesage/baseimage-gui:alpine-3.16-v4.8.0

ARG FILEBOT_VERSION
ARG DOCKER_IMAGE_VERSION

# Define working directory.
WORKDIR /tmp

# Install dependencies.
RUN \
    add-pkg \
        bash \
        p7zip \
        findutils \
        coreutils \
        curl \
        adwaita-icon-theme \
        openjdk17-jre \
        # Used by Filebot as the open file window.
        zenity \
        && \
    # A recent version of JNA, only available in edge, is needed.
    add-pkg --repository http://dl-cdn.alpinelinux.org/alpine/edge/main \
            --repository http://dl-cdn.alpinelinux.org/alpine/edge/community \
            --upgrade java-jna-native font-wqy-zenhei  && \
    # Remove unneeded icons.
    rm -r /usr/share/icons/Adwaita/cursors && \
    find /usr/share/icons/Adwaita -type f -name "*.svg" -delete && \
    find /usr/share/icons/Adwaita -type f -name "*.png" \
        ! -path "*/mimetypes/*" \
        ! -name bookmark-new-symbolic.symbolic.png \
        ! -name dialog-information.png \
        ! -name dialog-warning.png \
        ! -name document-open-recent-symbolic.symbolic.png \
        ! -name drive-harddisk.png \
        ! -name drive-harddisk-symbolic.symbolic.png \
        ! -name folder-new-symbolic.symbolic.png \
        ! -name image-missing.png \
        ! -name list-add-symbolic.symbolic.png \
        ! -name media-eject-symbolic.symbolic.png \
        ! -name pan-up-symbolic.symbolic.png \
        ! -name pan-down-symbolic.symbolic.png \
        ! -name pan-end-symbolic.symbolic.png \
        ! -name pan-start-symbolic.symbolic.png \
        ! -name user-desktop-symbolic.symbolic.png \
        ! -name user-home.png \
        ! -name user-home-symbolic.symbolic.png \
        ! -name user-trash-symbolic.symbolic.png \
        -delete

# Generate and install favicons.
RUN \
    APP_ICON_URL=https://raw.githubusercontent.com/jlesage/docker-templates/master/jlesage/images/filebot-icon.png && \
    install_app_icon.sh "$APP_ICON_URL"

# Add files.
COPY rootfs/ /
COPY --from=filebot /opt/filebot /opt/filebot

# Set internal environment variables.
RUN \
    set-cont-env APP_NAME "FileBot" && \
    set-cont-env APP_VERSION "$FILEBOT_VERSION" && \
    set-cont-env DOCKER_IMAGE_VERSION "$DOCKER_IMAGE_VERSION" && \
    true

# Set public environment variables.
ENV \
    FILEBOT_GUI=1 \
    AMC_ENABLED=1 \
    USE_FILEBOT_BETA=0 \
    LANG=zh_CN.UTF-8  \
    FILEBOT_CUSTOM_OPTIONS="-no-xattr -no-probe " \
    OPENSUBTITLES_USERNAME= \
    OPENSUBTITLES_PASSWORD= \
    AMC_INTERVAL=1800 \
    AMC_INPUT_STABLE_TIME=10 \
    AMC_ACTION=test \
    AMC_CONFLICT=auto \
    AMC_MATCH_MODE=opportunistic \
    AMC_ARTWORK=n \
    AMC_LANG=English \
    AMC_MUSIC_FORMAT="{plex}" \
    AMC_MOVIE_FORMAT="{plex}" \
    AMC_SERIES_FORMAT="{plex}" \
    AMC_ANIME_FORMAT="{plex}" \
    AMC_PROCESS_MUSIC=y \
    AMC_SUBTITLE_LANG= \
    AMC_CUSTOM_OPTIONS= \
    AMC_INPUT_DIR=/watch \
    AMC_OUTPUT_DIR=/output

# Define mountable directories.
VOLUME ["/storage"]
VOLUME ["/output"]
VOLUME ["/watch"]

# Metadata.
LABEL \
      org.label-schema.name="filebot" \
      org.label-schema.description="Docker container for FileBot" \
      org.label-schema.version="${DOCKER_IMAGE_VERSION:-unknown}" \
      org.label-schema.vcs-url="https://github.com/jlesage/docker-filebot" \
      org.label-schema.schema-version="1.0"
