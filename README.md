# Skrip mager_lamp.sh
Hanya skrip sederhana untuk instalasi LAMP stack di Manjaro Linux. Saat ini skrip ini menginstalasi paket-paket berikut:
- apache
- mariadb
- mariadb-clients
- mariadb-libs
- php
- php-apache

## Peringatan!
Skrip ini belum ada validasi apapun, hanya step-by-step instalasi. Jadi pastikan Manjaro dalam kondisi bersih dari paket-paket di atas, atau file konfigurasi yang sudah ada akan ditimpa. Resiko ditanggung penumpang.

## Cara Menggunakan Skrip
```bash
git clone https://github.com/bringsrain/mager_lamp.git
cd mager_lamp
bash ./mager_lamp.sh
```
Ikuti step yang diminta skrip. Setelah eksekusi selesai, halaman testing bisa di akses melalui uri: http://localhost
