FROM node:20-alpine as base
RUN addgroup app && adduser -S -G app app

FROM base as cache
WORKDIR /app
COPY package.json package-lock.json* ./
RUN npm ci -d && npm cache clean --force    

FROM cache as development
RUN chown -R app:app /app
COPY --chown=app:app . .
USER app

CMD \
    npm run dev -- --host; 
