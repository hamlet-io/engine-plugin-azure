#!groovy
def slackChannel = '#devops-framework'

pipeline {
    options {
        timestamps()
        durabilityHint('PERFORMANCE_OPTIMIZED')
        timeout(time: 1, unit: 'HOURS')
    }

    agent {
        label 'hamlet-latest'
    }

    stages {

        /*
        stage('Run Azure Template Tests') {
            environment {
                GENERATION_PLUGIN_DIRS = "${WORKSPACE}"
            }
            steps {
                sh '''#!/usr/bin/env bash
                    ./test/run_azure_template_tests.sh
                '''
            }
        }
        */

        stage('Trigger Docker Build') {
            steps {
                build (
                    job: '../docker-hamlet/master',
                    wait: false
                )
            }
        }
    }

    post {
        failure {
            slackSend (
                message: "*Failure* | <${BUILD_URL}|${JOB_NAME}>",
                channel: "${slackChannel}",
                color: "#D20F2A"
            )
        }
    }
}
