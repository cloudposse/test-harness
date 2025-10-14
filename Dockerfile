FROM cloudposse/build-harness:latest

RUN echo '@community https://dl-cdn.alpinelinux.org/alpine/edge/community' >> /etc/apk/repositories

RUN apk del --no-interactive terraform-1 terraform
RUN apk add --update --no-cache go bats vert@cloudposse \
  terraform-config-inspect@cloudposse terraform-docs@cloudposse \
  terraform-0.11@cloudposse terraform-0.12@cloudposse terraform-0.13@cloudposse \
  terraform-0.14@cloudposse terraform-0.15@cloudposse \
  opentofu@community \
  atmos@cloudposse


# https://www.hashicorp.com/en/blog/installing-hashicorp-tools-in-alpine-linux-containers
ENV PRODUCT="terraform"
ENV VERSION="v1.13.3"

RUN apk add --update --virtual .deps --no-cache gnupg && \
    cd /tmp && \
    wget https://releases.hashicorp.com/${PRODUCT}/${VERSION}/${PRODUCT}_${VERSION}_linux_amd64.zip && \
    wget https://releases.hashicorp.com/${PRODUCT}/${VERSION}/${PRODUCT}_${VERSION}_SHA256SUMS && \
    wget https://releases.hashicorp.com/${PRODUCT}/${VERSION}/${PRODUCT}_${VERSION}_SHA256SUMS.sig && \
    wget -qO- https://www.hashicorp.com/.well-known/pgp-key.txt | gpg --import && \
    gpg --verify ${PRODUCT}_${VERSION}_SHA256SUMS.sig ${PRODUCT}_${VERSION}_SHA256SUMS && \
    grep ${PRODUCT}_${VERSION}_linux_amd64.zip ${PRODUCT}_${VERSION}_SHA256SUMS | sha256sum -c && \
    unzip /tmp/${PRODUCT}_${VERSION}_linux_amd64.zip -d /tmp && \
    mv /tmp/${PRODUCT} /usr/local/bin/${PRODUCT}-1 && \
    rm -f /tmp/${PRODUCT}_${VERSION}_linux_amd64.zip ${PRODUCT}_${VERSION}_SHA256SUMS ${VERSION}/${PRODUCT}_${VERSION}_SHA256SUMS.sig && \
    apk del .deps

# Install `tofu` as an alternative to `terraform`, if it is available.
# Set priority to 5, which is lower than any other Cloud Posse Terraform package,
# so that it is available, if Terraform is not installed, but does not interfere with Terraform installations.
RUN update-alternatives --install /usr/bin/terraform terraform /usr/local/bin/${PRODUCT}-1 4

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
