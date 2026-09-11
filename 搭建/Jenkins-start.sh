docker run -d \
  --name jenkins \
  -p 8080:8080 \
  -p 50000:50000 \
  --restart always \
  -v jenkins_home:/var/jenkins_home \
  -v /var/run/docker.sock:/var/run/docker.sock \  ###不安全，应该使用Kaniko / SSH 远程
  -v $(which docker):/usr/bin/docker \
  --user root \
  jenkins/jenkins:lts