# ala-cas5-docker

A dockerized setup for ALA authentcation module.

Copy `./env/envapikey.template` to `./env/.envapikey`  & `./env/envcas.template` to `./env/.envcas`.

Add necessary credentials.

The `proxy` & `dnsmasq` services section has been commented out to use external reverse proxy in production.

Uncomment to run local proxy and have domain names resolved locally in development.

Uses external network `sbdinet` in production which can be created by:

`docker network create sbdinet`
