def registry = 'https://valaxy98.jfrog.io'
def imageName = 'valaxy98.jfrog.io/valaxy-docker-local/ttrend'
def version   = '2.1.2'
pipeline {
    agent {
        node{
            label 'maven-slave'
        }
    }
environment {
        PATH = "/opt/apache-maven-3.9.2/bin:$PATH"
}
    
    stages {
        stage("build") {
            steps {
                 echo "--------Build started---------"
               sh 'mvn clean deploy -Dmaven.test.skip=true' 
                echo "--------Build  completed---------"
            }
      }
            stage("test"){
                steps{
                    echo "--------unit test started---------"
                    sh 'mvn surefire-report:report'
                    echo "--------unit test completed---------"
                } 
            }
            stage('SonarQube analysis') {
            environment{
            scannerHome = tool 'valaxy-sonar-scanner'
        }
            steps{
            withSonarQubeEnv('valaxy-sonarqube-server') { // If you have configured more than one global server connection, you can specify its name
            sh "${scannerHome}/bin/sonar-scanner"
    }
  }}
        stage("Quality Gate"){
            steps {
                script {
  timeout(time: 1, unit: 'HOURS') { // Just in case something goes wrong, pipeline will be killed after a timeout
    def qg = waitForQualityGate() // Reuse taskId previously collected by withSonarQubeEnv
    if (qg.status != 'OK') {
      error "Pipeline aborted due to quality gate failure: ${qg.status}"
    }
  }}}
            
}
             
         stage("Jar Publish") {
        steps {
            script {
                    echo '<--------------- Jar Publish Started --------------->'
                     def server = Artifactory.newServer url:registry+"/artifactory" ,  credentialsId:"artifact-cred"
                     def properties = "buildid=${env.BUILD_ID},commitid=${GIT_COMMIT}";
                     def uploadSpec = """{
                          "files": [
                            {
                              "pattern": "jarstaging/(*)",
                              "target": "libs-release-local/{1}",
                              "flat": "false",
                              "props" : "${properties}",
                              "exclusions": [ "*.sha1", "*.md5"]
                            }
                         ]
                     }"""
                     def buildInfo = server.upload(uploadSpec)
                     buildInfo.env.collect()
                     server.publishBuildInfo(buildInfo)
                     echo '<--------------- Jar Publish Ended --------------->'  
            
            }
        }   
    }   
         
    stage(" Docker Build ") {
      steps {
        script {
           echo '<--------------- Docker Build Started --------------->'
           app = docker.build(imageName+":"+version)
           echo '<--------------- Docker Build Ends --------------->'
        }
      }
    }

            stage (" Docker Publish "){
        steps {
            script {
               echo '<--------------- Docker Publish Started --------------->'  
                docker.withRegistry(registry, 'artifact-cred'){
                    app.push()
                }    
               echo '<--------------- Docker Publish End --------------->'  
            }
        }
    }

   stage("Execute Deploy.sh"){
      steps {
          script {
             echo '<----------Running Deploy.sh---------->'
             sh './deploy.sh'
       }
      }
    }
    stage('Create deploy.sh') {
            steps {
                script {
                    def deployScriptContent = '''
                    #!/bin/bash
                    echo "Deploying..."
                    # Add your deployment steps here
                    '''
                    kubectl apply -f namespace.yaml
                    kubectl apply -f secret.yaml
                    kubectl apply -f deployment.yaml
                    kubectl apply -f service.yaml


                    writeFile file: 'deploy.sh', text: deployScriptContent
                    sh 'chmod +x deploy.sh'
                }
            }
        }

        stage('Execute deploy.sh') {
            steps {
                sh './deploy.sh'
            }
        }
  
  } 
}
