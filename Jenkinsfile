pipeline {
  agent any
  stages {
    stage('Build') {
      parallel {
        stage('Build') {
          steps {
            sh '''echo "Building..."
'''
          }
        }
        stage('Clone Code') {
          steps {
            sh 'git clone git@github.com:yuhongchun/devops.git'
          }
        }
      }
    }
    stage('Test') {
      steps {
        sh '''echo \'Testing...\'
cd ./devops/ansible
/bin/bash sayhello.sh
'''
      }
    }
    stage('Deploy') {
      steps {
        sh 'echo "Finished!"'
      }
    }
  }
}