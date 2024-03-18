ARG DEBIAN_VERSION=latest

FROM debian:${DEBIAN_VERSION}

ARG NVM_VERSION=v0.39.7
ARG NODE_VERSION=node
ARG NPM_VERSION=latest
ARG FIREBASE_TOOLS_VERSION=13.4.0

LABEL version="1.0.0-alpha"
LABEL repository="https://github.com/bvianco/firebase-action"
LABEL homepage="https://github.com/bvianco/firebase-action"
LABEL maintainer="Bruno Vianco <bvianco@folderit.net>"

LABEL com.github.actions.name="GitHub Action for Firebase"
LABEL com.github.actions.description="Wraps the firebase-tools CLI to enable common commands."
LABEL com.github.actions.icon="package"
LABEL com.github.actions.color="gray-dark"

RUN apt update && apt-get install --no-install-recommends -y curl jq openjdk-17-jre && rm -rf /var/lib/apt/lists/*

RUN useradd -ms /bin/bash nvm

USER nvm

# RUN export NVM_DIR="$HOME/.nvm"

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh | bash

# RUN export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
# RUN [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
# RUN source ~/.bashrc 
RUN bash -c 'source $HOME/.nvm/nvm.sh && nvm install ${NODE_VERSION}'

RUN bash -c 'source $HOME/.nvm/nvm.sh && npm i -g npm@${NPM_VERSION} && npm cache clean --force'
RUN bash -c 'source $HOME/.nvm/nvm.sh && npm i -g firebase-tools@${FIREBASE_TOOLS_VERSION} && npm cache clean --force'

COPY LICENSE README.md /
COPY "entrypoint.sh" "/entrypoint.sh"

WORKDIR $HOME

ENTRYPOINT ["/entrypoint.sh"]
CMD ["--help"]
