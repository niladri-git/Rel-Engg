#! /bin/sh

DATE=`date +%d_%m_%Y`
TIME=`date +%H_%M_%S`

MODULE=$1
TASK_ID=$2

UAT_DIR="/c/UAT_Deployments"
DEST_DIR=$UAT_DIR/$DATE/$MODULE\_$TASK_ID/UATSub1

echo
echo "Verify"
echo =========
echo

echo $MODULE
echo

cd $TASK_ID
pwd
echo

echo >> $TASK_ID.sha
echo "SHA: WAR files" >> $TASK_ID.sha
echo ================= >> $TASK_ID.sha
echo >> $TASK_ID.sha

cat readme.txt | grep $MODULE 
echo


for i in `cat readme.txt | grep $MODULE`
do

	if [[ $i != *"WEB-INF"* ]]; then
		f=`echo $i | sed -r "s/.*$MODULE\///"`
		file=`jar -xvf $DEST_DIR/$MODULE.war $f | uniq | cut -d" " -f3`
	else
		f=`echo $i | sed 's/.*WEB-INF/WEB-INF/'`
		file=`jar -xvf $DEST_DIR/$MODULE.war $f | uniq | cut -d" " -f3`
	fi
	
	md5sum $file >> $TASK_ID.sha
	
done

echo 
echo 
echo ==================================================================== 
echo 

cat $TASK_ID.sha

echo