mod=$1
task=$2

echo Mod: $mod
echo Task: $task
read cont

cd $task
pwd
read cont

sh ../uat_copy.sh $mod $task
sh ../uat_build.sh $mod $task