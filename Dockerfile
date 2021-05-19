FROM cloudposse/build-harness:0.58.0

RUN apk add --update --no-cache go bats vert@cloudposse terraform-config-inspect@cloudposse \
  terraform-0.11@cloudposse terraform-0.12@cloudposse terraform-0.13@cloudposse terraform-0.14@cloudposse terraform-0.15@cloudposse

COPY test/ /test/

WORKDIR /
