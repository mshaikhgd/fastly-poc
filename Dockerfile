FROM hashicorp/terraform:light

USER root
RUN apk add --update --no-cache --virtual .build-deps build-base nodejs
RUN apk add --update --no-cache npm
RUN npm install -g mustache
