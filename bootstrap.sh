#! /bin/bash

# ---------------------------------------------------
# ADDING THE JENKINS-TRAINING DIRECTORY
# ---------------------------------------------------
echo "EXECUTING STEP 1 --> /home/vagrant/jenkins-training DIRECTORY CREATION"
mkdir -p /home/vagrant/jenkins-training/maven
mkdir -p /home/vagrant/jenkins-training/tomcat
mkdir -p /home/vagrant/jenkins-training/jenkins
mkdir -p /home/vagrant/jenkins-training/spring-project

# ---------------------------------------------------
# ADDING OPEN JDK and SETTING UP PATH VARIABLE
# ---------------------------------------------------
echo "EXECUTING STEP 2 --> INSTALLING JDK 11"

# GIT INSTALLATION
apt-get update -y -qq && apt-get install -y -qq git unzip tree xvfb libfontconfig1 libxi6 libgconf-2-4 >/dev/null 2>&1
# DOWNLOADING THE OPEN JDK PACKAGE
wget https://download.java.net/openjdk/jdk11/ri/openjdk-11+28_linux-x64_bin.tar.gz -O /tmp/openjdk-11+28_linux-x64_bin.tar.gz >/dev/null 2>&1
# CREATING THE DIRECTORY TO STORE JDK
mkdir /usr/lib/jvm
# UNTAR IT
tar xfvz /tmp/openjdk-11+28_linux-x64_bin.tar.gz --directory /usr/lib/jvm >/dev/null 2>&1
# REMOVE THE TAR FILE
rm -f /tmp/openjdk-11+28_linux-x64_bin.tar.gz
# ADD THE PATH
export JAVA_HOME=/usr/lib/jvm/jdk-11

# ---------------------------------------------------
# ADDING MAVEN, TOMCAT, SONARQUBE and JENKINS
# ---------------------------------------------------
echo "EXECUTING STEP 3 --> INSTALLING MAVEN, TOMCAT AND SONARQUBE"

echo "INSTALLING MAVEN....."
# INSTALLING MAVEN
wget https://mirrors.estointernet.in/apache/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz -O /tmp/apache-maven-3.6.3-bin.tar.gz >/dev/null 2>&1
tar xfvz /tmp/apache-maven-3.6.3-bin.tar.gz --strip-components=1 --directory /home/vagrant/jenkins-training/maven >/dev/null 2>&1
rm -f /tmp/apache-maven-3.6.3-bin.tar.gz

# ADD THE PATH
export M2_HOME=/home/vagrant/jenkins-training/maven
echo "DONE....."

echo "ADDING TOMCAT....."
# ADDING TOMCAT
wget https://github.com/khozema-nullwala/just-enough-jenkins/raw/master/tomcat.tar.gz -O /tmp/tomcat.tar.gz >/dev/null 2>&1
tar xfvz /tmp/tomcat.tar.gz --strip-components=1 --directory /home/vagrant/jenkins-training/tomcat >/dev/null 2>&1
rm -f /tmp/tomcat.tar.gz
echo "DONE....."

echo "ADDING SONARQUBE....."
# ADDING SONARQUBE SERVER
wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-7.9.2.zip -O /tmp/sonarqube-7.9.2.zip >/dev/null 2>&1
unzip /tmp/sonarqube-7.9.2.zip -d /home/vagrant/jenkins-training >/dev/null 2>&1
mv /home/vagrant/jenkins-training/sonarqube-7.9.2 /home/vagrant/jenkins-training/sonar
rm -f /tmp/sonarqube-7.9.2.zip
echo "DONE....."

echo "ADDING JENKINS....."
# ADDING JENKINS SERVER
wget http://mirrors.jenkins.io/war-stable/latest/jenkins.war -O /tmp/jenkins.war >/dev/null 2>&1
mv /tmp/jenkins.war /home/vagrant/jenkins-training/jenkins.war

# ADD THE HOME DIRECTORY
cat >>/home/vagrant/.bashrc<<EOF
export JAVA_HOME=/usr/lib/jvm/jdk-11
export M2_HOME=/home/vagrant/jenkins-training/maven
export JENKINS_HOME=/home/vagrant/jenkins-training/jenkins
export PATH=$PATH:$JAVA_HOME/bin:$M2_HOME/bin
EOF
source /home/vagrant/.bashrc
echo "DONE....."

# CLONING THE REPOSITORY
echo "ADDING THE REPOSITORY"
git clone https://github.com/khozema-nullwala/spring-jenkins-project.git /home/vagrant/jenkins-training/spring-project >/dev/null 2>&1
# COPYING FILES FOR TOMCAT CONFIGURATION
cp /home/vagrant/jenkins-training/spring-project/misc/tomcat-users.xml /home/vagrant/jenkins-training/tomcat/conf/tomcat-users.xml
cp /home/vagrant/jenkins-training/spring-project/misc/context.xml /home/vagrant/jenkins-training/tomcat/conf/context.xml
echo "DONE......"

# INSTALLING GOOGLE CHROME
echo "INSTALLING GOOGLE CHROME"
curl -sS -o - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add >/dev/null 2>&1
echo "deb [arch=amd64]  http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list
apt-get -y -qq update && apt-get -y -qq install google-chrome-stable >/dev/null 2>&1
echo "DONE......"

# SETTING UP CHROMEDRIVER
echo "SETTING UP CHROMEDRIVER"
wget https://chromedriver.storage.googleapis.com/2.41/chromedriver_linux64.zip >/dev/null 2>&1
unzip chromedriver_linux64.zip >/dev/null 2>&1
mv chromedriver /usr/bin/chromedriver
chmod +x /usr/bin/chromedriver
chown vagrant:vagrant /usr/bin/chromedriver
rm -f chromedriver_linux64.zip
echo "DONE......"
 
# CHANGING THE OWNERSHIP OF JENKINS-TRAINING DIRECTORY
chown -R vagrant:vagrant /home/vagrant/jenkins-training
