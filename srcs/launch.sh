service nginx start
service php7.3-fpm start
service mysql restart
#last line is to create loop, same as wait infinty
tail -f /dev/null
