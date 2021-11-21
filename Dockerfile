# CMDS TO MAKE IT RUN

#sudo su // gives super powers
#docker build -t "docker_image" .
#service nginx stop // make sure nginx is stopped
#docker run -td -p 80:80 -p 443:443 "docker_image":latest
#docker exec -ti "container ID" /bin/bash // open terminal inside container (in this case debian)

FROM debian:buster

# Install all packages
RUN apt-get update && apt-get -y upgrade;

RUN apt-get install -y nginx;

RUN apt-get install -y php-fpm php-mysql php-json;

RUN apt-get install -y wget unzip php-mbstring php-zip php-gd;

RUN apt-get install -y php-dom php-simplexml php-ssh2 php-xml php-xmlreader php-curl \
php-exif php-ftp php-iconv php-imagick php-posix php-sockets php-tokenizer

RUN apt-get install -y mariadb-server mariadb-client;

# Creating dir where we cp our srcs
RUN mkdir /utils

RUN wget https://files.phpmyadmin.net/phpMyAdmin/4.9.5/phpMyAdmin-4.9.5-all-languages.zip

RUN wget https://wordpress.org/latest.zip

RUN unzip phpMyAdmin-4.9.5-all-languages.zip

RUN unzip latest.zip

RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
-subj "/C=GB/ST=London/L=London/O=Global Security/OU=IT Department/CN=example.com" \
-keyout /etc/ssl/private/nginx.key -out /etc/ssl/certs/nginx.crt

COPY /srcs/default /etc/nginx/sites-available/default

# Move so path is correctly indexed
RUN mv phpMyAdmin-4.9.5-all-languages/ /var/www/html/phpmyadmin

RUN mv wordpress /var/www/html/wordpress

RUN chown -R www-data:www-data /var/www/html/phpmyadmin

RUN chmod -R 755 /var/www/html/phpmyadmin

RUN chown -R www-data:www-data /var/www/html/wordpress

RUN chmod -R 755 /var/www/html/wordpress

COPY /srcs/config.inc.php /var/www/html/phpmyadmin/config.inc.php

# Removing and replacing old config files
RUN rm /var/www/html/phpmyadmin/config.sample.inc.php

COPY /srcs/wp-config.php /var/www/html/wordpress

RUN rm /var/www/html/wordpress/wp-config-sample.php

COPY /srcs/init.sql /utils

COPY /srcs/autoindex_off.sh /utils

COPY /srcs/autoindex_on.sh /utils

# Granting privileges and creating db
RUN service mysql start && mysql -u root -p && mysql < /utils/init.sql && mysql < /var/www/html/phpmyadmin/sql/create_tables.sql -u root --password=root

COPY /srcs/launch.sh /utils

COPY /srcs/info.php /var/www/html

# Open ports
EXPOSE 80 443

# Run the script launch.sh
CMD ["bash", "utils/launch.sh"]
