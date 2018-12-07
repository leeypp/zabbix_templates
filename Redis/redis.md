技术难点：redis服务为云服务器，无法安装zabbix agent，只能通过代理的方式，连接到redis服务，获取监控数据。

实现过程：

## 1.找一台可以连接redis服务的，有zabbix agent的服务器。（可以通过提供的用户名密码连接到redis服务）。

## 2.修改zabbix agent的配置文件如下：

```
[root@s-zabbix /etc/zabbix/zabbix_agentd.d]# cat userparameter_redis.conf
#redis monitor
UserParameter=redis_info[*],/etc/zabbix/scripts/redis_check.sh $1 $2 $3 $4
```    

配置中的参数均为前端需要传入的参数项

## 3.编辑采集脚本

## 4.配置template

导入模板文件

导入完成后模板名为--Template redis

## 5.前端添加主机

绑定方才导入的模板

![image.png](https://github.com/leeypp/zabbix_templates/blob/master/img/redis_add_template.png)

编辑宏参数

![](https://github.com/leeypp/zabbix_templates/blob/master/img/redis_edit_template.png)

## 6.查看数据

到monitoring-lastest data查看监控项是否有上报

## 说明：

1，这个模板redis监控的参数比较多，具体根据自己的实际情况启用redis里边的应用集或者监控项，也可以自己再添加,。

2，默认aof未开启 以及slave这里都有监控，用不到的就停掉，这个模板。当前模板四个触发器，其中关于aof和主从的关了，只保留了redis存活状态和redis磁盘回写失败与否两个触发器。

## 写在最后：

如果有问题请联系我leeypp@foxmail.com