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

    // Uploading Docker images into AWS ECR
    stage('Pushing to ECR') {
        steps{
            script {
                sh 'docker build -t 004394526371.dkr.ecr.us-east-1.amazonaws.com/assignment_repo . '
                sh 'aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin 004394526371.dkr.ecr.us-east-1.amazonaws.com '
                sh 'docker push 004394526371.dkr.ecr.us-east-1.amazonaws.com/assignment_repo'
            }
        }
    }

    
    stage('Docker Run') {
     steps{
         script {
             sshagent(credentials : ["63336fb5-acd2-474a-9a91-b63ae59aaddc"]){

                sh 'ssh -t -t ubuntu@10.0.2.52 -o StrictHostKeyChecking=no "docker login -u AWS -p $(aws ecr get-login-password --region us-east-1) 004394526371.dkr.ecr.us-east-1.amazonaws.com && docker run -d -p 8080:8081 --rm --name nodeapp 004394526371.dkr.ecr.us-east-1.amazonaws.com/assignment_repo:latest"'

             }
                
                
            }
      }
    }
    }
}