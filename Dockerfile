FROM tutum/lamp:latest
MAINTAINER Ishan Girdhar <ishan@ishangirdhar.com>

ENV DEBIAN_FRONTEND noninteractive

RUN rm -fr /app/* && \
apt-get update && apt-get install -yqq wget unzip php5-curl && \
rm -rf /var/lib/apt/lists/*

RUN \
  wget -O /bricks.zip http://sourceforge.net/projects/owaspbricks/files/Tuivai%20-%202.2/OWASP%20Bricks%20-%20Tuivai.zip && \
  unzip /bricks.zip && \
  rm -rf /app/* && \
  mkdir -p /app/bricks /app/dvwa && \
  cp -r /bricks/* /app/bricks  && \
  rm -rf /bricks  && \
  find /app/bricks -name "*.php" | xargs -n1 sed -i "s/\r/\n/g" && \
  sed -i "s/^\$dbuser.*/\$dbuser = 'root';/" /app/bricks/LocalSettings.php && \
  sed -i "s/^\$dbpass.*/\$dbpass = '';/g" /app/bricks/LocalSettings.php && \
  sed -i 's/.*error_reporting.*/error_reporting(E_ALL ^ E_DEPRECATED);/' /app/bricks/config/setup.php && \
  sed -i 's/.*error_reporting.*/error_reporting(E_ALL ^ E_DEPRECATED);/' /app/bricks/includes/PHPReverseProxy.php && \
  sed -i 's/.*error_reporting.*/error_reporting(E_ALL ^ E_DEPRECATED);/' /app/bricks/includes/MySQLHandler.php && \
  echo 'session.save_path = "/tmp"' >> /etc/php5/apache2/php.ini && \

  wget -O /dvwa.zip https://github.com/RandomStorm/DVWA/archive/v1.9.zip  && \
  unzip /dvwa.zip && \
  cp -r /DVWA-1.9/* /app/dvwa && \
  rm -rf /DVWA-1.9 && \
  sed -i "s/^\$_DVWA\[ 'db_user' \]     = 'root'/\$_DVWA[ 'db_user' ]     = 'admin'/g" /app/dvwa/config/config.inc.php && \
  echo "sed -i \"s/p@ssw0rd/\$PASS/g\" /app/dvwa/config/config.inc.php" >> /create_mysql_admin_user.sh  && \
  echo 'session.save_path = "/tmp"' >> /etc/php5/apache2/php.ini 

EXPOSE 80 3306
CMD ["/run.sh"]
