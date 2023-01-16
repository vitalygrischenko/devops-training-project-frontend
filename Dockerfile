FROM node:12-stretch as build

WORKDIR /app
#USER root
#RUN apk update \
#    && apk upgrade \
#    && rm -rf /var/cache/apk/*

COPY package*.json ./
RUN npm install

COPY ./ ./
ARG API_ROOT
RUN sed -i "s/https:\/\/conduit\.productionready\.io\/api/http:\/\/${API_ROOT}/g" src/agent.js \
    && npm run build

FROM nginx:1.21.6-alpine
#RUN apk update \
#    && apk upgrade \
#    && rm -rf /var/cache/apk/*

WORKDIR /usr/share/nginx/html
ENV BUILD_DIR="/app/build"
    
#RUN rm -rf ${APP_PATH}/*
COPY --from=build ${BUILD_DIR} ./

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

