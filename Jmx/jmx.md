##jmx的接入方式和配置方法

###server端操作

1.安装zabbix java gateway

2.更新zabbix java gateway;zabbix server服务配置文件，重启服务 

###agent端操作

1.修改java服务启动参数，添加如下参数：

```
-Dcom.sun.management.jmxremote 
-Dcom.sun.management.jmxremote.authenticate=false 
-Dcom.sun.management.jmxremote.ssl=false 
-Dcom.sun.management.jmxremote.port=11052 
-Dcom.sun.management.jmxremote.rmi.port=11052 
-Djava.rmi.server.hostname=$(ifconfig eth0|grep inet|awk '{print $2}')
```

-Djava.rmi.server.hostname参数为java服务所在服务器的ip（也就是zabbix agent的ip，而不是zabbix java gateway的ip），自行获取即可，此处的不一定都通用。
web页面设置开启jmx，关联模板，就会看到有java监控数据

【存在问题】
tomcat或者其他java服务在启动过程中会随机开启rmi端口，这样就不能通过iptables来进行策略管理，此时用-Dcom.sun.management.jmxremote.rmi.port=11052 参数指定具体端口即可，再添加具体端口的iptable策略。

###zabbix web页面操作

1.导入模板文件

2.添加\配置主机

JMX接口    ip:port

模板    链接jmx模板

###查看数据

刷新页面查看jmx标志是否变绿色。如果为红色排除具体问题

检测中--最新数据--键入主机名，查看是否有数据正常上报