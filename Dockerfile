# Spring PetClinic REST API - RESTgym Container
FROM ubuntu:22.04

# Environment configuration
ENV API=pet-clinic
ENV TOOL=${TOOL:-manual}
ENV RUN=${RUN:-1}
ENV DEBIAN_FRONTEND=noninteractive

# Create RESTgym directories
RUN mkdir -p /api /infrastructure /results

# Install required packages
RUN apt-get update && \
    apt-get -y upgrade && \
    apt-get -y install \
        openjdk-17-jdk \
        curl \
        wget \
        netcat \
        mitmproxy && \
    apt-get -y autoremove && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy API application
COPY ./apis/pet-clinic/spring-petclinic-rest.jar /api/spring-petclinic-rest.jar

# Copy classes for JaCoCo coverage analysis
COPY ./apis/pet-clinic/classes/ /api/classes/

# Copy database initialization files (H2 schema and data)
COPY ./apis/pet-clinic/database/ /api/database/

# Copy infrastructure tools from common RESTgym infrastructure
COPY ./infrastructure/ /infrastructure/

# Startup script: starts the API, the collection of code coverage and the proxy (see infrastructure/api/restgym-api.sh)
COPY ./apis/pet-clinic/entrypoint.sh /entrypoint.sh

ENTRYPOINT ["bash", "/entrypoint.sh"]
