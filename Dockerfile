FROM cloudposse/build-harness:latest

RUN echo '@community https://dl-cdn.alpinelinux.org/alpine/edge/community' >> /etc/apk/repositories

RUN apk del --no-interactive terraform-1 terraform
RUN apk add --update --no-cache go bats vert@cloudposse \
  terraform-config-inspect@cloudposse terraform-docs@cloudposse \
  terraform-0.11@cloudposse terraform-0.12@cloudposse terraform-0.13@cloudposse \
  terraform-0.14@cloudposse terraform-0.15@cloudposse \
  terraform-1@cloudposse=1.5.7-r0 \
  opentofu@community \
  atmos@cloudposse

# Install `tofu` as an alternative to `terraform`, if it is available.
# Set priority to 5, which is lower than any other Cloud Posse Terraform package,
# so that it is available, if Terraform is not installed, but does not interfere with Terraform installations.
RUN command -v tofu >/dev/null && update-alternatives --install /usr/bin/terraform terraform $(command -v tofu) 5

COPY test/ /test/

# Our old Makefiles conditionally set TF_CLI_ARGS_init=-get-plugins=true but that
# became a no-op in Terraform 0.13 and is rejected by Terraform 0.15.
# We set it here to blank to keep the Makefile from setting it, although this
# may break Terraform 0.12 in some cases.
ENV TF_CLI_ARGS_init=""

WORKDIR /
