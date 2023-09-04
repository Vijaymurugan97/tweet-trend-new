
pipeline {
    agent {
        node{
            label 'maven-slave'
        }
    }

    stages {
        stage('Clone code') {
            steps {
                git branch: 'main', url: 'https://github.com/Vijaymurugan97/tweet-trend-new.git'
            }
      }
            stage('SonarQube analysis') {
            environment{
            scannerHome = tool 'ttrend-sonar-scanner'
        }
            steps{
            withSonarQubeEnv('ttrend-sonarqube-server') { // If you have configured more than one global server connection, you can specify its name
            sh "${scannerHome}/bin/sonar-scanner"
    }
  }}
    }}
