# multi-stage build
# This Dockerfile is a multi-stage build used to build a frontend (Node.js) app and then serve it using Nginx.

# 👉 Multi-stage build means:
# Stage 1: Build the application (needs Node, npm, dev dependencies)
# Stage 2: Run the built app (needs only Nginx + static files)
# --------------------------------------------

# Stage 1 – Build the Application
FROM node:14-alpine AS builder
# Named as builder so it can be referenced later

WORKDIR /app

COPY package.json .

RUN npm install

COPY . .

RUN npm run build

# Stage 2 – Production Image (Nginx)
FROM nginx:1.19-alpine

# Copy Built Files from Builder Stage
COPY --from=builder /app/build /usr/share/nginx/html

COPY conf/nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD [ "nginx", "-g", "daemon off;" ]