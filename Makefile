DOCKER_IMAGE_NAME := skippyprime/acme-dns
DOCKER_BUILD_PLATFORMS := linux/amd64,linux/arm64,linux/arm/v7,linux/arm/v6

build:
	docker build -f v1.1/debian/Dockerfile -t $(DOCKER_IMAGE_NAME):v1.1-bookworm --platform $(DOCKER_BUILD_PLATFORMS) .
	docker build -f v1.1/alpine/Dockerfile -t $(DOCKER_IMAGE_NAME):v1.1-alpine --platform $(DOCKER_BUILD_PLATFORMS) .
	docker build -f v1.0/debian/Dockerfile -t $(DOCKER_IMAGE_NAME):v1.0-bookworm --platform $(DOCKER_BUILD_PLATFORMS) .
	docker build -f v1.0/alpine/Dockerfile -t $(DOCKER_IMAGE_NAME):v1.0-alpine --platform $(DOCKER_BUILD_PLATFORMS) .

tag: build
	docker tag $(DOCKER_IMAGE_NAME):v1.1-alpine $(DOCKER_IMAGE_NAME):v1.1
	docker tag $(DOCKER_IMAGE_NAME):v1.1-alpine $(DOCKER_IMAGE_NAME):latest
	docker tag $(DOCKER_IMAGE_NAME):v1.0-alpine $(DOCKER_IMAGE_NAME):v1.0

push: tag
	docker push $(DOCKER_IMAGE_NAME):v1.1-alpine
	docker push $(DOCKER_IMAGE_NAME):v1.1-bookworm
	docker push $(DOCKER_IMAGE_NAME):v1.1
	docker push $(DOCKER_IMAGE_NAME):latest
	docker push $(DOCKER_IMAGE_NAME):v1.0-alpine
	docker push $(DOCKER_IMAGE_NAME):v1.0-bookworm
	docker push $(DOCKER_IMAGE_NAME):v1.0

.PHONY: build tag push