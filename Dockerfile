FROM node:alpine as builder

ENV NODE_ENV=production

WORKDIR /app

RUN \
    apk update \
    && apk add --no-cache --virtual .gyp python3 make g++ \
    && npm install node-gyp bcrypt \
    && apk del .gyp

FROM node:alpine

COPY . .
COPY --from=builder /app/node_modules .
# npm clean-install --omit=dev
RUN \
    npm install --omit=dev \
    && npm run build

USER node
CMD ["node", "next", "start"]
