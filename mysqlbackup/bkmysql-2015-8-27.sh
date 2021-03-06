#!/bin/bash
#Auther:jimmy
#date:2015-6-16

path=/xxx

#vari
DATE_TIME=`date +%Y%m%d`
BACKUPFOLDER="database_backup"
DB_HOSTNAME="192.168.1.240"
DB_USERNAME="xxx"
DB_PASSWORD="xxxx"
DATABASES_NAME=(xxx xxx xxxx)

#backup function

function backup_mysql(){
	
	/usr/bin/mysqldump -u"$DB_USERNAME" -p"$DB_PASSWORD" -h "$DB_HOSTNAME" $1>$path/"$BACKUPFOLDER"_"$DATE_TIME"/"$1"_"$DATE_TIME".sql
}

function decide(){

	if [ $1 = 0 ] ;then
		echo "$path/$BACKUPFOLDER'_'$DATE_TIME/$2'_'$DATE_TIME.sql mysqldump ok!" | mail -s "$2 Aliyun DB BK OK! $DATE_TIME" ljm@goujiawang.com
	else
		echo "$path/$BACKUPFOLDER'_'$DATE_TIME/$2'_'$DATE_TIME.sql mysqldump failed" | mail -s "$2 Aliyun DB BK Faild! $DATE_TIME" ljm@goujiawang.com
	fi
}

mkdir $path/"$BACKUPFOLDER"_"$DATE_TIME"

for i in ${DATABASES_NAME[*]}
do
	backup_mysql $i
	decide $? $i
done

cd $path
tar -zcvf "$BACKUPFOLDER"_"$DATE_TIME".tgz "$BACKUPFOLDER"_"$DATE_TIME"
rm -rf $path/"$BACKUPFOLDER"_"$DATE_TIME"

find $path -type f -mtime +5|xargs rm -rf
