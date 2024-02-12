pipeline {
   agent none
   tools{
         jdk 'Myjava'
         maven 'mymaven'
   }
   environment{
       BUILD_SERVER_IP='ec2-user@172.31.46.231'
       IMAGE_NAME='dipuharidas/mylearnings:$BUILD_NUMBER'
       DEPLOY_SERVER_IP='ec2-user@172.31.11.231'
   }
    stages {
        stage('Compile') {
           agent none
            steps {
              script{
                  echo "BUILDING THE CODE"
                  sh 'mvn compile'
              }
            }
            }
        stage('UnitTest') {
        agent none
        steps {
            script{
              echo "TESTING THE CODE"
              sh "mvn test"
              }
            }
            post{
                always{
                    junit 'target/surefire-reports/*.xml'
                }
            }
            }
        stage('PACKAGE+BUILD DOCKERIMAGE AND PUSH TO DOKCERHUB') {
            agent none            
            steps {
                script{
                sshagent(['BUILD_SERVER_KEY']) {
                withCredentials([usernamePassword(credentialsId: 'docker-hub', passwordVariable: 'PASSWORD', usernameVariable: 'USERNAME')]) {
                echo "Packaging the apps"
                sh "scp -o StrictHostKeyChecking=no server-script.sh ${BUILD_SERVER_IP}:/home/ec2-user"
                sh "ssh -o StrictHostKeyChecking=no ${BUILD_SERVER_IP} 'bash ~/server-script.sh'"
                sh "ssh ${BUILD_SERVER_IP} sudo docker build -t ${IMAGE_NAME} /home/ec2-user/myworks"
                sh "ssh ${BUILD_SERVER_IP} sudo docker login -u $USERNAME -p $PASSWORD"
                sh "ssh ${BUILD_SERVER_IP} sudo docker push ${IMAGE_NAME}"
              }
            }
            }
        }
        }
       stage('DEPLOY DOCKER CONATINER'){
           agent none
           steps{
               script{
                    sshagent(['DEPLOY_SERVER_KEY']){
                         withCredentials([usernamePassword(credentialsId: 'docker-hub', passwordVariable: 'PASSWORD', usernameVariable: 'USERNAME')]) {
                         sh "ssh -o StrictHostKeyChecking=no ${DEPLOY_SERVER_IP} sudo yum install docker -y"
                         sh "ssh ${DEPLOY_SERVER_IP} sudo systemctl start docker"
                         sh "ssh ${DEPLOY_SERVER_IP} sudo docker login -u $USERNAME -p $PASSWORD"
                         sh "ssh ${DEPLOY_SERVER_IP} sudo docker run -itd -P ${IMAGE_NAME}"
                         }
                    }
               }
           }
       }
    }
}
