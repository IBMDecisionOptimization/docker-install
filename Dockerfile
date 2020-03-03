FROM python:3.7
MAINTAINER daniel.junglas@de.ibm.com

# Copy installer and installer arguments from local disk
COPY cos_installer-*-linux-x86-64.bin /tmp/installer
COPY install.properties /tmp/install.properties
RUN chmod u+x /tmp/installer

# Install Java runtime. This is required by the installer
RUN apt-get update
RUN apt-get install -y default-jre

# Install COS
RUN /tmp/installer -f /tmp/install.properties

# Remove installer, temporary files, and the JRE we installed
RUN rm -f /tmp/installer /tmp/install.properties
RUN apt-get remove -y --purge default-jre
RUN apt-get -y --purge autoremove

# Setup Python
ENV PYTHONPATH /opt/CPLEX/cplex/python/3.7/x86-64_linux

