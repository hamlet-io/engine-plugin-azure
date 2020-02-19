#!groovy

pipeline {
    options {
        timestamps()
    }

    agent none

    environment {
        GENERATION_PLUGIN_DIRS = "${WORKSPACE}"
    }

    stages {

        stage('Trigger Docker Build') {
            when {
                branch 'master'
            }

            agent none

            steps {
                build (
                    job: '../docker-image-build/master'
                )
            }
        }
    }
}
