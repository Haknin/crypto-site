def connectToServer(String ipAddress) {
    script {
        withCredentials([sshUserPrivateKey(credentialsId: 'ssh-ori109', keyFileVariable: 'ssh-ori109')]) {
            sshagent(['ssh-ori109']) {
                sh """
                ssh -o StrictHostKeyChecking=no -i ssh-ori109 ec2-user@$ipAddress '
                sudo yum install docker -y
                sudo systemctl restart docker
                sudo docker-compose up -p 5000:5000 haknin/crypto_docker:latest
                '
                """
            }
        }
    }
}

pipeline {
    agent any

    environment {
        EC2_IP_TEST = "3.64.252.114"
        EC2_IP_PROD = "3.71.9.131"
    }
    stages {

        stage('Cleanup') {
            steps {
                cleanWs()
                sh 'rm -rf *'
            }
        }
        stage('Clone') {
            steps {
                sh 'git clone https://github.com/Haknin/crypto-site.git'
            }
        }
        stage('Login to Docker Hub') {
            steps {
                withCredentials([
                    usernamePassword(credentialsId: 'docker_login', usernameVariable: 'DOCKER_HUB_USERNAME', passwordVariable: 'DOCKER_HUB_PASSWORD')
                ]) {
                    sh "docker login -u $DOCKER_HUB_USERNAME -p $DOCKER_HUB_PASSWORD"
                }
            }
        }
        stage('Build Docker Image') {
            steps {
                sh 'docker image prune -a -f'
                sh 'docker container prune -f'
                sh 'docker rmi \$(docker images -q) || true'
                sh 'cd crypto-site && docker build --no-cache -t haknin/crypto_docker .'
            }
        }
        stage('Push to Docker Hub') {
            steps {
                sh 'docker push haknin/crypto_docker:latest'
            }
        }
        stage('Upload to TEST') {
            steps {
                script {
                    withCredentials([
                        sshUserPrivateKey(credentialsId: 'ssh-ori109', keyFileVariable: 'ssh-ori109')
                    ]) {
                        sshagent(['ssh-ori109']) {
                            sh """
                            ssh -o StrictHostKeyChecking=no ec2-user@$EC2_IP_TEST '
                            sudo yum install docker -y
                            sudo yum install git -y
                            cd crypto-site
                            sudo docker-compose down
                            sudo rm -fr crypto-site
                            git clone https://github.com/Haknin/crypto-site.git
                            sudo docker pull haknin/crypto_docker:latest
                            sudo systemctl restart docker
                            cd /home/ec2-user/crypto-site
                            sudo curl -L https://github.com/docker/compose/releases/download/1.22.0/docker-compose-\$(uname -s)-\$(uname -m) -o /usr/local/bin/docker-compose
                            cd /home/ec2-user/crypto-site
                            sudo docker-compose up -d
                            docker rmi $(docker images -a -q)
                            '
                            """
                        }
                    }
                }
            }
        }
        stage('Test Site') {
            steps {
                script {
                    withCredentials([
                        sshUserPrivateKey(credentialsId: 'ssh-ori109', keyFileVariable: 'ssh-ori109')
                    ]) {
                        sshagent(['ssh-ori109']) {
                            sh """
                            ssh -o StrictHostKeyChecking=no ec2-user@$EC2_IP_TEST '
                            cd /home/ec2-user/crypto-site
                            pwd
                            chmod +x test.sh
                            ./test.sh
                            '
                            """
                        }
                    }
                }
            }
        }

        stage('Upload to PROD') {
            steps {
                script {
                    withCredentials([
                        sshUserPrivateKey(credentialsId: 'ssh-ori109', keyFileVariable: 'ssh-ori109')
                    ]) {
                        sshagent(['ssh-ori109']) {
                            sh """
                            ssh -o StrictHostKeyChecking=no ec2-user@$EC2_IP_PROD '
                            sudo yum install docker -y
                            sudo yum install git -y
                            cd crypto-site
                            sudo docker-compose down
                            sudo rm -fr crypto-site
                            git clone https://github.com/Haknin/crypto-site.git
                            sudo docker pull haknin/crypto_docker:latest
                            sudo systemctl restart docker
                            cd /home/ec2-user/crypto-site
                            sudo curl -L https://github.com/docker/compose/releases/download/1.22.0/docker-compose-\$(uname -s)-\$(uname -m) -o /usr/local/bin/docker-compose
                            cd /home/ec2-user/crypto-site
                            sudo docker-compose up -d
                            docker rmi $(docker images -a -q)
                            '
                            """
                        }
                    }
                }
            }
        }
    }
}
