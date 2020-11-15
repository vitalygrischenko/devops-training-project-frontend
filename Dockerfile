FROM node:12-stretch AS build
LABEL maintainer="vitalygrischenko@gmail.com"

ARG API_ROOT="conduit.productionready.io"

WORKDIR /home/node/
RUN sed -i "s/conduit.productionready.io\\/api/${API_ROOT}/g" src/agent.js \
    && npm install \
    && npm run build


FROM nginx

ENV APP_DIR="/usr/share/nginx/html/" \
    BUILD_DIR="/home/node/build"
    
COPY --from=build --chown=nginx:nginx ${BUILD_DIR}/* ${APP_DIR}

CMD ["nginx", "-g", "daemon off;"]

