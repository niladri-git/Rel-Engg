#! /bin/sh

DATE=`date +%d_%m_%Y`
TIME=`date +%H_%M_%S`

MODULE=$1
TASK_ID=$2

UATSub3="\/c\/Workspaces\/UATSub3"
BAK_Sub3_files=UATSub3_backup_files

UAT_DIR="/c/UAT_Deployments"
DEST_DIR=$UAT_DIR/$DATE/$MODULE\_$TASK_ID/UATSub3

WS_DIR="/c/Workspaces/UATSub3/$MODULE"
SHA=$TASK_ID.sha.3

if [ ! $MODULE ]; then
	echo "Specify MODULE"
	exit 1
fi

if [ ! $TASK_ID ]; then
	echo "Specify TASK_ID"
	exit 1
fi

if [ ! -d $WS_DIR ]; then
	echo "$MODULE does not exist on Sub3"
	exit 1
fi

echo
echo "=================================="
date
echo "=================================="
echo

cd $TASK_ID
pwd
echo
echo "BackUp AND Copy"
echo ==================
echo

if [ -d $BAK_Sub3_files ]; then
	echo "$BAK_Sub3_files exists."
	echo "Remove $BAK_Sub3_files ?"
	read cont
	rm -rf $BAK_Sub3_files
fi

mkdir $BAK_Sub3_files 

echo
echo "BackUp WARs ..."
echo

UATSub3_war="/c/Workspaces/UATSub3/$MODULE/$MODULE.war"
cp -v $UATSub3_war $BAK_Sub3_files

echo > $SHA
echo "SHA: New files" >> $SHA
echo ================= >> $SHA
echo >> $SHA

echo
echo
echo "BackUp and Copy files ..."
echo
echo

for i in `cat readme.txt | grep $MODULE`
do

	echo "FILE => $i"
	echo
	
	Sub3_file=`echo $i | sed "s/^/$UATSub3/"`
	Sub3_new_file=`echo $i | sed "s/.*\///"`
	cp -v $Sub3_file $BAK_Sub3_files
	cp -v $Sub3_new_file $Sub3_file
	echo
	md5sum $Sub3_new_file >> $SHA
	echo
	
done

echo
echo "Build AND Copy"
echo ==================
echo

echo $WS_DIR 
echo $DEST_DIR
echo

echo "Enter Details:"
ref_details=$(</dev/stdin)
echo $ref_details > $WS_DIR/reference.txt

cd $WS_DIR
pwd
read cont
ant
echo

echo "Copy Arrtifacts..."
if [ ! -d $DEST_DIR ]; then
	mkdir -p $DEST_DIR
fi

if [ -f $DEST_DIR/$MODULE.war ]; then
	mv -v $DEST_DIR/$MODULE.war $DEST_DIR/$MODULE--$DATE--$TIME
fi

cp -vf $MODULE.war $DEST_DIR 

