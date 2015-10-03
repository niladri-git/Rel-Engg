#! /bin/sh

DATE=`date +%d_%m_%Y`
TIME=`date +%H_%M_%S`

MODULE=$1
TASK_ID=$2

UAT_DIR="/c/UAT_Deployments"
DEST_DIR=$UAT_DIR/$DATE/$MODULE\_$TASK_ID/UATSub3

WS_DIR="/c/Workspaces/UATSub3/$MODULE"
SHA=$TASK_ID.sha.3

if [ ! -d $WS_DIR ]; then
	echo "$MODULE does not exist on Sub3"
	exit 1
fi

cd $TASK_ID
echo
pwd
echo

echo >> $SHA
echo "SHA: WAR files" >> $SHA
echo ================= >> $SHA
echo >> $SHA

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
	
	md5sum $file >> $SHA
	
done
