pipeline {
    agent {
        node {
            label 'maven'
        }
    }
    stages {
        stage("build"){
            steps{
                sh 'mvn deploy'
            }
        }

         stage('SonarQube analysis') {
    environment {
      scannerHome = tool 'valaxy-sonar-scanner'
    }
    steps{
    withSonarQubeEnv('valaxy-sonarqube-server') { // If you have configured more than one global server connection, you can specify its name
      sh "${scannerHome}/bin/sonar-scanner"
    }
    }
    }}}
