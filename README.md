its okay.. my phone realme c15 low end


## 🐧 Gentoo Chroot in Termux (Rooted Only)

Tutorial ini buat lo yang gabut tapi pengen ngerasain penderitaan compile Gentoo di Android via Termux.

### 📋 Prasyarat
 * Perangkat Android sudah **Root**.
 * Aplikasi **Termux** terpasang.
 * Module **BusyBox** sudah aktif di Magisk/KernelSU.

### 🛠️ Langkah Pemasangan
 1. **Unduh Stage3 Tarball**
   Download file gentoo.tar.xz atau .gz terbaru dari mirror resmi Gentoo.

 2. **Pindahkan dan Ekstraksi File**
   Buka Termux, masuk sebagai root, lalu pindahkan file ke direktori /data/local/tmp untuk proses ekstraksi:
   ```bash
   su
   cd /sdcard/Download/
   mv gentoo.tar.xz /data/local/tmp/
   cd /data/local/tmp
   mkdir gentoo && mv gentoo.tar.xz gentoo/ && cd gentoo
   busybox tar -xvf gentoo.tar.xz --numeric-owner
   
   ```
   *(Tunggu sampai selesai, speed-nya tergantung emmc/ufs lo ya).*
 3. **Membuat Mounting Point & Konfigurasi Network**
   ```bash
   mkdir -p media/storage media/sdcard dev/shm dev/pts
   
   ```
   Bikin file DNS biar dapet koneksi internet di dalam chroot:
   ```bash
   echo -e "nameserver 8.8.8.8\nnameserver 1.1.1.1" > etc/resolv.conf
   
   ```
 4. **Setup Script Starter (gentoo.sh)**
   Keluar ke folder tmp, lalu bikin file starter script:
   ```bash
   cd /data/local/tmp
   vi gentoo.sh
   
   ```
   *(Isi dengan script mounting chroot Gentoo yang ada di repo).*
   Kasih izin eksekusi dan jalankan:
   ```bash
   chmod +x gentoo.sh
   ./gentoo.sh
   
   ```
 5. **Konfigurasi Hak Akses Android Group (PENTING!)**
   Setelah masuk ke lingkungan Gentoo, jalankan perintah ini supaya user dan Portage dapet akses internet serta storage di Android:
   ```bash
   groupadd -g 3003 aid_inet
   groupadd -g 3004 aid_net_raw
   groupadd -g 1003 aid_graphics
   usermod -G 3003 -a root
   
   groupadd storage
   groupadd wheel
   useradd -m -g users -G wheel,audio,video,storage,aid_inet -s /bin/bash root
   
   usermod -g aid_net portage
   
   ```
   Kalau udah, ketik exit lalu masuk lagi lewat ./gentoo.sh. *Voila!* Selesai.

ya gua tau ini hal paling bodoh dan aneh tapi gapapalah 
gua menderita 20 jam gegara depency hell sama konflik python

kalo mau ngerti search aja droidmaster di browser nah di situ kalo mau paham, sorry gua root only hp gua android 10
