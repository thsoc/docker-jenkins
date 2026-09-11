pipeline {                          // 声明这是一个声明式流水线，Jenkins 会按照固定语法结构来解析整个文件
    agent any                       // 指定流水线可以在任意一台可用的 Jenkins 节点上运行（不限制具体机器）
    // 名字要和安装maven填的 Name 一致
    tools {
            maven 'Maven-3.9'
    }
    environment {                   // 定义全局环境变量，所有阶段都可以使用
        COMPOSE_PROJECT_NAME = 'myapp'  // 设置 Docker Compose 项目名称为 myapp，所有容器、网络、卷都会以 myapp_ 为前缀
    }

    stages {                        // 开始定义流水线的各个阶段，按顺序依次执行
        stage('拉取代码') {          // 定义第一个阶段：拉取代码
            steps {                 // 定义该阶段要执行的具体步骤
                checkout scm        // 从 Jenkins 任务中配置的源码管理（SCM）自动拉取代码
                // 或者指定仓库：
                // git url: 'http://你的git地址/myapp.git',  // 直接指定 Git 仓库地址
                //     branch: 'main',                        // 指定要拉取的分支
                //     credentialsId: 'git-cred'              // 指定在 Jenkins 凭据管理中预配置的凭据 ID
            }
        }

        stage('后端 - 编译构建') {   // 定义阶段：后端 Java 项目编译打包
            steps {
//                 dir('backend') {    // 切换到项目根目录下的 backend 子目录
//                     sh 'mvn clean package -DskipTests'  // 执行 Maven 命令：clean 清除上次构建产物，package 编译并打包为 JAR/WAR，-DskipTests 跳过测试
//                 }
                sh 'mvn clean package -DskipTests'  // 执行 Maven 命令：clean 清除上次构建产物，package 编译并打包为 JAR/WAR，-DskipTests 跳过测试
            }
        }

        stage('后端 - 单元测试') {   // 定义阶段：运行后端单元测试
            steps {
//                 dir('backend') {    // 切换到 backend 目录
//                     sh 'mvn test'   // 执行 Maven 测试命令，运行所有单元测试；如果有测试失败，该阶段会标记为失败并中止流水线
//                 }
                sh 'mvn test'   // 执行 Maven 测试命令，运行所有单元测试；如果有测试失败，该阶段会标记为失败并中止流水线
            }
            post {                  // 定义该阶段结束后的后置操作
                always {            // 无论测试成功还是失败，都会执行以下操作
                    junit 'target/surefire-reports/*.xml'  // 收集 Maven Surefire 插件生成的 JUnit XML 测试报告，Jenkins 会在界面上展示测试结果统计
                }
            }
        }

        stage('构建 Docker 镜像') {  // 定义阶段：构建 Docker 镜像
            steps {
                sh 'docker compose build'  // 根据项目根目录下的 docker-compose.yml 文件，构建所有服务的 Docker 镜像
            }
        }

        stage('部署到测试环境') {     // 定义阶段：部署服务到测试环境
            steps {
                sh '''              # 使用三引号执行多行 Shell 脚本
                    docker compose down --remove-orphans || true  # 停止并删除旧容器，--remove-orphans 清理不再被 compose 文件引用的容器；|| true 确保即使没有运行中的容器也不会报错
                    docker compose up -d  # 以后台模式（-d）启动所有服务容器
                '''
            }
        }

        stage('健康检查') {          // 定义阶段：检查服务是否正常启动
            steps {
                sh '''              # 执行多行 Shell 脚本
                    echo "等待服务启动..."  # 打印提示信息
                    sleep 10               # 等待 10 秒，给容器足够的启动时间
                    # 获取宿主机 IP（Docker 网桥地址）
                    HOST_IP=$(ip route | grep default | awk '{print $3}')
                    echo "宿主机 IP: $HOST_IP"
                    # 使用宿主机 IP 进行健康检查后端是否启动成功
                    curl -f http://$HOST_IP:8083/actuator/health || exit 1  # 请求 Spring Boot 健康检查端点，-f 表示 HTTP 错误时返回非零退出码，|| exit 1 表示失败则中止
                    echo "服务启动正常"  # 检查通过后打印成功信息
                '''
            }
        }

    }

    post {                          // 定义整个流水线结束后的全局后置操作
        success {                   // 仅在流水线成功完成时执行
            echo '部署成功！后端: http://localhost:8081'  // 打印成功信息及访问地址
        }
        failure {                   // 仅在流水线失败时执行
            echo '构建或部署失败，请检查日志'  // 打印失败提示
        }
        always {                    // 无论成功还是失败都会执行
            sh 'docker system prune -f'  // 清理未使用的 Docker 资源（悬空镜像、停止的容器、未使用的网络），-f 跳过确认提示，防止磁盘被占满
        }
    }
}