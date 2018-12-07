技术难点：mysql服务为云服务器，无法安装zabbix agent，只能通过代理的方式，连接到mysql服务，获取监控数据。

实现过程：

## 1.zabbix agent服务器

找一台可以连接mysql服务的，有zabbix agent的服务器。（可以通过提供的用户名密码连接到mysql服务）。

## 2.修改zabbix agent的配置文件如下：

```
[root@s-zabbix /etc/zabbix/zabbix_agentd.d]# cat userparameter_mysql.conf  |grep -Ev '#|$^'
UserParameter=mysql.status[*],/etc/zabbix/scripts/mysql_check.sh $1  $2  $3  $4 $5
```    

我的配置只有这一行，其中5个参数均为zabbix前端需要配置后传入的项。

## 3.编辑采集脚本

## 4.配置template

导入模板文件

导入成功后可以发现模板`Template Linux mysql status`

## 5.前端页面配置

（1）添加主机

![image.png](https://upload-images.jianshu.io/upload_images/927710-407241bed915bfc8.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

（2）绑定模板

![image.png](https://upload-images.jianshu.io/upload_images/927710-5dab95995bf63d46.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

（3）编辑宏，写入脚本所需要的变量

![image.png](https://upload-images.jianshu.io/upload_images/927710-af2eab90537b34cc.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

## 6数据检验查看

添加完成后在`最新数据`中查看方才添加主机的监控项，是否有数据上报

![image.png](https://upload-images.jianshu.io/upload_images/927710-ced61a91d6fedd3c.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

## 7.`实现原理`

以键值为`mysql.status[Ping,{$DBUSER},{$DBPASS},{$DBHOST},{$DBPORT}]`的监控项为例

从编辑采集脚本的时候可以发现，mysql_check.sh脚本需要5个参数来进行数据采集

```
[root@s-zabbix /etc/zabbix/scripts]# ./mysql_check.sh 
Usage: ITMEname   dbuser  dbpass  dbhost dbport
```

而在此监控项中，5个参数分别为```Ping,{$DBUSER},{$DBPASS},{$DBHOST},{$DBPORT}```,其中ping为监控项名称，其余四个变量为在宏中定义的用于连接mysql服务的参数

## 8.遇到的问题

```
 21571:20181129:151330.452 error reason for "mysql-prod-statics:mysql.status[Threads,{$DBUSER},{$DBPASS},{$DBHOST},{$DBPORT}]" changed: Special characters "\, ', ", `, *, ?, [, ], {, }, ~, $, !, &, ;, (, ), <, >, |, #, @, 0x0a" are not allowed in the parameters.
```

传入参数中有特殊字符。解决方法：更新zabbix_agentd.conf，设置UnsafeUserParameters=1

【参考文档】：http://blog.51cto.com/hzcsky/1876697

【写在最后】：

leeypp@foxmail.com  (如果你有疑问，请联系我)