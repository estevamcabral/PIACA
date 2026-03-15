FROM node:20-alpine
WORKDIR /app
COPY src/package*.json ./
RUN npm install
COPY . .
CMD ["node", "src/index.js"]