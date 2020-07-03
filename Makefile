export DOCKER_ORG ?= cloudposse
export DOCKER_IMAGE ?= $(DOCKER_ORG)/test-harness
export DOCKER_TAG ?= latest
export DOCKER_IMAGE_NAME ?= $(DOCKER_IMAGE):$(DOCKER_TAG)
export DOCKER_BUILD_FLAGS =
export README_DEPS ?= docs/targets.md

-include $(shell curl -sSL -o .build-harness "https://git.io/build-harness"; echo .build-harness)

.DEFAULT_GOAL : build

## Build docker image
build:
	@make --no-print-directory docker/build

