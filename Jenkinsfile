#!/usr/bin/env groovy

node {
    // there is a place in jenkins to specify the branch to checkout.
    checkout scm // nothing more required as it is just files

    // Define git short commit to be used in Docker image tag.
    env.GIT_SHORT_COMMIT = sh(returnStdout: true, script: "git log -n 1 --pretty=format:'%h'").trim()

    stage('Build alltiersolutions/jenkins-withdocker Image and Push') {
        
        docker.withRegistry('https://registry.hub.docker.com', 'docker_registry') {
          def image = docker.build("alltiersolutions/jenkins-withdocker:${env.GIT_SHORT_COMMIT}", '--no-cache --pull ./')
          image.push()
          //image.push('latest')
        }

    }

    stage('Cleanup Docker') {
      sh 'docker system prune -f'
    }

}
