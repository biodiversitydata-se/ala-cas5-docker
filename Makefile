#! make

TS := $(shell date '+%Y_%m_%d_%H_%M')
PWD := $(shell pwd)
UID := $(shell id -u)
GID := $(shell id -g)

URL_CAS5 = https://github.com/bioatlas/ala-cas-5/releases/download/SBDI-5.13.12-2/cas-exec.war
URL_CAS_MANAGEMENT = https://nexus.ala.org.au/service/local/repositories/releases/content/au/org/ala/cas-management/5.3.6-1/cas-management-5.3.6-1-exec.war
URL_USERDETAILS = https://github.com/bioatlas/userdetails/releases/download/SBDI-2.4.0/userdetails-2.4.0.war
URL_APIKEY = https://nexus.ala.org.au/service/local/repositories/releases/content/au/org/ala/apikey/1.5/apikey-1.5.war

init:
	@echo "Caching files required for the build..."

	@test -f cas5/cas-exec.war || \
		wget -q --show-progress -O cas5/cas-exec.war $(URL_CAS5)

	@test -f cas-management/cas-management-5.3.6-1-exec.war || \
		wget -q --show-progress -O cas-management/cas-management-5.3.6-1-exec.war $(URL_CAS_MANAGEMENT)

	@test -f userdetails/userdetails-2.4.0.war || \
		wget -q --show-progress -O userdetails/userdetails-2.4.0.war $(URL_USERDETAILS)

	@test -f apikey/apikey-1.5.war || \
		wget -q --show-progress -O apikey/apikey-1.5.war $(URL_APIKEY)

init-clean:
	@echo "Removing cached files from the build"
	rm -f cas5/cas-exec*.war \
	cas-management/cas-management*.war \
	userdetails/userdetails*.war \
	apikey/apikey*.war

down:
	docker-compose down

up:
	@echo "Starting services..."
	@COMPOSE_HTTP_TIMEOUT=200 docker-compose up -d

stop:
	@echo "Stopping services..."
	@docker-compose stop

build:
	@echo "Building images..."
	@docker build --no-cache -t bioatlas/ala-cas -t bioatlas/ala-cas:v5.3.12-2 cas5
	@docker build --no-cache -t bioatlas/ala-cas-management -t bioatlas/ala-cas-management:v5.3 cas-management
	@docker build --no-cache -t bioatlas/ala-userdetails -t bioatlas/ala-userdetails:v2.4 userdetails
	@docker build --no-cache -t bioatlas/ala-apikey -t bioatlas/ala-apikey:v1.5 apikey

push:
	@echo "Pushing images to Dockerhub..."
	@docker push bioatlas/ala-cas:v5.3.12-2
	@docker push bioatlas/ala-cas-management:v5.3
	@docker push bioatlas/ala-userdetails:v2.4
	@docker push bioatlas/ala-apikey:v1.5
	@docker push bioatlas/ala-cas:latest
	@docker push bioatlas/ala-cas-management:latest
	@docker push bioatlas/ala-userdetails:latest
	@docker push bioatlas/ala-apikey:latest

release: build push
