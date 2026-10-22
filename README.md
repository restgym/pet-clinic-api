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
| Technology | Java 17, Spring Boot 3.5.7, H2 (in-memory) |
| Original specification | OpenAPI 3.0, YAML, written by Spring PetClinic developers (`src/main/resources/openapi.yml` in the original repository) |
| Operations tested | 35 (34 with the corrected specification) |
| Authentication | None |
| External services | None |

More details (e.g., how 5XX responses are grouped into unique failures) are in the manifest, `restgym-api-manifest.yaml`.

## Contents

| File | Content |
|---|---|
| `spring-petclinic-rest.jar` | The executable of the API, built from commit `e0c3456` (2025-11) of the original repository, unchanged (see "Changes made by RESTgym"). |
| `classes/` | The classes measured for code coverage: the classes of the packages of the API, as in the executable (identical, verified 2026-10). |
| `specifications/original/pet-clinic-openapi.yaml` | The original specification (OpenAPI 3.0.1) of the version packaged (3.4.3), unchanged. |
| `specifications/standardized/pet-clinic-openapi.yaml` | The specification given to the tools (OpenAPI 3.0.1): the original with the server of the API in its container and the base path in the paths. |
| `specifications/standardized/pet-clinic-openapi.json` | The same specification in JSON (converted with yq). |
| `specifications/standardized/pet-clinic-swagger.json` | The same specification in Swagger 2.0 (converted with hidi). |
| `specifications/standardized/pet-clinic-swagger.yaml` | The Swagger 2.0 version in YAML (converted with yq). |
| `specifications/corrected/pet-clinic-openapi.yaml` | The standardized specification without the operation that the API does not implement (`GET /petclinic/api/oops`). |
| `specifications/corrected/pet-clinic-openapi.json` | The same specification in JSON (converted with yq). |
| `specifications/corrected/pet-clinic-swagger.json` | The same specification in Swagger 2.0 (converted with hidi). |
| `specifications/corrected/pet-clinic-swagger.yaml` | The Swagger 2.0 version in YAML (converted with yq). |
| `specifications/README.md` | Every difference between the specifications, in detail. |
| `Dockerfile` | The Docker image of the API, built by RESTgym (`./restgym.sh b`). |
| `entrypoint.sh` | Starts the API (and the services it needs) in the container. |
| `restgym-api-manifest.yaml` | Metadata of the API for RESTgym. |

## How RESTgym runs it

The image starts from the base image of RESTgym for Java 17 (`restgym/api-base:java17`), which contains the proxy and the collection of code coverage. `entrypoint.sh` starts the API on port 8080 with the profiles `h2` and `spring-data-jpa`, the default ones of the original repository. The database is H2, in memory (`jdbc:h2:mem:petclinic`): at each start, Spring creates it with `db/h2/schema.sql` and loads the sample data of `db/h2/data.sql` (`spring.sql.init.mode=always`), both in the jar and identical to those of the original repository. Each run starts with the same data: 10 owners, 13 pets, 4 visits, 6 vets, 3 specialties and 6 pet types (checked through the API, 2026-10). Nothing else runs in the container. The tools reach the API through the proxy of RESTgym, on port 9090.

## Changes made by RESTgym

### API

None: `spring-petclinic-rest.jar` is the build (2025-11, JDK 19) of commit `e0c3456` (2025-11, version 3.4.3) of the original repository, without changes. The `pom.xml` in the jar is that of `e0c3456`, the only commit between 2025-09 and the build with that `pom.xml` (dependency versions, e.g., Spring Boot 3.5.7); its sources (`src/main`) are those of `ff80e67` (2025-09), unchanged until then. Verified 2026-10 by building `e0c3456` (its Maven wrapper, Maven 3.9.9, JDK 19, `mvnw package -DskipTests`): the two jars have the same 383 entries with the same content (all the classes included, also those generated from `openapi.yml`), except the build time in `META-INF/build-info.properties` and Windows line endings in 21 text files (the jar was built from a Windows checkout).

### Specification

The original specification is `original/pet-clinic-openapi.yaml` (OpenAPI 3.0.1): `src/main/resources/openapi.yml` at commit `8409c0a` (2025-08, version 3.4.3) of the original repository, unchanged. It has the same content as the `openapi.yml` in `spring-petclinic-rest.jar` (which has Windows line endings): the jar is built from a later commit (`e0c3456`, see "API"), but `openapi.yml` did not change between the two (its next change is of 2026-03). At runtime, the API also serves a specification generated by springdoc (OpenAPI 3.1, at `/petclinic/v3/api-docs`), which is not the original.

The specification given to the tools is `standardized/pet-clinic-openapi.yaml`: the original with the server `http://localhost:8080` (the port of the API in its container) and the base path `/petclinic/api` in each path (e.g., `/petclinic/api/owners`). The corrected specification, `corrected/pet-clinic-openapi.yaml`, is the standardized one without `GET /petclinic/api/oops`, which the specification documents but the API does not implement (it answers 500 `NoResourceFoundException` to any request). Details in `specifications/README.md`.

## Endpoints that may interfere with authentication

RESTgym handles the authentication of the requests, and the tools are not aware of it: an endpoint that ends or changes the session of RESTgym (e.g., logout, login as another user, change or deletion of the user of the proxy, of its password or of its roles) may make the tools fail for the rest of the run. The proxy blocks the requests that would end its session (`471 Blocked by RESTgym`), instead of removing the endpoints from the specifications given to the tools.

None: RESTgym does not authenticate the requests to this API (it needs no authentication), so no endpoint can end or change a session of RESTgym. `POST /petclinic/api/users` creates users of the security of PetClinic, which is disabled in its default configuration.

## Known behavior of the API (kept as in the original)

- `GET /petclinic/api/oops` is in the specification but has no handler, so it returns 500. Unknown paths and invalid path parameters (e.g., `/owners/abc`) also return 500, since the API maps all exceptions to 500.
- The H2 web console is enabled (`spring.h2.console.enabled=true` in the original configuration) and reachable through the proxy at `/petclinic/h2-console/` (200, checked 2026-10). It is not in the specification, so a tool would have to guess its path; through it, any SQL could be run on the database of the API.

## To verify

- Why the base path was moved into the paths of `pet-clinic-openapi.json`, and not of `pet-clinic-openapi.yaml`.

## External services (verified 2026-10)

None. The API uses only its in-memory H2 database:

- **Code:** no class of the API uses a network client (HTTP, sockets, mail, messaging, tracing); its URLs are links to documentation and licenses, and the `localhost` databases of the profiles `mysql` and `postgres`, which are not active. None of its 91 libraries is a client of outside services, and its configuration has no exporter of metrics or traces.
- **Runtime**, on the image built from the current files of this repository, with a capture of all the traffic of the container except the requests to the proxy and the loopback: the container runs only the proxy and the API (`-Dspring.profiles.active=h2,spring-data-jpa`); no packet during the startup and 150 seconds idle, nor during requests to all the 35 operations of the standardized specification (24 successful).
