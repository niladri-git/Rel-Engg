#! /bin/sh

DATE=`date +%d_%m_%Y`
TIME=`date +%H_%M_%S`

MODULE=$1
TASK_ID=$2

UATSub1="\/c\/Workspaces\/UATSub1"
BAK_Sub1_files=UATSub1_backup_files

UAT_DIR="/c/UAT_Deployments"
DEST_DIR=$UAT_DIR/$DATE/$MODULE\_$TASK_ID/UATSub1

WS_DIR="/c/Workspaces/UATSub1/$MODULE"
SHA=$TASK_ID.sha.1

if [ ! -d $WS_DIR ]; then
	echo "$MODULE does not exist on Sub1"
	exit 1
fi

if [ ! $MODULE ]; then
	echo "Specify MODULE"
	exit 1
fi

if [ ! $TASK_ID ]; then
	echo "Specify TASK_ID"
	exit 1
fi

if [ ! -d $WS_DIR ]; then
	echo "$MODULE does not exist in $UATSub1"
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

if [ -d $BAK_Sub1_files ]; then
	echo "$BAK_Sub1_files exists."
	echo "Remove $BAK_Sub1_files ?"
	read cont
	rm -rf $BAK_Sub1_files
fi

mkdir $BAK_Sub1_files 

echo
echo "BackUp WARs ..."
echo

UATSub1_war="/c/Workspaces/UATSub1/$MODULE/$MODULE.war"
cp -v $UATSub1_war $BAK_Sub1_files

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
	
	Sub1_file=`echo $i | sed "s/^/$UATSub1/"`
	Sub1_new_file=`echo $i | sed "s/.*\///"`
	cp -v $Sub1_file $BAK_Sub1_files
	cp -v $Sub1_new_file $Sub1_file
	echo
	md5sum $Sub1_new_file >> $SHA
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

