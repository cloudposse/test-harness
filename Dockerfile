FROM cloudposse/build-harness:latest

RUN echo '@community https://dl-cdn.alpinelinux.org/alpine/edge/community' >> /etc/apk/repositories

RUN apk add --update --no-cache go bats vert@cloudposse \
  terraform-config-inspect@cloudposse terraform-docs@cloudposse \
  terraform-0.11@cloudposse terraform-0.12@cloudposse terraform-0.13@cloudposse \
  terraform-0.14@cloudposse terraform-0.15@cloudposse terraform-1@cloudposse \
	opentofu@community


COPY test/ /test/

# Our old Makefiles conditionally set TF_CLI_ARGS_init=-get-plugins=true but that
# became a no-op in Terraform 0.13 and is rejected by Terraform 0.15.
# We set it here to blank to keep the Makefile from setting it, although this
# may break Terraform 0.12 in some cases.
ENV TF_CLI_ARGS_init=""

WORKDIR /
