FROM cloudposse/build-harness:0.47.0

RUN apk add --update --no-cache go vert@cloudposse terraform-config-inspect@cloudposse \
  terraform-0.11@cloudposse terraform-0.12@cloudposse terraform-0.13@cloudposse terraform-0.14@cloudposse

COPY test/ /test/

WORKDIR /
