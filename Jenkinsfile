pipeline {
  agent any
  stages {
    stage('Clone Code') {
      steps {
        sh '''if [ ! -d esservice ];then
    git clone git@gitlab.bmkp.cn:rdc_bd/esservice.git
else
    rm -rf esservice
    git clone git@gitlab.bmkp.cn:rdc_bd/esservice.git
fi
'''
      }
    }
    stage('Build') {
      steps {
        sh '''echo \'Build...\'
cd esservice
/usr/local/maven/bin/mvn clean compile install 
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