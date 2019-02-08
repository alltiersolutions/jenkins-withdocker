FROM jenkins/jenkins:lts
MAINTAINER chris@alltiersolutions.com

USER root

# Set Drush version to install
ENV DRUSH_VERSION 8.1.18

RUN apt-get update && \
    apt-get -y install apt-transport-https \
      ca-certificates \
      curl \
      gnupg2 \
      mariadb-client \
      php-cli \
      software-properties-common \
&&  curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg > /tmp/dkey; apt-key add /tmp/dkey \
&&  add-apt-repository \
      "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
      $(lsb_release -cs) \
      stable" \
&&  apt-get update \
&&  apt-get -y install docker-ce \
&&  usermod -a -G docker jenkins \

# Install Drush version specified above
&& curl -fsSL -o /usr/local/bin/drush "https://github.com/drush-ops/drush/releases/download/$DRUSH_VERSION/drush.phar" \
&& chmod +x /usr/local/bin/drush

USER jenkins
