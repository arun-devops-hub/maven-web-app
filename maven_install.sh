MAVEN_VERSION=3.9.8
wget https://archive.apache.org/dist/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.tar.gz
tar -xzf apache-maven-$MAVEN_VERSION-bin.tar.gz
sudo mv apache-maven-$MAVEN_VERSION /opt/
sudo ln -s /opt/apache-maven-$MAVEN_VERSION/bin/mvn /usr/bin/mvn
mvn --version
