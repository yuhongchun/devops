pipeline {
  agent any
  stages {
    stage('Build') {
      steps {
        sh '''echo "Building..."
git clone https://github.com/yuhongchun/devops.git'''
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