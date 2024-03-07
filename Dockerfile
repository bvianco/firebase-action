ARG DEBIAN_VERSION=latest
ARG NVM_VERSION=v0.39.7
ARG NODE_VERSION=node
ARG NPM_VERSION=latest
ARG FIREBASE_TOOLS_VERSION=13.4.0

FROM debian:${DEBIAN_VERSION}

LABEL version="1.0.0-alpha"
LABEL repository="https://github.com/bvianco/firebase-action"
LABEL homepage="https://github.com/bvianco/firebase-action"
LABEL maintainer="Bruno Vianco <bvianco@folderit.net>"

LABEL com.github.actions.name="GitHub Action for Firebase"
LABEL com.github.actions.description="Wraps the firebase-tools CLI to enable common commands."
LABEL com.github.actions.icon="package"
LABEL com.github.actions.color="gray-dark"

# RUN apt update && apt-get install --no-install-recommends -y jq openjdk-11-jre && rm -rf /var/lib/apt/lists/*
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh | bash

RUN export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
RUN [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
RUN nvm install ${NODE_VERSION}

RUN npm i -g npm@${NPM_VERSION} && npm cache clean --force
RUN npm i -g firebase-tools@${FIREBASE_TOOLS_VERSION} && npm cache clean --force

COPY LICENSE README.md /
COPY "entrypoint.sh" "/entrypoint.sh"

ENTRYPOINT ["/entrypoint.sh"]
CMD ["--help"]
