@Library('github.com/releaseworks/jenkinslib') _

pipeline {
    agent any
    environment {
        registry = "004394526371.dkr.ecr.us-east-1.amazonaws.com/assignment_repo"
    }

    stages {
        stage('Cloning Git') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/main']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[credentialsId: '', url: 'https://github.com/ashu-pattanayak/final_course_assignment.git']]])
            }
        }

    // Building Docker images
    stage('Building image') {
      steps{
        script {
          dockerImage = docker.build registry
        }
      }
    }

    // Uploading Docker images into AWS ECR
    stage('Pushing to ECR') {
        steps{
            script {
                sh 'docker login -u AWS -p $(aws ecr get-login-password --region us-east-1) 004394526371.dkr.ecr.us-east-1.amazonaws.com/assignment_repo '
                sh 'docker push 004394526371.dkr.ecr.us-east-1.amazonaws.com/assignment_repo'
            }
        }
    }

    stage('Docker Run') {
     steps{
         script {
             sshagent(credentials : ['aws_ec2']){

                sh 'ssh -o StrictHostKeyChecking=no -i ashutosh.pem ubuntu@10.0.2.93'

             }
                sh 'docker run -d -p 8081:8080 --rm --name node 004394526371.dkr.ecr.us-east-1.amazonaws.com/assignment_repo'
            }
      }
    }
    }
}