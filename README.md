# Trivy DevOps Project

![GitHub Actions Workflow Status](https://github.com/FezanMuhammadAli/trivy-devops-project/actions/workflows/ci.yml/badge.svg)
![Docker Pulls](https://img.shields.io/docker/pulls/engcountio/trivy-demo-app)

This project demonstrates a complete DevOps pipeline for building, securing, and deploying a containerized Node.js application. It uses **Trivy** for vulnerability scanning, **Docker** for containerization, **GitHub Actions** for CI/CD automation, and **Docker Hub** for deployment. The project also includes a practical example of identifying and fixing vulnerabilities by switching base images.

## Project Overview
The project consists of a simple Node.js application that serves a "Hello from Trivy DevOps Project!" message on port 3000. The application is containerized using Docker, scanned for vulnerabilities with Trivy, and deployed to Docker Hub via a GitHub Actions CI/CD pipeline. The pipeline dynamically tags images (e.g., `1.1`, `1.2`, `1.3`) and assigns the `latest` tag to the most recent build.

Key features:
- Containerization with Docker.
- Vulnerability scanning with Trivy.
- Automated CI/CD pipeline with GitHub Actions.
- Dynamic tagging and deployment to Docker Hub.
- Vulnerability testing by switching base images (`node:18-alpine` vs. `node:current-alpine3.21`).

## Prerequisites
To run this project locally, ensure you have the following tools installed:
- **Docker**: For building and running containers.
- **Trivy**: For vulnerability scanning.
- **Git**: For version control.
- **Node.js and npm**: For running the application locally (optional).
- **Docker Hub Account**: For pushing and pulling images.
- **GitHub Account**: For hosting the repository and running CI/CD workflows.

### Installation Commands
- **Docker**: Install Docker Desktop (Windows/Mac) or Docker Engine (Linux) from [Docker's official site](https://docs.docker.com/get-docker/).
- **Trivy**: Install Trivy using:
  ```bash
  curl -sfL https://raw.githubusercontent.com/aquasecurity/trivy/main/contrib/install.sh | sh -s -- -b /usr/local/bin
  ```
- **Git**: Download from [Git's official site](https://git-scm.com/downloads).
- **Node.js**: Download from [nodejs.org](https://nodejs.org/) (optional for local development).

## Project Structure
```
trivy-devops-project/
├── .github/
│   └── workflows/
│       └── ci.yml          # GitHub Actions workflow for CI/CD
├── Dockerfile              # Dockerfile for building the Node.js app
├── app.js                  # Node.js application code
├── package.json            # Node.js dependencies
└── README.md               # Project documentation
```

## Setup Instructions
1. **Clone the Repository:**
   ```bash
   git clone https://github.com/FezanMuhammadAli/trivy-devops-project.git
   cd trivy-devops-project
   ```

2. **Install Dependencies (Optional):**
   If you want to run the app locally without Docker:
   ```bash
   npm install
   node app.js
   ```
   Visit `http://localhost:3000` to see the app running.

3. **Build the Docker Image Locally:**
   ```bash
   docker build -t trivy-demo-app:local .
   ```

4. **Run the Container Locally:**
   ```bash
   docker run -d -p 3000:3000 trivy-demo-app:local
   ```
   Visit `http://localhost:3000` to verify the app is running.

## Vulnerability Scanning with Trivy
Trivy is used to scan the Docker image for vulnerabilities. To scan the image locally:
```bash
trivy image trivy-demo-app:local
```

### Vulnerability Testing with Base Images
The project demonstrates how base image selection impacts security:
- **Using `node:18-alpine`:** This base image resulted in 1 HIGH severity vulnerability in the `cross-spawn` library (CVE-2024-21538).
- **Using `node:current-alpine3.21`:** Switching to this base image, along with updating dependencies, resulted in 0 vulnerabilities.
- To test this, modify the `Dockerfile` to switch the base image:
  ```dockerfile
  # Vulnerable base image
  FROM node:18-alpine
  ```
  or
  ```dockerfile
  # Secure base image
  FROM node:current-alpine3.21
  ```
  Rebuild the image and re-run the Trivy scan to observe the difference.

## CI/CD Pipeline with GitHub Actions
The project uses GitHub Actions to automate the build, scan, and deployment process. The workflow is defined in `.github/workflows/ci.yml`.

### Workflow Steps:
1. **Checkout Code:** Clones the repository.
2. **Set Up Docker Buildx:** Prepares the environment for building Docker images.
3. **Log in to Docker Hub:** Authenticates using secrets (`DOCKERHUB_USERNAME` and `DOCKERHUB_TOKEN`).
4. **Build Docker Image:** Builds the image with a dynamic tag (e.g., `1.4` based on the GitHub run number).
5. **Scan with Trivy:** Scans the image for vulnerabilities, failing if CRITICAL or HIGH vulnerabilities are found.
6. **Push to Docker Hub:** Pushes the image with the versioned tag (e.g., `1.4`) and the `latest` tag.

### Setting Up GitHub Secrets
To enable the workflow to push to Docker Hub:
1. Go to your GitHub repository > `Settings` > `Secrets and variables` > `Actions`.
2. Add the following secrets:
   - `DOCKERHUB_USERNAME`: Your Docker Hub username (e.g., `engcountio`).
   - `DOCKERHUB_TOKEN`: A Docker Hub access token (generate one in Docker Hub under `Account Settings` > `Security`).

## Deployment
The CI/CD pipeline pushes the image to Docker Hub with both a versioned tag (e.g., `1.4`) and the `latest` tag.

### Pull and Run the Latest Image
To deploy the latest version of the application:
```bash
docker pull engcountio/trivy-demo-app:latest
docker run -d -p 3000:3000 --name trivy-app-prod -e NODE_ENV=production engcountio/trivy-demo-app:latest
```
Visit `http://localhost:3000` to verify the app is running.

### Run a Specific Version
To deploy a specific version (e.g., `1.3`):
```bash
docker pull engcountio/trivy-demo-app:1.3
docker run -d -p 3000:3000 --name trivy-app-prod -e NODE_ENV=production engcountio/trivy-demo-app:1.3
```

### Clean Up
After testing, stop and remove the container:
```bash
docker stop trivy-app-prod
docker rm trivy-app-prod
```

## Docker Hub Repository
The images are hosted on Docker Hub: [engcountio/trivy-demo-app](https://hub.docker.com/repository/docker/engcountio/trivy-demo-app/general).

## Lessons Learned
- **Containerization:** Building and running a Node.js app in a Docker container.
- **Security Scanning:** Using Trivy to identify and fix vulnerabilities in container images.
- **CI/CD Automation:** Automating the build, scan, and deployment process with GitHub Actions.
- **Dynamic Tagging:** Implementing versioned tags (e.g., `1.1`, `1.2`) and a `latest` tag for easy deployment.
- **Base Image Impact:** Understanding how base image selection affects security (e.g., `node:18-alpine` vs. `node:current-alpine3.21`).

## Future Improvements
- Deploy the application to a cloud provider (e.g., AWS ECS, Kubernetes).
- Add unit tests to the CI/CD pipeline.
- Implement semantic versioning for more precise version control.
- Use monitoring tools (e.g., Prometheus, Grafana) to monitor the deployed application.
- Scan the Dockerfile for misconfigurations using `trivy config Dockerfile`.

## Contributing
Feel free to fork this repository, make improvements, and submit pull requests. For major changes, please open an issue to discuss your ideas.
