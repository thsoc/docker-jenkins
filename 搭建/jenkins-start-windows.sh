#docker stop jenkins
#docker rm jenkins
#
## 构建镜像
#cd D:\workspace\java\docker-jenkins\jenkins
#docker build -t my-jenkins .
#
#
#
#docker run -d `
#  --name jenkins `
#  -p 8080:8080 `
#  -p 50000:50000 `
#  -e JAVA_OPTS="-Dhudson.plugins.git.GitSCM.ALLOW_LOCAL_CHECKOUT=true" `
#  --restart always `
#  -v jenkins_home:/var/jenkins_home `
#  -v /var/run/docker.sock:/var/run/docker.sock `
#  -v D:\workspace\remote-repository:/remote-repository `
#  --user root `
#  my-jenkins:latest
#
### dind = Docker in Docker
#docker run -d `
#  --name jenkins `
#  -p 8080:8080 `
#  -p 50000:50000 `
#  -e JAVA_OPTS="-Dhudson.plugins.git.GitSCM.ALLOW_LOCAL_CHECKOUT=true" `
#  -v jenkins_home:/var/jenkins_home `
#  -v /var/run/docker.sock:/var/run/docker.sock `
#  -v D:\workspace\remote-repository:/remote-repository `
#  -u root `
#  --restart=always `
#  jenkins/jenkins:lts `
#  sh -c "apt-get update && apt-get install -y docker.io && /usr/local/bin/jenkins.sh"



docker run -d `
  --name jenkins `
  --add-host=host.docker.internal:host-gateway `
  -p 8080:8080 `
  -p 50000:50000 `
  -e JAVA_OPTS="-Dhudson.plugins.git.GitSCM.ALLOW_LOCAL_CHECKOUT=true" `
  --restart always `
  -v jenkins_home:/var/jenkins_home `
  -v /var/run/docker.sock:/var/run/docker.sock `
  -v D:\workspace\remote-repository:/remote-repository `
  --user root `
  jenkins/jenkins:lts


