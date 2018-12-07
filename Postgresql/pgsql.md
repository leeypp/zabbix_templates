【参考文档】：Zabbix for PostgreSQL部署技术文档
http://www.postgres.cn/news/viewone/1/280#ch8

基本上所有的配置都是根据上述文档完成的，下面是几点遇到的问题。

pg_monz是一个基于zabbix的postgresql监控模板，支持对postgresql多种运行指标进行监控，如是否存活，性能，资源。监控的类型可以单机，流复制高可用，pgpool-II负载平衡。pg_monz可以获得postgresql服务长期运行状态数据，当Postgesql服务出现问题时，可以利用pg_monz来进行恢复。

业务需求：拉取pgsql（云服务）监控数据到zabbix

技术选型：通过某台服务器拉取pgsql监控数据，再通过zabbix agent将数据代理上传到zabbix server。

技术难点：pgsql为云服务，无法更新配置以配合调试

遇到问题：pgsql连接鉴权失败

众所周知，pgsql数据库连接方式密码要配置.pgpass，配置在用户的家目录下，那么该配置在哪个用户的家目录下呢？答案是应该部署在启动zabbix agent进程用户的家目录下。比如zabbix agent进程是通过用户zabbix启动的，那么.pgpass文件应当存储为/home/zabbix/.pgpass

启动报错：

    21573:20181127:160850.305 error reason for "pg-test-myserver:psql.active_connections[{$PGHOST},{$PGPORT},{$PGROLE},{$PGDATABASE}]" changed: Value "Password for user myuser:
    21573:20181127:160858.342 error reason for "pg-test-myserver:psql.idle_connections[{$PGHOST},{$PGPORT},{$PGROLE},{$PGDATABASE}]" changed: Value "Password for user myuser:
    21573:20181127:160858.342 error reason for "pg-test-myserver:psql.idle_tx_connections[{$PGHOST},{$PGPORT},{$PGROLE},{$PGDATABASE}]" changed: Value "Password for user myuser:
    21571:20181127:160859.335 error reason for "pg-test-myserver:psql.locks_waiting[{$PGHOST},{$PGPORT},{$PGROLE},{$PGDATABASE}]" changed: Value "Password for user myuser:
    21572:20181127:160903.351 error reason for "pg-test-myserver:psql.server_connections[{$PGHOST},{$PGPORT},{$PGROLE},{$PGDATABASE}]" changed: Value "Password for user myuser:
    21573:20181127:160904.359 error reason for "pg-test-myserver:psql.server_maxcon[{$PGHOST},{$PGPORT},{$PGROLE},{$PGDATABASE}]" changed: Value "Password for user myuser:
    21571:20181127:160905.360 error reason for "pg-test-myserver:psql.slow_dml_queries[{$PGHOST},{$PGPORT},{$PGROLE},{$PGDATABASE},{$PGSLOWQUERY_THRESHOLD}]" changed: Value "Password for user myuser:
    21572:20181127:160906.372 error reason for "pg-test-myserver:psql.slow_queries[{$PGHOST},{$PGPORT},{$PGROLE},{$PGDATABASE},{$PGSLOWQUERY_THRESHOLD}]" changed: Value "Password for user myuser:
    21572:20181127:164406.994 error reason for "pg-test-myserver:psql.slow_select_queries[{$PGHOST},{$PGPORT},{$PGROLE},{$PGDATABASE},{$PGSLOWQUERY_THRESHOLD}]" changed: Value "Password for user myuser:
    psql: fe_sendauth: no password supplied" of type "string" is not suitable for value type "Numeric (unsigned)"


问题解决之后会发现监控项入库成功，日志如下：

    21573:20181128:143326.135 item "pg-test-myserver:psql.active_connections[{$PGHOST},{$PGPORT},{$PGROLE},{$PGDATABASE}]" became supported
    21574:20181128:143334.174 item "pg-test-myserver:psql.idle_connections[{$PGHOST},{$PGPORT},{$PGROLE},{$PGDATABASE}]" became supported
    21573:20181128:143335.180 item "pg-test-myserver:psql.idle_tx_connections[{$PGHOST},{$PGPORT},{$PGROLE},{$PGDATABASE}]" became supported
    21572:20181128:143336.183 item "pg-test-myserver:psql.locks_waiting[{$PGHOST},{$PGPORT},{$PGROLE},{$PGDATABASE}]" became supported
    21573:20181128:143338.202 item "pg-test-myserver:psql.server_connections[{$PGHOST},{$PGPORT},{$PGROLE},{$PGDATABASE}]" became supported
    21571:20181128:143339.250 item "pg-test-myserver:psql.server_maxcon[{$PGHOST},{$PGPORT},{$PGROLE},{$PGDATABASE}]" became supported
    21572:20181128:143341.209 item "pg-test-myserver:psql.slow_dml_queries[{$PGHOST},{$PGPORT},{$PGROLE},{$PGDATABASE},{$PGSLOWQUERY_THRESHOLD}]" became supported
    21573:20181128:143342.221 item "pg-test-myserver:psql.slow_queries[{$PGHOST},{$PGPORT},{$PGROLE},{$PGDATABASE},{$PGSLOWQUERY_THRESHOLD}]" became supported
    21572:20181128:143343.223 item "pg-test-myserver:psql.slow_select_queries[{$PGHOST},{$PGPORT},{$PGROLE},{$PGDATABASE},{$PGSLOWQUERY_THRESHOLD}]" became supported
    21573:20181128:143826.513 item "pg-test-myserver:psql.buffers_alloc[{$PGHOST},{$PGPORT},{$PGROLE},{$PGDATABASE}]" became supported
    21571:20181128:143828.521 item "pg-test-myserver:psql.buffers_backend[{$PGHOST},{$PGPORT},{$PGROLE},{$PGDATABASE}]" became supported
    21572:20181128:143829.525 item "pg-test-myserver:psql.buffers_backend_fsync[{$PGHOST},{$PGPORT},{$PGROLE},{$PGDATABASE}]" became supported
    21574:20181128:143830.536 item "pg-test-myserver:psql.buffers_checkpoint[{$PGHOST},{$PGPORT},{$PGROLE},{$PGDATABASE}]" became supported
    21571:20181128:143831.544 item "pg-test-myserver:psql.buffers_clean[{$PGHOST},{$PGPORT},{$PGROLE},{$PGDATABASE}]" became supported
    21571:20181128:143831.544 item "pg-test-myserver:psql.checkpoints_req[{$PGHOST},{$PGPORT},{$PGROLE},{$PGDATABASE}]" became supported
    21573:20181128:143832.538 item "pg-test-myserver:psql.checkpoints_timed[{$PGHOST},{$PGPORT},{$PGROLE},{$PGDATABASE}]" became supported
    21571:20181128:143837.567 item "pg-test-myserver:psql.maxwritten_clean[{$PGHOST},{$PGPORT},{$PGROLE},{$PGDATABASE}]" became supported
    21571:20181128:143843.593 item "pg-test-myserver:psql.tx_committed[{$PGHOST},{$PGPORT},{$PGROLE},{$PGDATABASE}]" became supported
    21574:20181128:143845.599 item "pg-test-myserver:psql.tx_rolledback[{$PGHOST},{$PGPORT},{$PGROLE},{$PGDATABASE}]" became supported`


leeypp@foxmail.com (如果你有疑问，请联系我)