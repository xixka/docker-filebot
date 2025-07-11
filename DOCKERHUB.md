# Docker container for FileBot
[![Release](https://img.shields.io/github/release/jlesage/docker-filebot.svg?logo=github&style=for-the-badge)](https://github.com/jlesage/docker-filebot/releases/latest)
[![Docker Image Size](https://img.shields.io/docker/image-size/jlesage/filebot/latest?logo=docker&style=for-the-badge)](https://hub.docker.com/r/jlesage/filebot/tags)
[![Docker Pulls](https://img.shields.io/docker/pulls/jlesage/filebot?label=Pulls&logo=docker&style=for-the-badge)](https://hub.docker.com/r/jlesage/filebot)
[![Docker Stars](https://img.shields.io/docker/stars/jlesage/filebot?label=Stars&logo=docker&style=for-the-badge)](https://hub.docker.com/r/jlesage/filebot)
[![Build Status](https://img.shields.io/github/actions/workflow/status/jlesage/docker-filebot/build-image.yml?logo=github&branch=master&style=for-the-badge)](https://github.com/jlesage/docker-filebot/actions/workflows/build-image.yml)
[![Source](https://img.shields.io/badge/Source-GitHub-blue?logo=github&style=for-the-badge)](https://github.com/jlesage/docker-filebot)
[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg?style=for-the-badge)](https://paypal.me/JocelynLeSage)

This is a Docker container for [FileBot](https://www.filebot.net).

The graphical user interface (GUI) of the application can be accessed through a
modern web browser, requiring no installation or configuration on the client

---

[![FileBot logo](https://images.weserv.nl/?url=raw.githubusercontent.com/jlesage/docker-templates/master/jlesage/images/filebot-icon.png&w=110)](https://www.filebot.net)[![FileBot](https://images.placeholders.dev/?width=224&height=110&fontFamily=monospace&fontWeight=400&fontSize=52&text=FileBot&bgColor=rgba(0,0,0,0.0)&textColor=rgba(121,121,121,1))](https://www.filebot.net)

FileBot is the ultimate tool for organizing and renaming your movies, tv shows
or anime, and music well as downloading subtitles and artwork. It's smart and
just works.

---

## Quick Start

**NOTE**:
    The Docker command provided in this quick start is an example, and parameters
    should be adjusted to suit your needs.

Launch the FileBot docker container with the following command:
```shell
docker run -d \
    --name=filebot \
    -p 5800:5800 \
    -v /docker/appdata/filebot:/config:rw \
    -v /home/user:/storage:rw \
    jlesage/filebot
```

Where:

  - `/docker/appdata/filebot`: Stores the application's configuration, state, logs, and any files requiring persistency.
  - `/home/user`: Contains files from the host that need to be accessible to the application.

Access the FileBot GUI by browsing to `http://your-host-ip:5800`.
Files from the host appear under the `/storage` folder in the container.

## Documentation

Full documentation is available at https://github.com/jlesage/docker-filebot.

## Support or Contact

Having troubles with the container or have questions? Please
[create a new issue](https://github.com/jlesage/docker-filebot/issues).

For other Dockerized applications, visit https://jlesage.github.io/docker-apps.
