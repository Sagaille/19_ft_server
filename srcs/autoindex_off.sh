
sed -i "s/autoindex on;/autoindex off;/g" /etc/nginx/sites-available/default
service nginx restart
echo "autoindex is off"