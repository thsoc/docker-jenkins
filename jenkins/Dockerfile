# 1. 基于官方 Jenkins LTS 镜像
FROM jenkins/jenkins:lts

# 2. 切换到 root 用户，以便安装软件和修改系统文件
USER root

# 3. 安装 curl 工具，用于下载文件
RUN apt-get update && apt-get install -y curl

# 4. 下载并安装 Docker CLI 客户端
#    - 下载 Docker 24.0.9 版本的压缩包
#    - 解压后，将其中的 'docker' 二进制文件移动到系统的 PATH 路径下
#    - 清理下载的压缩包和解压出的文件夹，减小镜像体积
RUN curl -fsSL https://download.docker.com/linux/static/stable/x86_64/docker-24.0.9.tgz -o docker.tgz && \
    tar -xvzf docker.tgz && \
    mv docker/docker /usr/local/bin/ && \
    rm -rf docker docker.tgz

# 5. 安装 Docker Compose 插件
#    - 创建 Docker CLI 插件的标准目录
RUN mkdir -p /usr/lib/docker/cli-plugins
#    - 下载 docker-compose 插件到该目录，并命名为 'docker-compose'
#    - 为插件文件添加可执行权限
RUN curl -SL https://github.com/docker/compose/releases/download/v2.27.1/docker-compose-linux-x86_64 -o /usr/lib/docker/cli-plugins/docker-compose && \
    chmod +x /usr/lib/docker/cli-plugins/docker-compose

# 6. 切换回 jenkins 用户，遵循官方镜像的最佳安全实践
USER jenkins