TEST_HARNESS_CONTAINER_NAME ?= test-harness
TEST_HARNESS_LOCAL_ROOT ?= $(shell pwd)
TEST_HARNESS_WORKING_DIR ?= .
TEST_HARNESS_TARGET ?= test
TEST_HARNESS_DEFAULT_PATH ?= /go/bin:/usr/local/go/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

DOCKER ?= DOCKER
DOCKER_ORG ?= cloudposse
DOCKER_IMAGE ?= $(DOCKER_ORG)/test-harness
DOCKER_TAG ?= latest
DOCKER_IMAGE_NAME ?= $(DOCKER_IMAGE):$(DOCKER_TAG)

.PHONY: in-docker

## Run a containerized test-harness module
in-docker: export DOCKER_DEFAULT_PLATFORM ?= linux/amd64
in-docker: TEST_HARNESS_TERRAFORM_VERSION ?= $(shell curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | jq -r -M '.current_version' | cut -d. -f1)
in-docker: TEST_HARNESS_TERRAFORM_PATH ?= /usr/local/terraform/$(TEST_HARNESS_TERRAFORM_VERSION)/bin
in-docker:
	"$(DOCKER)" run --name $(TEST_HARNESS_CONTAINER_NAME) --rm -it \
		-e GITHUB_TOKEN \
		-e AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY -e AWS_SESSION_TOKEN -e AWS_ENDPOINT_URL \
		-e PATH="$(TEST_HARNESS_PATH):$(TEST_HARNESS_TERRAFORM_PATH):$(TEST_HARNESS_DEFAULT_PATH)" \
		-v $(TEST_HARNESS_LOCAL_ROOT):/module/ \
		$(DOCKER_IMAGE_NAME) -C /module/$(TEST_HARNESS_WORKING_DIR) $(TEST_HARNESS_TARGET)

# Example for Makefile target to run with terratest (Makefile in ./test/src)
#
# test: init
#	go mod download
#	go test -v -timeout 60m
#
# test/docker: TEST_HARNESS_LOCAL_ROOT = $(CURDIR)/../../
# test/docker: TEST_HARNESS_WORKING_DIR = test/src
# test/docker: test/run/in-docker
