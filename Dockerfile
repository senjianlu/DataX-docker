# 基础镜像系统版本为 CentOS:7
FROM centos:7

# 维护者信息
LABEL maintainer="Rabbir admin@cs.cheap"

# Docker 内用户切换到 root
USER root

# 设置时区为东八区
ENV TZ Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime > /etc/timezone

# 安装 Git 和 Wget
RUN yum -y install wget
RUN yum -y install git

# 切换到 /usr/local/ 目录下
WORKDIR /usr/local/
# 下载解压 JDK
RUN wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie"  http://download.oracle.com/otn-pub/java/jdk/8u131-b11/d54c1d3a095b4ff2b6607d096fa80163/jdk-8u131-linux-x64.tar.gz
RUN tar -zxvf jdk-8u131-linux-x64.tar.gz
RUN mv jdk1.8.0_131  jdk1.8
RUN rm -f jdk-8u131-linux-x64.tar.gz
# 下载解压 Maven
RUN wget https://dlcdn.apache.org/maven/maven-3/3.9.6/binaries/apache-maven-3.9.6-bin.tar.gz --no-check-certificate
RUN tar -zxvf apache-maven-3.9.6-bin.tar.gz
RUN mv apache-maven-3.9.6 maven
RUN rm -f apache-maven-3.9.6-bin.tar.gz

# 添加容器内的永久环境变量
RUN sed -i "2 a export JAVA_HOME=/usr/local/jdk1.8" /etc/profile
RUN sed -i "3 a export PATH=\$PATH:\$JAVA_HOME/bin" /etc/profile
RUN sed -i "4 a export CLASSPATH=.:\$JAVA_HOME/lib/dt.jar:\$JAVA_HOME/lib/tools.jar" /etc/profile
RUN sed -i "5 a export MAVEN_HOME=/usr/local/maven" /etc/profile
RUN sed -i "6 a export PATH=\$PATH:\$MAVEN_HOME/bin" /etc/profile
RUN source /etc/profile
RUN sed -i '1 a source /etc/profile' ~/.bashrc
RUN source ~/.bashrc

# 添加构建用的临时环境变量
ENV JAVA_HOME /usr/local/jdk1.8
ENV PATH $PATH:$JAVA_HOME/bin
ENV CLASSPATH .:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
ENV MAVEN_HOME /usr/local/maven
ENV PATH $PATH:$MAVEN_HOME/bin

# 克隆并编译 DataX 的源码
WORKDIR /usr/local/
RUN git clone https://github.com/alibaba/DataX.git
WORKDIR /usr/local/DataX/
RUN sed -i "s#<module>oscarwriter</module>#<!-- <module>oscarwriter</module> -->#" pom.xml
RUN mvn -U clean package assembly:assembly -Dmaven.test.skip=true

# 创建配置文件存放用文件夹
RUN mkdir /data
WORKDIR /data

# 启动命令
ENTRYPOINT ["/usr/bin/python", "/usr/local/DataX/target/datax/datax/bin/datax.py"]
CMD [""]