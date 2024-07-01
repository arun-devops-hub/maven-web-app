pipeline{
    agent any
    environment {
       DOCKERHUB_CREDENTIALS = credentials('dockerhub-cred')
       }
    stages{
        stage('Clean Workspace') {
            steps {
                cleanWs()
            }
        }
         stage('Cloning Git Code'){
            steps{
                git branch: 'master', url: 'https://github.com/arun-devops-hub/maven-web-app.git'
            }
          }
          stage('Maven build'){
              environment{
                  mvnHome = tool name: 'maven-3.9.8', type: 'maven'
                }
              steps{
                  sh "${mvnHome}/bin/mvn clean install"
                }
            }
            stage('SonarQube Analysis'){
                environment{
                  //scannerHome = tool name: 'SonarScanner', type: 'hudson.plugins.sonar.SonarRunnerInstallation' 
                  mvnHome = tool name: 'maven-3.9.8', type: 'maven'
                  CACHE_DIR = '/tmp/sonar/cache'
                }
                steps{
                  sh "mkdir -p ${CACHE_DIR} && chmod -R 777 ${CACHE_DIR}"
                  withSonarQubeEnv('sonarqube-ci'){
                      sh "${mvnHome}/bin/mvn sonar:sonar -Dsonar.cfamily.cache.path=${CACHE_DIR}"
                    }
                }
            }
            stage('Nexus Artifact'){
                steps{
                    nexusArtifactUploader artifacts: [[artifactId: '01-maven-web-app', classifier: '', 
                    file: '/var/lib/jenkins/workspace/Continuous_Job/target/01-maven-web-app.war', type: 'war']], 
                    credentialsId: 'nexus-1', groupId: 'in.ashokit', nexusUrl: '35.168.1.144:8081',
                    nexusVersion: 'nexus3', protocol: 'http', repository: 'maven-webapp-snapshot',
                    version: '01-maven-web-app'
                }   
            }
            stage('Build Docker Image'){
               steps{                     
                 	sh 'docker build -t arunhub2/maven-web-app:$BUILD_NUMBER .'     
	                echo 'Build Image Completed'                
                }           
            } 
 
            stage('Push Docker Image'){
                
                steps {
                  script {
                    // Use withCredentials to handle Docker Hub credentials securely
                      sh 'echo $DOCKERHUB_CREDENTIALS_PSW | docker login -u $DOCKERHUB_CREDENTIALS_USR --password-stdin'

                    // Push the Docker image to Docker Hub
                      sh "docker push arunhub2/maven-web-app:$BUILD_NUMBER"
                    }
                }
            }
            stage('Container up'){
                environment{
                    DOCKER_IMAGE_NAME = "arunhub2/maven-web-app:$BUILD_NUMBER"
                    DOCKER_CONTAINER_NAME = "web-app-cont"
                }
                steps{
                // Remove any existing container with the same name
                sh "docker rm -f web-app-cont || true"
                sh "docker run -itd --name web-app-cont -p 8100:8080 $DOCKER_IMAGE_NAME"
                }
            }
        }
    }
