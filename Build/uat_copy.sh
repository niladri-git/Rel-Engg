UATSub1="\/c\/Workspaces\/UATSub1"
UATSub3="\/c\/Workspaces\/UATSub3"

BAK_Sub1_files=UATSub1_backup_files
BAK_Sub3_files=UATSub3_backup_files

MODULE=$1

if [ ! $MODULE ]; then
	echo "Specify MODULE"
	exit 1
fi

if [ -d $BAK_Sub1_files ]; then
	echo "$BAK_Sub1_files exists."
	exit 1
fi

if [ -d $BAK_Sub3_files ]; then
	echo "$BAK_Sub3_files exists."
	exit 1
fi

echo
echo "=================================="
date
echo "=================================="
echo

mkdir $BAK_Sub1_files $BAK_Sub3_files

echo
echo "Backing Up WARs ..."
echo

UATSub1_war="/c/Workspaces/UATSub1/$MODULE/$MODULE.war"
cp -v $UATSub1_war $BAK_Sub1_files

UATSub3_war="/c/Workspaces/UATSub3/$MODULE/$MODULE.war"
cp -v $UATSub3_war $BAK_Sub3_files

echo
echo
echo "BackUp and Copy files ..."
echo
echo

for i in `cat readme.txt | grep $MODULE`
do

	echo "FILE $n => $i"
	echo
	
	Sub1_file=`echo $i | sed "s/^/$UATSub1/"`
	Sub1_new_file=`echo $i | sed "s/.*\///"`
	cp -v $Sub1_file $BAK_Sub1_files
	cp -v $Sub1_new_file $Sub1_file
	echo
	
	Sub3_file=`echo $i | sed "s/^/$UATSub3/"`
	Sub3_new_file=`echo $i | sed "s/.*\///"`
	cp -v $Sub3_file $BAK_Sub3_files
	cp -v $Sub3_new_file $Sub3_file
	echo

done