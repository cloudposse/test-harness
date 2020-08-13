FROM cloudposse/build-harness:0.37.0

RUN apk add go terraform_0.11@cloudposse terraform_0.12@cloudposse terraform_0.13@cloudposse

COPY test/ /test/

WORKDIR /
