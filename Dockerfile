FROM docker.io/node:24.16.0-alpine3.24 AS builder

WORKDIR /app

COPY package.json ./
COPY package-lock.json ./
RUN npm install

COPY ./src /app/src
COPY ./public /app/public
COPY index.html /app/index.html

# TODO: create a successful build, set npm install and remove /app/dist line instead 
#RUN npm run build
RUN mkdir /app/dist

FROM docker.io/nginx:1.23.1-alpine
RUN rm -rf /etc/nginx/conf.d
COPY nginx/default.conf /etc/nginx/conf.d/default.conf
COPY ./index.html /app/index.html

WORKDIR /app
COPY --from=builder /app/dist .
COPY entrypoint.sh .
RUN cp -r * /usr/share/nginx/html && \
    mkdir -p /usr/share/nginx/html/assets

EXPOSE 80
CMD ["./entrypoint.sh"]