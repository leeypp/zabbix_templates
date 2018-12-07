存在问题：zabbix可以自动添加Linux服务器本地磁盘监控。而无法添加对云数据磁盘的监控（即无法发现左侧图片中的/data磁盘）。

具体如下图：

![image.png](https://upload-images.jianshu.io/upload_images/927710-fbd67d8bad271358.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

观察发现可以自动发现的挂载磁盘的文件格式为Linux系统默认的ext；

而云磁盘为以nfs协议挂载的数据磁盘，所以无法被zabbix策略自动发现添加

### 解决方法

修改zabbi的正则表达式

Administration--General--Regular expressions--File systems for discovery
1	»	^(btrfs|ext2|ext3|ext4|jfs|reiser|xfs|ffs|ufs|jfs|jfs2|vxfs|hfs|refs|ntfs|fat32|zfs|nfs|efs|cifs)$	[Result is TRUE]

在后面的正则中添加nfs字段即可！
--leeypp@foxmail.com