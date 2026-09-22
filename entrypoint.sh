#!/usr/bin/env sh
rm -rf /usr/share/nginx/html/*
cp -r /app/* /usr/share/nginx/html
nginx -g "daemon off;";