# Spring PetClinic REST
# Base image: Ubuntu 22.04, Java 17 (headless JRE), mitmproxy and the RESTgym infrastructure (see infrastructure/api/Dockerfile)
FROM restgym/api-base:java17

# The API: its executable, the classes for code coverage, its specifications and scripts
COPY ./apis/pet-clinic/ /api/

# Startup script (in /api): starts the API, the collection of code coverage and the proxy (see infrastructure/api/restgym-api.sh)
ENTRYPOINT ["bash", "/api/entrypoint.sh"]
