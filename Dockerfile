# Dockerfile to install CPLEX into a container.
# Based on Python containers so that CPLEX Python connectors can be used.

# Where to install (this is also specified in install.properties)
ARG COSDIR=/opt/CPLEX

# Default Python version is 3.7
ARG CPX_PYVERSION=3.7

# Remove stuff that is typically not needed in a container, such as IDE,
# documentation, examples. Override with --build-arg CPX_KEEP_XXX=TRUE.
ARG CPX_KEEP_IDE=FALSE
ARG CPX_KEEP_DOC=FALSE
ARG CPX_KEEP_EXAMPLES=FALSE

FROM python:${CPX_PYVERSION}
MAINTAINER daniel.junglas@de.ibm.com

# Copy installer and installer arguments from local disk
COPY cos_installer-*.bin /tmp/installer
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
RUN if [ "${CPX_KEEP_}" != TRUE ]; then rm -rf ${COSDIR}/opl/oplide; fi
RUN if [ "${CPX_KEEP_DOC}" != TRUE ]; then rm -rf ${COSDIR}/doc; fi
RUN if [ "${CPX_KEEP_EXAMPLES}" != TRUE ]; then rm -rf ${COSDIR}/*/examples; fi

# Put all the binaries (cplex/cpo interactive, oplrun) onto the path
ENV PATH ${PATH}:${COSDIR}/cplex/bin/x86-64_linux
ENV PATH ${PATH}:${COSDIR}/cpoptimizer/bin/x86-64_linux
ENV PATH ${PATH}:${COSDIR}/opl/bin/x86-64_linux

# Put the libraries onto the path
ENV LD_LIBRARY_PATH ${LD_LIBRARY_PATH}:${COSDIR}/cplex/bin/x86-64_linux
ENV LD_LIBRARY_PATH ${LD_LIBRARY_PATH}:${COSDIR}/cpoptimizer/bin/x86-64_linux
ENV LD_LIBRARY_PATH ${LD_LIBRARY_PATH}:${COSDIR}/opl/bin/x86-64_linux

# Setup Python
ENV PYTHONPATH ${PYTHONPATH}:${COSDIR}/cplex/python/${CPX_PYVERSION}/x86-64_linux

# Default user is cplex
RUN adduser --disabled-password --gecos "" cplex 
USER cplex
WORKDIR /home/cplex


CMD /bin/bash
