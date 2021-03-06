# DataX-docker

## 项目介绍
基于官方 CentOS7 镜像的 DataX 容器构建脚本。

## 优势
+ 无论是 CentOS7 的镜像、JDK 压缩包还是 Maven 压缩包，均使用各自官方的下载源来确保容器安全稳定。  
+ DataX 是从[官方仓库](https://github.com/alibaba/DataX)直接克隆源码并在容器内进行编译的，这意味着：如果你想要实装最新的代码只需要重新构建一次容器即可。  
+ 完整的实践流程，Dockerfile 中的每一步操作几乎都有解释：[DataX 实践（一）构建 DataX 的 Docker 容器镜像并测试运行](https://senjianlu.com/2021/11/datax-note-01/)
+ 支持通过 GitHub Action 构建容器镜像并推送至你自己的 Docker Hub 仓库。  

## 注意
1. 如果你想通过 GitHub Action 来构建镜像，Fork 本仓库后请在 Settings → Secrets 处添加你 Docker Hub 的 $DOCKER_HUB_USERNAME 和 $DOCKER_HUB_ACCESS_TOKEN。  
2. 如果你不想把 datax 作为 GitHub Action 自动构建用的镜像名，那么你需要前往 .github/workflows/main.yaml 第[ 33 ](https://github.com/senjianlu/DataX-docker/blob/main/.github/workflows/main.yaml#L33)行做相应修改。

## 使用手册
**生成容器镜像：**  
*注：镜像名和版本请自行替换。*  
① 在本地构建镜像：
```bash
cd DataX-docker
docker build -t rabbir/datax:latest . --no-cache
```
② 通过 GitHub Action 构建完成后拉取镜像：
```bash
docker pull rabbir/datax:latest
```

**运行容器：**  
*注：用来存储配置文件和映射的宿主机文件夹路径请视自身情况进行修改。*  
容器内默认的配置文件存放目录为：/data　　

> 例：如果配置文件在宿主机内的完整路径为：/rab/docker/datax/data/test/stream2stream.json，那么通过映射它在容器内的路径则为：/data/test/stream2stream.json，此时你只需要传入 test/stream2stream.json 作为参数就可以了。 

```bash
docker run --name datax_test_container -v /rab/docker/datax/data:/data rabbir/datax:latest test/stream2stream.json
```

> 测试文件下载：
> ```bash
> wget https://raw.githubusercontent.com/senjianlu/DataX-docker/main/test/stream2stream.json -O /rab/docker/datax/data/test/stream2stream.json
> ```

## 特别鸣谢
- 感谢 [DigitalOcean](https://www.digitalocean.com/) 为本项目提供测试用服务器