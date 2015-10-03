#! /bin/sh

SUB=`basename $0 | sed 's/\..*//'`

sh uat$SUB.sh $1 $2
sh verify$SUB.sh $1 $2
