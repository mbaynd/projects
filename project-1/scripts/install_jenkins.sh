#! /bin/bash

sudo apt update -y
sudo  apt-get upgrade -y
# Install Java SDK 11
sudo apt install -y openjdk-11-jdk

# Download and Install Jenkins
# wget -q -O - https://pkg.jenkins.io/debian-stable/jenkins.io.key | sudo apt-key add -
# sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'

curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key |  sudo tee  /usr/share/keyrings/jenkins-keyring.asc > /dev/null
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
sudo apt update
sudo apt -y install jenkins

# Start Jenkins
sudo systemctl start jenkins

# Enable Jenkins to run on Boot
sudo systemctl enable jenkins

sudo cp /var/lib/jenkins/secrets/initialAdminPassword /tmp/jenkins_initialAdminPassword
sudo chmod 0744 /tmp/jenkins_initialAdminPassword