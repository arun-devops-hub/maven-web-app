FROM tomcat:9.0.70-jdk11

COPY target/01-maven-web-app.war /usr/local/tomcat/webapps/maven-web-app.war

EXPOSE 8080

CMD ["catalina.sh", "run"]
