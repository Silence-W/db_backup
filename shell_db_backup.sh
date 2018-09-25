#!/bin/sh
# This is a database backup shell script.

# 每天晚上十点半启动备份
# 30 22 * * *   /usr/bin/sh /var/www/db_backup.sh

# 备份目录
backupDir=/home/user/db_bak
# mysqldump
mysqldump=/usr/bin/mysqldump
# ip
host=127.0.0.1
# user
username=root
password=root

# 今天日期
today=`date +%Y%m%d`
# 十天前的日期
dateTenDayAgo=`date -d -10day +%Y%m%d`
# 要备份的数据库数组
# databases=(database1,database2,...)
databases=(db_name)

# 判断备份文件夹是否存在，不存在则创建
if [ ! -d "$backupDir" ];then
    mkdir -p "$backupDir"
fi

# 备份数据库
# echo $databasesCount
for database in ${databases[@]}
    do
        echo 'start backup '$database
        $mysqldump -h$host -u$username -p$password $database | gzip > $backupDir/$database-$today.sql.gz
        echo 'backup sucessfully '$database' to'$backupDir/$database-$today.sql.gz
        if [ ! -f "$backupDir/$database-$dateTenDayAgo.sql.gz" ]; then
            echo 'Ten days ago the backup does not exist, no need to delete.'
        else
            rm -f $backupDir/$database-$dateTenDayAgo.sql.gz
            echo 'Delete the backup file ten days ago '$backupDir/$database-$dateTenDayAgo.sql.gz
        fi
    done
