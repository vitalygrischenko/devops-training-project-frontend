FROM node:12-stretch AS build

ARG REPO_URL="https://github.com/Pavel-Soloduha/devops-training-project"

WORKDIR /opt/frontend
ADD ./ ./
RUN npm install && \
    npm run build






FROM nginx:latest
COPY --from=build --chown=nginx:nginx /opt/frontend/build/ /usr/share/nginx/html/
ARG DEFAULT_API_URL
ENV API_URL=${DEFAULT_API_URL:-"https://conduit.productionready.io/api"}
CMD sed "s|https://conduit.productionready.io/api|${API_URL}|" -i /usr/share/nginx/html/static/js/* && exec nginx -g 'daemon off;'
