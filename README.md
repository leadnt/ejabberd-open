# QTalk EJABBERD

QTalk是基于ejabberd，根据业务需要改造而来。修改和扩展了很多
ejaberd不支持的功能。

## 关键功能

-   分布式：去掉了依赖mnesia集群的代码，来支持更大的集群，以及防止由于网络分区导致的集群状态不一致。
-   消息处理：通过ejabberd和kafka相连接，实现了消息的路由和订阅发布，可以对消息添加更丰富的处理逻辑。
-   &#x2026;

## QTalk模块

### QTalk主要包含：

+ [ejabberd](https://github.com/qunarcorp/ejabberd-open)

IM核心组件，负责维持与客户端的长连接和消息路由

+ [or](https://github.com/qunarcorp/or_open)

IM负载均衡组件，负责验证客户端身份，以及转发http请求到对应的后台服务
+ [im_http_service](https://github.com/qunarcorp/im_http_service_open)

IM HTTP接口服务，负责IM相关数据的查询、设置以及历史消息同步

+ [qtalk_cowboy](https://github.com/qunarcorp/qtalk_cowboy_open)(后面所有的接口都会迁移到im_http_service，这个服务会废弃)

IM HTTP接口服务，负责IM相关数据的查询、设置以及历史消息同步，后面会全部迁移到im_http_service上

+ [qfproxy](https://github.com/qunarcorp/qfproxy_open)

IM文件服务，负责文件的上传和下载

+ redis

IM缓存服务

+ postgresql

IM数据库服务

### QTalk各个模块之间的关系

(image/arch.png)

## 安装

```
依赖包
# sudo yum -y update
# sudo yum -y groupinstall Base "Development Tools" "Perl Support"
# sudo yum -y install openssl openssl-devel unixODBC unixODBC-devel pkgconfig libSM libSM-devel libxslt ncurses-devel libyaml libyaml-devel expat expat-devel libxml2-devel libxml2 java-1.8.0-openjdk  java-1.8.0-openjdk-devel  pam-devel pcre-devel gd-devel bzip2-devel zlib-devel libicu-devel libwebp-devel gmp-devel curl-devel postgresql-devel libtidy libtidy-devel recode aspell libmcrypt  libmemcached gd

安装erlang
# wget http://erlang.org/download/otp_src_19.3.tar.gz
# tar -zxvf otp_src_19.3.tar.gz
# cd otp_src_19.3
# ./configure --prefix=/usr/local/erlang1903
# make
# sudo make install

cd ejabberd-open/
# ./configure --prefix=/home/q/ejabberd1609 --with-erlang=/usr/local/erlang1903 --enable-pgsql --enable-full-xml
# make
# sudo make install
# sudo cp ejabberd.yml.qunar /home/q/ejabberd1609/etc/ejabberd/ejabberd.yml
# sudo cp ejabberdctl.cfg.qunar /home/q/ejabberd1609/etc/ejabberd/ejabberdctl.cfg
# sudo vim /home/q/ejabberd1609/etc/ejabberd/ejabberd.tml
# sudo vim /home/q/ejabberd1609/etc/ejabberd/ejabberdctl.cfg
```

## 配置文件修改

参考文档[setting.md](doc/setting.md)

## 集群

-   在主节点执行以下命令

```
cd /home/q/ejabberd1609
sudo ./sbin/ejabberdctl start
```
-   在从节点执行以下命令

```
cd /home/q/ejabberd1609
sudo rm -rf var/lib/ejabberd/*
sudo ./sbin/ejabberdctl start
sudo ./sbin/ejabberdctl debug
> easy_cluster:join('ejabberd@%HOST%')
...
CTRL-C
sudo ./sbin/ejabberdctl start
sudo ./sbin/ejabberdctl debug
> nodes()
# 如果可以看到其它节点，就证明集群成功了
```

## 结构图

### 系统体系结构

![architecture](image/modules.png)

### 消息路由流程图

![route process](image/route.png)

## 开发指南

- [developer guide](https://docs.ejabberd.im/developer/guide/)
-

## 问题反馈

-   qchat@qunar.com（邮件）
