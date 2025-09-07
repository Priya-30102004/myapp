pipeline {
  agent any

  environment {
    IMAGE_NAME = "myapp"
  }

  stages {
    stage('Checkout') {
      steps {
        checkout scm
      }
    }

    stage('Build with Maven') {
      steps {
        sh 'mvn -B -DskipTests clean package'
      }
    }

    stage('Build Docker Image') {
      steps {
        script {
          // tag with build number
          IMAGE_TAG = "${env.BUILD_NUMBER}"
          sh "docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ."
          // also tag with latest
          sh "docker tag ${IMAGE_NAME}:${IMAGE_TAG} ${DOCKER_USER}/${IMAGE_NAME}:${IMAGE_TAG} || true"
        }
      }
    }

    stage('Push to Docker Hub') {
      steps {
        withCredentials([usernamePassword(credentialsId: 'dockerhub-cred', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
          sh 'echo "$DOCKER_PASS" | docker login -u "$DOCKER_USER" --password-stdin'
          sh 'docker tag myapp:${BUILD_NUMBER} ${DOCKER_USER}/myapp:${BUILD_NUMBER}'
          sh 'docker push ${DOCKER_USER}/myapp:${BUILD_NUMBER}'
          sh 'docker tag ${DOCKER_USER}/myapp:${BUILD_NUMBER} ${DOCKER_USER}/myapp:latest'
          sh 'docker push ${DOCKER_USER}/myapp:latest'
        }
      }
    }
  }
}

