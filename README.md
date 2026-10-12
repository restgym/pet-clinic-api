# Spring PetClinic REST for RESTgym

This repository is the RESTgym integration of Spring PetClinic REST. It is meant to be used as a Git submodule of [RESTgym](https://github.com/restgym/restgym) (in `apis/pet-clinic/`), which builds its Docker image and runs it with the testing tools: it does not work on its own.

## The API

| | |
|---|---|
| Name | Spring PetClinic REST |
| Version | 3.4.3 |
| Description | REST version of the Spring PetClinic sample application (veterinary clinic). |
| Domain | Healthcare |
| License | Apache-2.0 |
| Original repository | https://github.com/spring-petclinic/spring-petclinic-rest |
| Technology | Java 17, Spring Boot 3.5.7, H2 |
| Original specification | OpenAPI 3.0, YAML, written by Spring PetClinic developers |
| Operations tested | 35 |
| Authentication | None |
| External services | None |

More details (e.g., how 5XX responses are grouped into unique failures) are in the manifest, `restgym-api-manifest.yaml`.

## Contents

| File | Content |
|---|---|
| `spring-petclinic-rest.jar` | The executable of the API. |
| `classes/` | The classes measured for code coverage: the classes of the packages of the API, as in the executable. |
| `specifications/pet-clinic-openapi.json` | The specification given to the tools (OpenAPI 3.0.1). |
| `specifications/pet-clinic.yaml` | The specification given to the tools (OpenAPI 3.0.1). |
| `Dockerfile` | The Docker image of the API, built by RESTgym (`./restgym.sh b`). |
| `entrypoint.sh` | Starts the API (and the services it needs) in the container. |
| `restgym-api-manifest.yaml` | Metadata of the API for RESTgym. |

## How RESTgym runs it

The image starts from the base image of RESTgym for Java 17 (`restgym/api-base:java17`), which contains the proxy and the collection of code coverage. `entrypoint.sh` starts the API on port 8080 with the profiles `h2` and `spring-data-jpa` (embedded H2 database, with the data in the jar). Nothing else runs in the container. The tools reach the API through the proxy of RESTgym, on port 9090.

## Changes made by RESTgym

### API

None.

### Specification

**Base path moved into the paths.** The base path `/petclinic/api` is in each path (e.g., `/petclinic/api/owners`) instead of the server URL (`http://localhost:8080`), since 2025-12-29. `pet-clinic.yaml` is the YAML version. The original specification (`src/main/resources/openapi.yml` in the original repository) is not kept.

## Known behavior of the API (kept as in the original)

- `GET /petclinic/api/oops` is in the specification but has no handler, so it returns 500. Unknown paths and invalid path parameters (e.g., `/owners/abc`) also return 500, since the API maps all exceptions to 500.

## To verify

- Where `spring-petclinic-rest.jar` was built from (version 3.4.3), and whether its source was changed.
- Why the base path was moved into the paths, and whether the specification differs from the original in other points.
