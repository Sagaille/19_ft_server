
sed -i "s/autoindex off;/autoindex on;/g" /etc/nginx/sites-available/default
service nginx restart
echo "autoindex is on"