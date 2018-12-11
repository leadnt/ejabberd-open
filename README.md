# QTalk EJABBERD

QTalk是基于ejabberd，根据业务需要改造而来。修改和扩展了很多
ejaberd不支持的功能。

## 关键功能

-   分布式：去掉了依赖mnesia集群的代码，来支持更大的集群，以及防止由于网络分区导致的集群状态不一致。
-   消息处理：通过ejabberd和kafka相连接，实现了消息的路由和订阅发布，可以对消息添加更丰富的处理逻辑。
-   &#x2026;

## 安装

```
cd ejabberd-open/
./configure --prefix=/home/q/ejabberd1609 --with-erlang=/home/q/erlang1903 --enable-pgsql --enable-full-xml
make
sudo make install
sudo cp ejabberd.yml.qunar /home/q/ejabberd1609/etc/ejabberd/ejabberd.yml
sudo cp ejabberdctl.cfg.qunar /home/q/ejabberd1609/etc/ejabberd/ejabberdctl.cfg
sudo vim /home/q/ejabberd1609/etc/ejabberd/ejabberd.tml
sudo vim /home/q/ejabberd1609/etc/ejabberd/ejabberdctl.cfg
```

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
