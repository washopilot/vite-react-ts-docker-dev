FROM node:20-alpine as base
ARG WWWUSER
ARG WWWGROUP
RUN addgroup ${WWWGROUP} && adduser -S -G ${WWWGROUP} ${WWWUSER}

FROM base as cache
RUN \
    apk add --no-cache rsync; \
    apk add --no-cache libc6-compat
WORKDIR /cache
COPY package.json package-lock.json* ./
RUN npm ci -d && npm cache clean --force    

FROM cache as development
USER ${WWWUSER}:${WWWGROUP}
WORKDIR /app
# COPY --chown=app:app . .

# CMD [ "sleep", "infintly" ]
CMD \
    sh -c "rsync -arv /cache/node_modules/. /app/node_modules" && \
    npm run dev -- --host; 
