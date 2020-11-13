
# Stage 0
FROM node:carbon-alpine as node

RUN mkdir -p /app
WORKDIR /app

COPY . /app

RUN npm install
RUN npm run concat
RUN npm run compile
RUN npm run validate
RUN npm run dredd

# Stage 1
## Dockerfile for Troops Swagger Spec
FROM swaggerapi/swagger-ui:latest as swagger-ui

ENV BASE_URL=""
ENV PORT="80"
ENV URL="https://openapi.troops.online/openapi.yaml"

RUN mkdir -p /usr/share/nginx/html/openapi

## Nginx for deployments
COPY .circleci/docker/nginx/.htpasswd /etc/nginx/.htpasswd
COPY .circleci/docker/nginx/nginx.conf /etc/nginx/nginx.conf

## Copy output from stage 0
COPY --from=0 /app/build/openapi.yaml /usr/share/nginx/html/openapi/openapi.yaml

## Start
EXPOSE 80 8080
CMD ["sh", "/usr/share/nginx/run.sh"]

# Stage 2
## Dockerfile for Troops Swagger Prism mock server
FROM stoplight/prism:3 as prism

RUN mkdir -p /openapi

## Copy output from stage 0
COPY --from=0 /app/build/openapi.yaml /openapi/openapi.yaml

## Start
EXPOSE 4010 4010
CMD ["mock", "/openapi/openapi.yaml","-h","0.0.0.0"]

