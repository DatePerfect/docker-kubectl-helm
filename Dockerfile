FROM docker:dind

# Note: Latest version of kubectl may be found at:
# https://aur.archlinux.org/packages/kubectl-bin/
ENV KUBE_LATEST_VERSION="v1.13.0"
# Note: Latest version of helm may be found at:
# https://github.com/kubernetes/helm/releases
ENV HELM_VERSION="v2.12.0"

# Install git, SSH, and other utilities
RUN apk add --no-cache \
  bash ca-certificates git python3 \
  && wget -q https://storage.googleapis.com/kubernetes-release/release/${KUBE_LATEST_VERSION}/bin/linux/amd64/kubectl -O /usr/local/bin/kubectl \
  && chmod +x /usr/local/bin/kubectl \
  && wget -q https://storage.googleapis.com/kubernetes-helm/helm-${HELM_VERSION}-linux-amd64.tar.gz -O - | tar -xzO linux-amd64/helm > /usr/local/bin/helm \
  && chmod +x /usr/local/bin/helm

# Install dependencies by all python images equivalent to buildpack-deps:jessie
# on the public repos.
RUN set -ex \
    && pip3 install awscli boto3

VOLUME /var/lib/docker

COPY dockerd-entrypoint.sh /usr/local/bin/

ENTRYPOINT ["/usr/local/bin/dockerd-entrypoint.sh"]
