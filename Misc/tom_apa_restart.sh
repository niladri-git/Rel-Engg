kill -9 `pgrep java`
sleep 2
/usr/local/tomcat/bin/shutdown.sh
sleep 2
/bin/rm -rf /usr/local/tomcat/work/Catalina/localhost/*
/usr/local/apache2/bin/apachectl stop
sleep 2
chown -R root:tomcat /usr/local/tomcat/logs/*
chmod 660 /usr/local/tomcat/logs/*
chmod 664 /usr/local/tomcat/logs/catalina.out
su - tomcat -c "/usr/local/tomcat/bin/catalina.sh start"
echo "[GC ----------Restart Tomcat----------- ]" >> /usr/local/tomcat/logs/catalina.out
#/usr/local/tomcat/bin/catalina.sh start
sleep 6
/usr/local/apache2/bin/apachectl start
