#!/bin/bash
mysql(){
  user=$2
  password=$3
  hostname=$4
  port=$5
  case $1 in
       Ping)
       /usr/bin/mysqladmin -u${user}  -p${password} -h${hostname} -P${port}  ping 2>/dev/null |grep alive|wc -l
       ;;
       Threads)
       /usr/bin/mysqladmin   -u${user}  -p${password} -h${hostname} -P${port}   status 2>/dev/null |cut -f3 -d":"|cut -f1 -d"Q"
       ;;
       Questions)
       /usr/bin/mysqladmin -u${user} -p${password} -h${hostname} -P${port}  status 2>/dev/null |cut -f4 -d":"|cut -f1 -d"S"
       ;;
       Slowqueries)
       /usr/bin/mysqladmin -u${user} -p${password} -h${hostname} -P${port}  status 2>/dev/null |cut -f5 -d":"|cut -f1 -d"O"
       ;;
       Qps)
       /usr/bin/mysqladmin -u${user} -p${password} -h${hostname} -P${port}  status 2>/dev/null |cut -f9 -d":"
       ;;
       Slave_IO_State)
       if [ "$(/usr/bin/mysql -u${user} -p${password} -h${hostname} -P${port}  -e "show slave status\G" 2>/dev/null | grep Slave_IO_Running|awk '{print $2}')" == "Yes" ];then echo 1; else echo 0;fi
       ;;
       Slave_SQL_State)
       if [ "$(/usr/bin/mysql -u${user} -p${password} -h${hostname} -P${port}  -e "show slave status\G" 2>/dev/null | grep Slave_SQL_Running|grep -v "waiting for"|awk '{print $2}')" == "Yes" ];then echo 1; else echo 0;fi
       ;;
       SQL_Remaining_Delay)
       if [ "$(/usr/bin/mysql -u${user} -p${password} -h${hostname} -P${port}  -e "show slave status\G" 2>/dev/null | grep SQL_Remaining_Delay|awk '{print $2}')" == "NULL" ];then echo 0; else echo "$(/usr/bin/mysql -u${user} -p${password} -h${hostname} -P${port}  -e "show slave status\G" 2>/dev/null | grep SQL_Remaining_Delay|awk '{print $2}')" ;fi
       ;;
       Key_buffer_size)
       /usr/bin/mysql -u${user} -p${password} -h${hostname} -P${port}  -e "show variables like 'key_buffer_size';" 2>/dev/null | grep -v Value |awk '{print $2/1024^2}'
       ;;
       Key_reads)
       /usr/bin/mysql -u${user} -p${password} -h${hostname} -P${port}  -e "show status like 'key_reads';" 2>/dev/null | grep -v Value |awk '{print $2}'
       ;;
       Key_read_requests)
       /usr/bin/mysql -u${user} -p${password} -h${hostname} -P${port}  -e "show status like 'key_read_requests';" 2>/dev/null | grep -v Value |awk '{print $2}'
       ;;
       Key_cache_miss_rate)
       echo $(/usr/bin/mysql -u${user} -p${password} -h${hostname} -P${port}  -e "show status like 'key_reads';" 2>/dev/null | grep -v Value|awk '{print $2}') $(/usr/bin/mysql -u${user} -p${password} -h${hostname} -P${port}  -e "show status like 'key_read_requests';" 2>/dev/null | grep -v Value |awk '{print $2}')| awk '{printf("%1.4f\n",$1/$2*100)}'
       ;;
       Key_blocks_used)
       /usr/bin/mysql -u${user} -p${password} -h${hostname} -P${port}   -e "show status like 'key_blocks_used';"  2>/dev/null |grep -v Value |awk '{print $2}'
       ;;
       Key_blocks_unused)
       /usr/bin/mysql -u${user} -p${password} -h${hostname} -P${port}   -e "show status like 'key_blocks_unused';" 2>/dev/null | grep -v Value |awk '{print $2}'
       ;;
       Key_blocks_used_rate)
       echo $(/usr/bin/mysql -u${user} -p${password} -h${hostname} -P${port}  -e "show status like 'key_blocks_used';" 2>/dev/null | grep -v
 Value |awk '{print $2}') $(/usr/bin/mysql -u${user} -p${password} -h${hostname} -P${port}  -e "show status like 'key_blocks_unused';" 2>/dev/null | grep -v Value |awk '{print $2}')| awk '{printf("%1.4f\n",$1/($1+$2)*100)}'
       ;;
       Innodb_buffer_pool_size)
       /usr/bin/mysql -u${user} -p${password} -h${hostname} -P${port}  -e "show variables like 'innodb_buffer_pool_size';" 2>/dev/null |grep -v Value |awk '{print $2/1024^2}'
       ;;
       Innodb_log_file_size)
       /usr/bin/mysql -u${user} -p${password} -h${hostname} -P${port}  -e "show variables like 'innodb_log_file_size';" 2>/dev/null |grep -v Value |awk '{print $2/1024^2}'
       ;;
       Innodb_log_buffer_size)
       /usr/bin/mysql -u${user} -p${password} -h${hostname} -P${port}  -e "show variables like 'innodb_log_buffer_size';" 2>/dev/null |grep -v Value |awk '{print $2/1024^2}'
       ;;
       Table_open_cache)
       /usr/bin/mysql -u${user} -p${password} -h${hostname} -P${port}  -e "show variables like 'table_open_cache';" 2>/dev/null |grep -v Value |awk '{print $2}'
       ;;
       Open_tables)
       /usr/bin/mysql -u${user} -p${password} -h${hostname} -P${port}  -e "show status like 'open_tables';" 2>/dev/null |grep -v Value |awk '{print $2}'
       ;;
       Opened_tables)
       /usr/bin/mysql -u${user} -p${password} -h${hostname} -P${port}  -e "show status like 'opened_tables';" 2>/dev/null |grep -v Value |awk '{print $2}'
       ;;
       Open_tables_rate)
       echo $(/usr/bin/mysql -u${user} -p${password} -h${hostname} -P${port}  -e "show status like 'open_tables';" 2>/dev/null | grep -v Value |awk '{print $2}') $(/usr/bin/mysql -u${user} -p${password} -h${hostname} -P${port}  -e "show status like 'opened_tables';" 2>/dev/null | grep -v Value |awk '{print $2}')| awk'{printf("%1.4f\n",$1/($1+$2)*100)}'
       ;;
       Table_open_cache_used_rate)
       echo $(/usr/bin/mysql -u${user} -p${password} -h${hostname} -P${port}  -e "show status like 'open_tables';" 2>/dev/null | grep -v Value |awk '{print $2}') $(/usr/bin/mysql -u${user} -p${password} -h${hostname} -P${port}  -e "show variables like 'table_open_cache';" 2>/dev/null | grep -v Value |awk '{print $2}')| awk '{printf("%1.4f\n",$1/($1+$2)*100)}'
       ;;
       Thread_cache_size)
       /usr/bin/mysql -u${user} -p${password} -h${hostname} -P${port}  -e "show variables like 'thread_cache_size';" 2>/dev/null |grep -v Value |awk '{print $2}'
       ;;
       Threads_cached)
       /usr/bin/mysql -u${user} -p${password} -h${hostname} -P${port}  -e "show status like 'Threads_cached';" 2>/dev/null |grep -v Value |awk '{print $2}'
       ;;
       Threads_connected)
       /usr/bin/mysql -u${user} -p${password} -h${hostname} -P${port}  -e "show status like 'Threads_connected';" 2>/dev/null |grep -v Value |awk '{print $2}'
       ;;
       Threads_created)
       /usr/bin/mysql -u${user} -p${password} -h${hostname} -P${port}  -e "show status like 'Threads_created';" 2>/dev/null |grep -v Value |awk '{print $2}'
       ;;
       Threads_running)
       /usr/bin/mysql -u${user} -p${password} -h${hostname} -P${port}  -e "show status like 'Threads_running';" 2>/dev/null |grep -v Value |awk '{print $2}'
       ;;
       Max_used_connections)
       /usr/bin/mysql -u${user} -p${password} -h${hostname} -P${port}  -e "show status like 'Max_used_connections';" 2>/dev/null |grep -v Value |awk '{print $2}'
       ;;
       Max_connections)
       /usr/bin/mysql -u${user} -p${password} -h${hostname} -P${port}  -e "show variables like 'Max_connections';" 2>/dev/null |grep -v Value |awk '{print $2}'
       ;;
       Max_connections_used_rate)
       echo $(/usr/bin/mysql -u${user} -p${password} -h${hostname} -P${port}  -e "show status like 'Max_used_connections';" 2>/dev/null | grep -v Value |awk '{print $2}') $(/usr/bin/mysql -u${user} -p${password} -h${hostname} -P${port}  -e "show variables like 'max_connections';" 2>/dev/null | grep -v Value |awk '{print $2}')| awk '{printf("%1.4f\n",$1/$2*100)}'
        ;;
       Created_tmp_disk_tables)
       /usr/bin/mysql -u${user} -p${password} -h${hostname} -P${port}  -e "show status like 'created_tmp_disk_tables';" 2>/dev/null |grep -v Value |awk '{print $2}'
       ;;
       Created_tmp_tables)
       /usr/bin/mysql -u${user} -p${password} -h${hostname} -P${port}  -e "show status like 'created_tmp_tables';" 2>/dev/null |grep -v Value |awk '{print $2}'
       ;;
       Table_locks_immediate)
       /usr/bin/mysql -u${user} -p${password} -h${hostname} -P${port}  -e "show status like 'table_locks_immediate';" 2>/dev/null |grep -v Value |awk '{print $2}'
       ;;
       Table_locks_waited)
       /usr/bin/mysql -u${user} -p${password} -h${hostname} -P${port}  -e "show status like 'table_locks_waited';" 2>/dev/null |grep -v Value |awk '{print $2}'
       ;;
       Open_files)
       /usr/bin/mysql -u${user} -p${password} -h${hostname} -P${port}  -e "show status like 'open_files';" 2>/dev/null |grep -v Value |awk '{print $2}'
       ;;
       Open_files_limit)
       /usr/bin/mysql -u${user} -p${password} -h${hostname} -P${port}  -e "show variables like 'open_files_limit';" 2>/dev/null |grep -v Value |awk '{print $2}'
       ;;
       Open_files_rate)
       echo $(/usr/bin/mysql -u${user} -p${password} -h${hostname} -P${port}  -e "show status like 'open_files';" 2>/dev/null | grep -v Value |awk '{print $2}') $(/usr/bin/mysql -u${user} -p${password} -h${hostname} -P${port}  -e "show variables like 'open_files_limit';" 2>/dev/null | grep -v Value |awk '{print $2}')| awk '{printf("%1.4f\n",$1/$2*100)}'
       ;;
       Com_select)
       /usr/bin/mysql -u${user} -p${password} -h${hostname} -P${port}  -e "show status like 'com_select';" 2>/dev/null |grep -v Value |awk '{print $2}'
       ;;
       Com_insert)
       /usr/bin/mysql -u${user} -p${password} -h${hostname} -P${port}  -e "show status like 'com_insert';" 2>/dev/null |grep -v Value |awk '{print $2}'
       ;;
       Com_insert_select)
       /usr/bin/mysql -u${user} -p${password} -h${hostname} -P${port}  -e "show status like 'com_insert_select';" 2>/dev/null |grep -v Value |awk '{print $2}'
       ;;
       Com_update)
       /usr/bin/mysql -u${user} -p${password} -h${hostname} -P${port}  -e "show status like 'com_update';" 2>/dev/null |grep -v Value |awk '{print $2}'
       ;;
       Com_replace)
       /usr/bin/mysql -u${user} -p${password} -h${hostname} -P${port}  -e "show status like 'com_replace';" 2>/dev/null |grep -v Value |awk '{print $2}'
       ;;
       Com_replace_select)
       /usr/bin/mysql -u${user} -p${password} -h${hostname} -P${port}  -e "show status like 'com_replace_select';" 2>/dev/null |grep -v Value |awk '{print $2}'
       ;;
       Table_scan_rate)
       echo $(/usr/bin/mysql -u${user} -p${password} -h${hostname} -P${port}  -e "show status like 'Handler_read_rnd_next';" 2>/dev/null | grep -v Value |awk '{print $2}') $(/usr/bin/mysql -u${user} -p${password} -h${hostname} -P${port}  -e "show status like 'com_select';" 2>/dev/null | grep -v Value |awk '{print $2}')| awk '{printf("%1.4f\n",$1/$2*100)}'
       ;;
       Handler_read_first)
       /usr/bin/mysql -u${user} -p${password} -h${hostname} -P${port}  -e "show status like 'Handler_read_first';" 2>/dev/null |grep -v Value |awk '{print $2}'
       ;;
       Handler_read_key)
       /usr/bin/mysql -u${user} -p${password} -h${hostname} -P${port}  -e "show status like 'Handler_read_key';" 2>/dev/null |grep -v Value |awk '{print $2}'
       ;;
       Handler_read_next)
       /usr/bin/mysql -u${user} -p${password} -h${hostname} -P${port}  -e "show status like 'Handler_read_next';" 2>/dev/null |grep -v Value |awk '{print $2}'
       ;;
       Handler_read_prev)
       /usr/bin/mysql -u${user} -p${password} -h${hostname} -P${port}  -e "show status like 'Handler_read_prev';" 2>/dev/null |grep -v Value |awk '{print $2}'
       ;;
       Handler_read_rnd)
       /usr/bin/mysql -u${user} -p${password} -h${hostname} -P${port}  -e "show status like 'Handler_read_rnd';" 2>/dev/null |grep -v Value |awk '{print $2}'
       ;;
       Handler_read_rnd_next)
       /usr/bin/mysql -u${user} -p${password} -h${hostname} -P${port}  -e "show status like 'Handler_read_rnd_next';" 2>/dev/null |grep -v Value |awk '{print $2}'
       ;;
       Sort_merge_passes)
       /usr/bin/mysql -u${user} -p${password} -h${hostname} -P${port}  -e "show status like 'Sort_merge_passes';" 2>/dev/null |grep -v Value |awk '{print $2}'
       ;;
       Sort_range)
       /usr/bin/mysql -u${user} -p${password} -h${hostname} -P${port}  -e "show status like 'Sort_range';" 2>/dev/null |grep -v Value |awk '{print $2}'
       ;;
       Sort_rows)
       /usr/bin/mysql -u${user} -p${password} -h${hostname} -P${port}  -e "show status like 'Sort_rows';" 2>/dev/null |grep -v Value |awk '{print $2}'
       ;;
       Sort_scan)
       /usr/bin/mysql -u${user} -p${password} -h${hostname} -P${port}  -e "show status like 'Sort_scan';" 2>/dev/null |grep -v Value |awk '{print $2}'
       ;;
       Qcache_free_blocks)
       /usr/bin/mysql -u${user} -p${password} -h${hostname} -P${port}  -e "show status like 'Qcache_free_blocks';" 2>/dev/null |grep -v Value |awk '{print $2}'
       ;;
       Qcache_free_memory)
       /usr/bin/mysql -u${user} -p${password} -h${hostname} -P${port}  -e "show status like 'Qcache_free_memory';" 2>/dev/null |grep -v Value |awk '{print $2}'
       ;;
       Qcache_free_blocks)
       /usr/bin/mysql -u${user} -p${password} -h${hostname} -P${port}  -e "show status like 'Qcache_free_blocks';" 2>/dev/null |grep -v Value |awk '{print $2}'
       ;;
       Qcache_hits)
       /usr/bin/mysql -u${user} -p${password} -h${hostname} -P${port}  -e "show status like 'Qcache_hits';" 2>/dev/null |grep -v Value |awk '{print $2}'
       ;;
       Qcache_inserts)
       /usr/bin/mysql -u${user} -p${password} -h${hostname} -P${port}  -e "show status like 'Qcache_inserts';" 2>/dev/null |grep -v Value |awk '{print $2}'
       ;;
       Qcache_lowmem_prunes)
       /usr/bin/mysql -u${user} -p${password} -h${hostname} -P${port}  -e "show status like 'Qcache_lowmem_prunes';" 2>/dev/null |grep -v Value |awk '{print $2}'
       ;;
       Qcache_not_cached)
       /usr/bin/mysql -u${user} -p${password} -h${hostname} -P${port}  -e "show status like 'Qcache_not_cached';" 2>/dev/null |grep -v Value |awk '{print $2}'
       ;;
       Qcache_queries_in_cache)
       /usr/bin/mysql -u${user} -p${password} -h${hostname} -P${port}  -e "show status like 'Qcache_queries_in_cache';" 2>/dev/null |grep -v Value |awk '{print $2}'
       ;;
       Qcache_total_blocks)
       /usr/bin/mysql -u${user} -p${password} -h${hostname} -P${port}  -e "show status like 'Qcache_total_blocks';" 2>/dev/null |grep -v Value |awk '{print $2}'
       ;;
       Query_cache_limit)
       /usr/bin/mysql -u${user} -p${password} -h${hostname} -P${port}  -e "show variables like 'query_cache_limit';" 2>/dev/null |grep -v Value |awk '{print $2}'
       ;;
       Query_cache_min_res_unit)
       /usr/bin/mysql -u${user} -p${password} -h${hostname} -P${port}  -e "show variables like 'query_cache_min_res_unit';" 2>/dev/null |grep -v Value |awk '{print $2}'
       ;;
       Query_cache_size)
       /usr/bin/mysql -u${user} -p${password} -h${hostname} -P${port}  -e "show variables like 'query_cache_size,';" 2>/dev/null |grep -v Value |awk '{print $2}'
       ;;
       *)
        echo $"Usage: ITMEname   dbuser  dbpass  dbhost dbport";
    esac
}
mysql  $1 $2 $3 $4 $5