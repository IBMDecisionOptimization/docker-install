# docker-install
A repository that illustrates how to install CPLEX into a docker container.

In order to create a container you will need a COS installer for Linux.
These installers are named `cos_installer-*-linux-x86-64.bin`. Put *one*
such installer into this directory, the `Dockerfile` expects it here.

The container is based on `python:3.7`, so that Python connectors can
be used out of the box. The `Dockerfile` temporarily installs `default-jre`
since that is required by the installer.

The `install.properties` file installs COS with the following setup:
- Installation directory is `/opt/cplex` (`USER_INSTALL_DIR`)
- The locale is english (`INSTALLER_LOCALE`)
- No user information will be sent back to IBM (`USER_INPUT_SEGMENT_FALSE`)