pipeline {
    agent {
        node {
            label 'maven'
        }
    }
environment{
    PATH = "/opt/apache-maven-3.6.3/bin:$PATH"
}
    stages {
        stage("Build") {
            steps {
                sh 'mvn deploy'
            }
        }
    }
}
