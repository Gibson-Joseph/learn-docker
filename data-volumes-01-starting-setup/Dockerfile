FROM node:14

WORKDIR /app

COPY package.json . 

RUN npm install

COPY .  .

ARG DEFAULT_PORT=3000

ENV PORT=${DEFAULT_PORT}
# ENV PORT=3000

EXPOSE ${PORT}


# that is the path inside our container which should be mapped to some folder outside of the container. Here we let docker control this folder
# VOLUME [ "/app/feedback" ] 

CMD [ "npm", "start" ]