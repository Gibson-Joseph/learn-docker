FROM node

WORKDIR /app

COPY package.json /app

RUN npm install

COPY . /app

EXPOSE 8000

CMD ["node", "server.js"]
# If you don't specificy a CMD, the CMD of the base image will be executed. With no base image and no CMD, you'd get an error. 