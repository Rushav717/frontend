FROM node:20.20.0-alpine3.23
RUN addgroup -S expense && adduser -S expense -G expense
RUN mkdir /opt/backend
RUN chown -R expense:expense /opt/backend
WORKDIR /opt/backend
COPY package.json .
COPY *.js ./
RUN npm install
ENV DB_HOST="mysql"
USER expense
#ENV DB_HOST="localhost"
CMD [ "node", "index.js" ]