#!/bin/bash
#common
sudo yum upgrade -y
sudo yum update -y
sudo yum install nc -y
sudo yum install zip -y
sudo yum install epel-release -y
sudo yum install ansible -y
sudo yum install jq -y



#Build essentials
sudo yum groupinstall "Development Tools" -y

# python3
mkdir /tmp/python
pushd /tmp/python
#sudo yum remove uuid-devel
sudo yum install gcc openssl-devel bzip2-devel libffi-devel zlib-devel sqlite-devel xz-devel ncurses-devel tk-devel readline-devel libuuid-devel -y
wget https://www.python.org/ftp/python/3.9.5/Python-3.9.5.tgz
tar xzvf Python-3.9.5.tgz
cd Python-3.9.5
./configure
make
sudo make install
popd
sudo rm -rf /tmp/python

#jenkins agent preparation
sudo adduser -c "" jenkins
echo "jenkins  ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/jenkins
#echo 'jenkins ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
sudo -H -u jenkins bash -c 'mkdir  /home/jenkins/workspace'

#groovy
sudo curl -s get.sdkman.io | bash
sudo source "$HOME/.sdkman/bin/sdkman-init.sh"
sudo sdk install groovy



# gcloud
pushd ~/
wget https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-sdk-343.0.0-linux-x86_64.tar.gz
tar xzvf google-cloud-sdk-343.0.0-linux-x86_64.tar.gz
sudo -H -u jenkins bash -c './google-cloud-sdk/install.sh --path-update=true --quiet'
sudo ./google-cloud-sdk/install.sh --path-update=true --quiet
rm google-cloud-sdk-343.0.0-linux-x86_64.tar.gz
source ~/.bashrc
sudo gcloud config set auth/disable_ssl_validation True
sudo gcloud components insatll pkg kubectl-oidc kubectl kpt anthos-auth config-connector --quiet
#gcloud --version
popd
# anthos-gke
# we need to place it to nexus for downloading with no gcloud auth, otherwise source is:
# gsutil cp gs://gke-multi-cloud-release/aws/aws-1.7.1-gke.1/bin/linux/amd64/anthos-gke .
pushd /tmp
wget https://nexus.lseg.stockex.local/repository/nrpd-ssp-sync-raw-releases/3rd/gcloud/anthos/aws-1.7.1-gke.1/anthos-gke
chmod +x anthos-gke
sudo mv anthos-gke /usr/bin/
popd

#java
sudo yum install java-11-openjdk-devel -y
sudo sh -c "echo 'export PATH=\$PATH:/usr/lib/jvm/java-11-openjdk-11.0.11.0.9-2.el8_4.x86_64/bin/java' >> /etc/profile.d/variables.sh"
sudo sh -c "echo 'export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-11.0.11.0.9-2.el8_4.x86_64/bin/java' >> /etc/profile.d/variables.sh"
#maven
wget https://www-us.apache.org/dist/maven/maven-3/3.6.3/binaries/apache-maven-3.6.3-bin.tar.gz
sudo tar xf apache-maven-3.6.3-bin.tar.gz -C /opt
sudo ln -s /opt/apache-maven-3.6.3 /opt/maven
sudo sh -c "echo 'export M2_HOME=/opt/maven' >> /etc/profile.d/variables.sh"
sudo sh -c "echo 'export MAVEN_HOME=/opt/maven' >> /etc/profile.d/variables.sh"
sudo sh -c "echo 'export PATH=\${M2_HOME}/bin:\${PATH}' >> /etc/profile.d/variables.sh"
source /etc/profile.d/variables.sh

#awscli2
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

#terraform
wget https://releases.hashicorp.com/terraform/0.15.5/terraform_0.15.5_linux_amd64.zip
sudo mv terraform_0.15.5_linux_amd64.zip /usr/local/bin/terraform

#terragrunt
wget https://github.com/gruntwork-io/terragrunt/releases/download/v0.29.8/terragrunt_linux_amd64
chmod u+x terragrunt_linux_amd64
sudo mv terragrunt_linux_amd64 /usr/local/bin/terragrunt



#docker
sudo yum-config-manager     --add-repo     https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install docker-ce docker-ce-cli containerd.io -y
sudo systemctl enable docker
sudo usermod -aG docker ec2-user
sudo usermod -aG docker jenkins
#Poetry
sudo -H -u jenkins bash -c 'curl -sSL https://raw.githubusercontent.com/python-poetry/poetry/master/get-poetry.py | python3 -'


curl "https://get.helm.sh/helm-v3.6.0-linux-amd64.tar.gz" -o "helm.tar.gz"
tar xzvf helm.tar.gz
mv linux-amd64/helm /usr/local/bin/helm

#certs
#keytool -importcert -file 123.cer -keystore keystore.jks -alias "alias1" -storepass changeit -keypass changeit -noprompt
keytool -noprompt -importcert -alias allInOne -file name.cer -keystore cacerts -storepass changeit
