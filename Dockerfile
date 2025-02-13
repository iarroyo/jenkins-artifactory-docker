FROM jenkins/jenkins:2.426.3

# Switch to root to install JDK
USER root

# Install dependencies
RUN apt-get update && apt-get install -y wget && apt-get install -y java-common && apt-get install -y openssh-client


# Download and install Amazon Corretto 17
RUN wget -O corretto-17.deb https://corretto.aws/downloads/latest/amazon-corretto-17-aarch64-linux-jdk.deb && \
    dpkg -i corretto-17.deb && \
    rm corretto-17.deb

# Download and install Amazon Corretto 21
RUN wget -O corretto-21.deb https://corretto.aws/downloads/latest/amazon-corretto-21-aarch64-linux-jdk.deb && \
    dpkg -i corretto-21.deb && \
    rm corretto-21.deb

# Set Corretto 17 as the default JDK
ENV JAVA_HOME=/usr/lib/jvm/java-17-amazon-corretto
ENV JDK21_HOME=/usr/lib/jvm/java-21-amazon-corretto
ENV PATH="${JAVA_HOME}/bin:${PATH}"

# Verify installation
RUN java -version

# Add the SSH key and set correct permissions
RUN mkdir -p /var/jenkins_home/.ssh && \
	chmod 700 /var/jenkins_home/.ssh

# Add the private key (replace the path to your actual private key file)
COPY id_rsa /var/jenkins_home/.ssh/id_rsa
RUN chmod 600 /var/jenkins_home/.ssh/id_rsa

# Add known hosts to avoid SSH asking for confirmation
RUN ssh-keyscan github.com >> /var/jenkins_home/.ssh/known_hosts

# Set the correct permissions
RUN chown -R jenkins:jenkins /var/jenkins_home/.ssh

# Switch back to Jenkins user
USER jenkins
