FROM jenkins/jenkins:lts
MAINTAINER chris@alltiersolutions.com
USER root
# Set Composer version to install
ENV COMPOSER_VERSION 1.9.1
# Set Drush version to install
#ENV DRUSH_VERSION 8.3.2
RUN set -eux; \
	apt-get update; \
  apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg2 \
    mariadb-client \
    php-cli \
    php-gd \
    php-mbstring \
    php-mysql \
    php-xml \
    rsync \
    software-properties-common \
		; \
	# Set up additional repos
	# For kubectl
	curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - ; \
	echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list ; \
  # For docker-ce
	curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg > /tmp/dkey; apt-key add /tmp/dkey; \
	add-apt-repository \
		"deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
		$(lsb_release -cs) \
		stable" \
	; \
	apt-get update; \
	apt-get install -y \
		docker-ce \
		kubectl \
	; \
	rm -rf /var/lib/apt/lists/*; \
	usermod -a -G docker jenkins; \
	# Install Drush version specified above
  #curl -fsSL -o /usr/local/bin/drush "https://github.com/drush-ops/drush/releases/download/$DRUSH_VERSION/drush.phar"; \
	#chmod +x /usr/local/bin/drush \
	# Install the composer version specified above
	curl -o /usr/local/bin/composer "https://getcomposer.org/download/$COMPOSER_VERSION/composer.phar" \
	chmod +x /usr/local/bin/composer
USER jenkins
