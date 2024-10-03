# Stage 1: Build
FROM node:6.9.0 AS build

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

RUN npm run build

# Stage 2: Production
FROM node:6.9.0

WORKDIR /app

COPY package*.json ./

RUN npm install --production

COPY --from=build /app/dist ./dist

EXPOSE 5173

CMD ["node", "dist/app.js"]