FROM node:12-stretch AS build
LABEL maintainer="vitalygrischenko@gmail.com"

WORKDIR /home/node/

COPY --chown=0:0 . .
RUN npm install \
    && npm run build


FROM nginx:latest AS production

ENV APP_DIR="/usr/share/nginx/html/" \
    BUILD_DIR="/home/node/build"
    
COPY --from=build --chown=nginx:nginx ${BUILD_DIR}/* ${APP_DIR}
ARG DEFAULT_API_ROOT
ENV API_ROOT=${DEFAULT_API_ROOT:-"https://conduit.productionready.io/api"}
CMD sed -i /usr/share/nginx/html/static/js/* "s|https://conduit.productionready.io/api|${API_ROOT}|" && exec nginx -g 'daemon off;'

