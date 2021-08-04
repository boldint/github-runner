FROM ubuntu:20.04 

### VERSIONS
ENV RUNNER_VERSION=2.279.0
ENV GITCHGLOG_VERSION=0.15.0
ENV TERRAFORM_VERSION=1.0.3
ENV TERRAGRUNT_VERSION=0.31.3
ENV GITVERSION_VERSION=5.6.11
ENV GCLOUD_SDK_VERSION=350.0.0

### ADDITIONAL PATHS
ENV PATH="${PATH}:/google-cloud-sdk/bin"

### BASE
RUN \
  echo "BASE" && \
  apt-get -yqq update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -yqq --no-install-recommends curl jq wget python3-minimal python3-pip apt-transport-https ca-certificates gnupg software-properties-common lsb-release sudo unzip && \
  mkdir -p /SETUP
WORKDIR /SETUP

### DOWNLOAD
RUN \
  echo "DOWNLOAD" && \
  # GITHUB ACTIONS RUNNER
  wget https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-x64-${RUNNER_VERSION}.tar.gz -O actions-runner-linux-x64.tar.gz && \
  # GOOGLE CLOUD SDK
  wget https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-${GCLOUD_SDK_VERSION}-linux-x86_64.tar.gz -O ./google-cloud-sdk.tar.gz && \
  # TERRAGRUNT
  wget https://github.com/gruntwork-io/terragrunt/releases/download/v${TERRAGRUNT_VERSION}/terragrunt_linux_amd64 -O ./terragrunt && \
  # TERRAFORM
  wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip -O terraform.zip && \
  # GITVERSION
  wget https://github.com/GitTools/GitVersion/releases/download/${GITVERSION_VERSION}/gitversion-linux-x64-${GITVERSION_VERSION}.tar.gz -O gitversion-linux-x64.tar.gz && \
  # GIT-CHGLOG
  wget https://github.com/git-chglog/git-chglog/releases/download/v${GITCHGLOG_VERSION}/git-chglog_${GITCHGLOG_VERSION}_linux_amd64.tar.gz -O git-chglog.tar.gz

### INSTALL
RUN \
  echo "INSTALL" && \
  # GITHUB ACTIONS RUNNER
  useradd -m actions && \
#  LABEL="$(curl -s -X GET 'https://api.github.com/repos/actions/runner/releases/latest' | jq -r '.tag_name')" \
#  RUNNER_VERSION="$(echo ${latest_version_label:1})" \
  mkdir -p /home/actions/actions-runner && tar xzf actions-runner-linux-x64.tar.gz -C /home/actions/actions-runner && \
  # GOOGLE CLOUD SDK
  tar zxf google-cloud-sdk.tar.gz && mv google-cloud-sdk / && \
  # TERRAGRUNT
  chmod u+x terragrunt && mv terragrunt /usr/local/bin/ && \
  # TERRAFORM
  unzip terraform.zip && mv terraform /usr/local/bin/ && \
  # GITVERSION
  tar zxf gitversion-linux-x64.tar.gz && mv gitversion /usr/local/bin/ && \
  # GIT-CHGLOG
  tar zxf git-chglog.tar.gz git-chglog && mv git-chglog /usr/local/bin/ && \
  # PRE-COMMIT
  pip3 install pre-commit --no-cache-dir && \
  # CHECKOV
  pip3 install checkov --no-cache-dir && \
  # INFRACOST
  curl -fsSL https://raw.githubusercontent.com/infracost/infracost/master/scripts/install.sh | sh && \
  # TFLINT
  curl https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash

### SETUP
# TFLINT
COPY .tflint.hcl .
RUN tflint --init
# INFRACOST
RUN mkdir -p /home/actions/.config/infracost/
COPY infracost_api_creds.yml /home/actions/.config/infracost/credentials.yml
# GITHUB ACTIONS RUNNER
WORKDIR /home/actions/actions-runner
RUN chown -R actions ~actions && /home/actions/actions-runner/bin/installdependencies.sh

### CLEAN UP
RUN \
  echo "CLEAN UP" && \ 
  apt-get -yqq clean all && apt -yqq purge python3-pip && apt-get -yqq autoremove && rm -rf /SETUP

### ENTRY
COPY entrypoint.sh .
USER actions

ENTRYPOINT ["/home/actions/actions-runner/entrypoint.sh"]
