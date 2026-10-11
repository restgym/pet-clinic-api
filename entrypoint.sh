#!/usr/bin/env bash
# Starts Pet Clinic in RESTgym: see /infrastructure/api/restgym-api.sh

source /infrastructure/api/restgym-api.sh

restgym_run_api 8080 \
    java -javaagent:/infrastructure/jacoco/org.jacoco.agent-0.8.7-runtime.jar=includes=org.springframework.samples.petclinic.*,output=tcpserver,port=12345,address=* \
        -Dfile.encoding=UTF-8 \
        -Dserver.port=8080 \
        -Dspring.profiles.active=h2,spring-data-jpa \
        -jar /api/spring-petclinic-rest.jar
