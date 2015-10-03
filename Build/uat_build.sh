#/usr/bin/bash


DATE=`date +%d_%m_%Y`
TIME=`date +%H_%M_%S`

MODULE_NAME=$1
TASK_ID=$2

WS_DIR="/c/Workspaces/UATSub1/$MODULE_NAME"
UAT_DIR="/c/UAT_Deployments"
DEST_DIR=$UAT_DIR/$DATE/$MODULE_NAME\_$TASK_ID

if [[ -z "$1" ]]; then
	echo
	echo "ERROR: No MODULE_NAME"
	exit 1
fi

if [[ -z "$2" ]]; then
	echo
	echo "ERROR: No TASK ID"
	exit 1
fi

if [[ -z "$3" ]]; then
	echo
	echo "Enter Details:"
	ref_details=$(</dev/stdin)
	echo $ref_details > $WS_DIR/reference.txt
else
	echo
	echo "reference.txt Up to date..."
fi


echo
echo "MODULE_NAME: $MODULE_NAME"
echo "WS_DIR: $WS_DIR"
echo "DEST_DIR: $DEST_DIR"

echo
echo "Building..."
cd $WS_DIR
pwd
read cont
ant
echo

echo "Copying..."
if [ ! -d $DEST_DIR ]; then
	mkdir $DEST_DIR
fi

if [ -f $DEST_DIR/$MODULE_NAME.war ]; then
	mv -v $DEST_DIR/$MODULE_NAME.war $DEST_DIR/$MODULE_NAME--$DATE--$TIME
fi

cp -vf $MODULE_NAME.war $DEST_DIR 
