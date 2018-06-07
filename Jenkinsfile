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
            sh '''if [ ! -d devops ];then
    git clone git@github.com:yuhongchun/devops.git
else
    rm -rf devops
    git clone git@github.com:yuhongchun/devops.git
fi
'''
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