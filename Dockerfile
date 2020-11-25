FROM cloudposse/build-harness:0.44.2

RUN apk add go terraform-0.11@cloudposse terraform-0.12@cloudposse terraform-0.13@cloudposse terraform-0.14@cloudposse

COPY test/ /test/

WORKDIR /
