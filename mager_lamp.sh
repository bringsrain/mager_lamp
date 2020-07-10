#!/usr/bin/env bash
# Skrip instalasi LAMP di Manjaro Linux buat yang mager

# Instalasi paket-paket yang dibutuhkan
sudo pacman -S apache mariadb mariadb-clients mariadb-libs php php-apache --noconfirm

# Initialize direktori data untuk mariadb
sudo mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql

# Enable dan start service
sudo systemctl enable httpd.service --now
sudo systemctl enable mariadb.service --now

# konfigurasi mariadb secure install
sudo mysql_secure_installation

# Disable module mpm_event di apache, jika ingin menggunakan mod_php
sudo sed -i 's:^\(.*mpm_event_module*\):#\1:' /etc/httpd/conf/httpd.conf

# Buat direktori untuk konfigurasi mod_php
sudo mkdir -p /etc/httpd/conf/php7

# Buat konfigurasi mod_php di direktori /etc/httpd/conf/php7
cat << EOT | sudo tee /etc/httpd/conf/php7/php7_enable.conf &>/dev/null
# Load modul prefork
LoadModule mpm_prefork_module modules/mod_mpm_prefork.so

# Load mod_php dan tambahkan handler untuk php-script
LoadModule php7_module modules/libphp7.so
AddHandler php7-script .php

# Include-kan konfigurasi php7_module.conf
Include conf/extra/php7_module.conf
EOT

# Include-kan konfigurasi php7_enable ke httpd.conf
cat << EOT | sudo tee -a /etc/httpd/conf/httpd.conf &>/dev/null
# Enable mod_php (PHP7)
Include conf/php7/php7_enable.conf
EOT

# Enable ekstensi php-mysqli di php.ini
sudo sed -i 's:^;\(extension=mysqli\):\1:' /etc/php/php.ini

# Enable ekstensi php-pdo (untuk mysql) di php.ini
sudo sed -i 's:^;\(extension=pdo_mysql\):\1:' /etc/php/php.ini

# Restart service apache
sudo systemctl restart httpd.service

# Buat file contoh php untuk tes php-apache dan php-mysqli
read -s -p "Password user root mariadb: " mariadbpass

cat <<-EOT | sudo tee /srv/http/index.php &>/dev/null
<?php
echo 'Versi PHP: ' . phpversion(). "\n";
\$mysqli = new mysqli("localhost", "root", "$mariadbpass");
if (\$mysqli->ping()){
  echo "PHP sudah terhubung dengan server" . \$mysqli->server_info;
}else{
  echo "PHP tidak terhubung dengan mariadb, pastikan exstensi mysqli sudah diaktifkan";
}
\$mysqli->close();
EOT

# Infokan untuk uji coba
echo "Instalasi selesai"
echo "Halaman default sudah bisa diakses dari URI http://localhost di web browser"
