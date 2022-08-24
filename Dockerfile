FROM node:lts-alpine AS builder

LABEL maintainer="udaan"

# Add git as the prebuild target requires it to parse version information
RUN apk add --no-cache --virtual .gyp \
  python3 \
  make \
  g++

# Create app directory
WORKDIR /app

ADD . /app/

COPY . .

RUN npm install -g pnpm

RUN pnpm i --unsafe-perm=true

ENV HOST 0.0.0.0
EXPOSE 3000

RUN mv packages/hoppscotch-app/.env.example packages/hoppscotch-app/.env

RUN pnpm run generate

FROM nginx:latest

COPY --from=builder /app/packages/hoppscotch-app/dist /usr/share/nginx/html/hoppscotch-service

CMD nginx
