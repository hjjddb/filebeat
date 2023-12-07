PROJECT_PATH=$(shell pwd)
# container structure
image=filebeat
version=8.11.1
container=filebeat
# log folder
log_folder=/export/var/log/baas
# filebeat config file
config_file=$(PROJECT_PATH)/configs/filebeat.yml
# current host
host=42.96.43.194
# kibana host
kibana_host=http://$(host):5050
# elasticsearch host
elasticsearch_host=http://$(host):5100

.PHONY: all
all: deploy

.PHONY: create-network
network:
	-docker network create $(network)

.PHONY: remove-container
remove-container:
	-docker rm -f $(container)

.PHONY: build
build:
	docker build \
	-t $(image):$(version) \
	-t $(image) \
	--build-arg setup_kibana_host=$(kibana_host) \
	--build-arg output_elasticsearch_hosts=[$(elasticsearch_host)] \
	$(PROJECT_PATH)


.PHONY: deploy
deploy: network remove-container build
	docker run \
	--name $(container) \
	-v $(log_folder):/var/log \
	-it \
	-d \
	$(image)

.PHONY: git-push
git-push:
	@for remote in $$(git remote); do \
		echo "Pushing to $$remote"; \
        git push $$remote; \
	done