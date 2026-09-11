docker stop jenkins
docker rm jenkins

# 构建镜像
cd D:\workspace\java\docker-jenkins\jenkins
docker build -t my-jenkins .



docker run -d `
  --name jenkins `
  -p 8080:8080 `
  -p 50000:50000 `
  -e JAVA_OPTS="-Dhudson.plugins.git.GitSCM.ALLOW_LOCAL_CHECKOUT=true" `
  --restart always `
  -v jenkins_home:/var/jenkins_home `
  -v /var/run/docker.sock:/var/run/docker.sock `
  -v D:\workspace\remote-repository:/remote-repository `
  --user root `
  my-jenkins:latest