FROM node:22.12-alpine AS builder

WORKDIR /app

COPY package*.json ./
COPY tsconfig.json ./

RUN --mount=type=cache,target=/root/.npm npm ci --ignore-scripts

COPY src/ ./src/

RUN npm run build

FROM node:22-alpine AS release

WORKDIR /app

COPY --from=builder /app/dist /app/dist
COPY --from=builder /app/package.json /app/package.json
COPY --from=builder /app/package-lock.json /app/package-lock.json

ENV NODE_ENV=production
# Inside a container the loopback default is unreachable through `-p`; the
# host-side exposure is controlled by the `docker run -p` mapping instead.
ENV BIND_ADDRESS=0.0.0.0

RUN npm ci --ignore-scripts --omit-dev

USER node

EXPOSE 8080

ENTRYPOINT ["node", "dist/http.js"]
