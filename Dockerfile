FROM node:12-stretch AS build
LABEL maintainer="vitalygrischenko@gmail.com"

ARG API_ROOT="https://conduit.productionready.io/api"
WORKDIR /home/node/
ADD ./ ./
RUN sed "s|https://conduit.productionready.io/api|${API_ROOT}|" -i src/agent.js \
    && npm install \
    && npm run build


FROM nginx

ENV APP_DIR="/usr/share/nginx/html/" \
    BUILD_DIR="/home/node/build"
    
COPY --from=build --chown=nginx:nginx ${BUILD_DIR}/ ${APP_DIR}
RUN ls -al ${APP_DIR}/static/js/
EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

