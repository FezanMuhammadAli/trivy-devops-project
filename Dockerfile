# Use an official Node.js runtime as the base image
FROM node:current-alpine3.21

# Set working directory in the container
WORKDIR /app

# Copy package.json and install dependencies
COPY package.json .
RUN npm install

# Copy the application code
COPY app.js .

# Expose the port the app runs on
EXPOSE 3000

# Command to run the app
CMD ["npm", "start"]