pipeline {
    agent { label 'AGENT-1' } 
    environment{
        PROJECT = 'expense' 
        COMPONENT = 'frontend'
        appVersion = ''
        ACC_ID = '308731954939'

    }
    options 
    { 
        disableConcurrentBuilds()
        timeout(time: 2, unit: 'MINUTES') 
    }
    parameters {

        booleanParam(name: 'deploy', defaultValue: false, description: 'Toggle this value')

    }
    stages {
        stage('Read version') {
            steps {
                script{
                   def packageJson = readJSON file: 'package.json'
                   appVersion = packageJson.version
                   echo "version is: $appVersion"
                }
            }
        }
        stage('Docker Build') {
            steps {
                script{
                    withAWS(region:'us-east-1',credentials:'aws-creds')
                    {
                    sh """
                    aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin ${ACC_ID}.dkr.ecr.us-east-1.amazonaws.com

                    docker build -t  ${ACC_ID}.dkr.ecr.us-east-1.amazonaws.com/${PROJECT}/${COMPONENT}:${appVersion} .

                    docker push ${ACC_ID}.dkr.ecr.us-east-1.amazonaws.com/${PROJECT}/${COMPONENT}:${appVersion}
                    """
                    }
                    
                }
            }
        }
        stage('trigger deploy') {
            when { 
                expression { params.deploy }
            }
            steps{
                build job: 'backend-cd', parameters: [string(name: 'version', value: "${appVersion}")], wait: true 
            }
        }
        
        }

    
    post { 
        always { 
            echo 'I will always say Hello again!'
            deleteDir()
        }
         failure { 
            echo 'Build is failed!'
        }
         success { 
            echo 'Build is success!'
        }
    }
}