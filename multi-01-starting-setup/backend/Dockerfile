FROM node:14

WORKDIR /app

COPY package.json .

RUN npm install

COPY . .

EXPOSE 8000

ENV MONGODB_USERNAME=ROOT
ENV MONGODB_PASSWORD=SECRET

CMD [ "npm", "start" ]
