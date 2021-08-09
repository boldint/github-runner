FROM ubuntu:20.04 as builder
WORKDIR /tmp
RUN \
  apt-get -yqq update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -yqq --no-install-recommends curl jq wget python3-minimal python3-pip python3-dev apt-transport-https ca-certificates gnupg software-properties-common lsb-release sudo unzip make g++ && \
  # GOOGLE CLOUD SDK
  wget -q https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-350.0.0-linux-x86_64.tar.gz -O ./google-cloud-sdk.tar.gz && \
  tar zxf google-cloud-sdk.tar.gz && mv google-cloud-sdk / && \
  # GITVERSION
  wget -q https://github.com/GitTools/GitVersion/releases/download/5.6.11/gitversion-linux-x64-5.6.11.tar.gz -O gitversion-linux-x64.tar.gz && \
  tar zxf gitversion-linux-x64.tar.gz && mv gitversion /usr/local/bin/ && \
  # GIT-CHGLOG
  wget -q https://github.com/git-chglog/git-chglog/releases/download/v0.15.0/git-chglog_0.15.0_linux_amd64.tar.gz -O git-chglog.tar.gz && \
  tar zxf git-chglog.tar.gz git-chglog && mv git-chglog /usr/local/bin/ && \
  # TERRAFORM
  wget -q https://releases.hashicorp.com/terraform/1.0.3/terraform_1.0.3_linux_amd64.zip -O terraform.zip && \
  unzip terraform.zip && mv terraform /usr/local/bin/ && \
  # TERRAGRUNT
  wget -q https://github.com/gruntwork-io/terragrunt/releases/download/v0.31.3/terragrunt_linux_amd64 -O ./terragrunt && \
  chmod u+x terragrunt && mv terragrunt /usr/local/bin/ && \
  # HELM
  wget -q https://get.helm.sh/helm-v3.6.3-linux-amd64.tar.gz -O helm-v3.6.3-linux-amd64.tar.gz && \
  tar -zxvf helm-v3.6.3-linux-amd64.tar.gz && mv linux-amd64/helm /usr/local/bin/ && \
  # PRE-COMMIT
  pip3 -q install pre-commit --no-cache-dir && \ 
  # CHECKOV
  pip3 -q install checkov --no-cache-dir && \
  # JSONNET
  pip3 -q install jsonnet --no-cache-dir && \
  # INFRACOST
  curl -fsSL https://raw.githubusercontent.com/infracost/infracost/master/scripts/install.sh | sh && \
  # TFLINT
  curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash && \
  # KUBECTL 
  curl -LO https://dl.k8s.io/release/v1.22.0/bin/linux/amd64/kubectl && \
  sudo install -m 0755 kubectl /usr/local/bin/kubectl

WORKDIR /home/actions/actions-runner
RUN \
  # GITHUB ACTIONS RUNNER
  wget -q https://github.com/actions/runner/releases/download/v2.279.0/actions-runner-linux-x64-2.279.0.tar.gz -O actions-runner-linux-x64.tar.gz && \
  useradd actions && tar xzf actions-runner-linux-x64.tar.gz -C /home/actions/actions-runner && \
  chown -R actions ~actions && /home/actions/actions-runner/bin/installdependencies.sh && \
  rm -rf actions-runner-linux-x64.tar.gz && \
  #DOCKER
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - && \
  sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable" && \
  sudo apt install -yqq docker-ce

FROM ubuntu:20.04
# PATH FOR SDK
ENV PATH="${PATH}:/google-cloud-sdk/bin"
# MULTI-STAGE
COPY --from=builder /google-cloud-sdk /google-cloud-sdk
COPY --from=builder /home/actions/actions-runner/. /home/actions/actions-runner/
COPY --from=builder /usr/local/bin/. /usr/local/bin
#COPY --from=builder /usr/local/bin/terraform /usr/local/bin
#COPY --from=builder /usr/local/bin/terragrunt /usr/local/bin
#COPY --from=builder /usr/local/bin/infracost /usr/local/bin
#COPY --from=builder /usr/local/bin/tflint /usr/local/bin
#COPY --from=builder /usr/local/bin/gitversion /usr/local/bin
#COPY --from=builder /usr/local/bin/git-chglog /usr/local/bin
#COPY --from=builder /usr/local/bin/pre-commit /usr/local/bin
#COPY --from=builder /usr/local/bin/checkov /usr/local/bin
#COPY --from=builder /usr/local/bin/kubectl /usr/local/bin
#COPY --from=builder /usr/local/bin/helm /usr/local/bin

# FILES NEEDED
COPY infracost_api_creds.yml /home/actions/.config/infracost/credentials.yml
COPY entrypoint.sh /home/actions/actions-runner/entrypoint.sh
COPY .tflint.hcl /home/actions/actions-runner/.

# STARTER
RUN \
  apt-get -yqq update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -yqq --no-install-recommends software-properties-common apt-transport-https ca-certificates sudo && \
  # ACTIONS-RUNNER USER  
  useradd actions && chown -R actions ~actions && \
  #TERRAGRUNT PERMISSIONS
  sudo chmod u+x /usr/local/bin/terragrunt && \
  sudo chmod u+x /usr/local/bin/gitversion && \
  # TFLINT
  tflint --init && \
  # CLEAN UP
  apt-get -yqq clean all && apt-get -yqq autoremove && \
  rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/* /tmp/*

WORKDIR /home/actions/actions-runner
USER actions
ENTRYPOINT ["/home/actions/actions-runner/entrypoint.sh"]
