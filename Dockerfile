FROM cloudposse/build-harness:0.44.2

RUN apk add go terraform-0.11@cloudposse terraform-0.12@cloudposse terraform-0.13@cloudposse~=0.13.3

COPY test/ /test/

WORKDIR /
