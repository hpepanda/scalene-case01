
#!/bin/bash
echo "Enter App Instance Name"
read APPINSTNAME
echo "Enter DB Instance Name"
read DBINSTNAME
echo "Starting App Instance"
/bin/bash ./start-instance.sh $APPINSTNAME
echo "Starting DB Instance"
/bin/bash ./start-instance.sh $DBINSTNAME

rm ip-$APPINSTNAME.tmp
mv ip-$DBINSTNAME.tmp ./templates/ip.data
