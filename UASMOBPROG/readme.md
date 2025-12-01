FITUR APP----------------------------------------------------------------------------------
aplikasi manajemen inventaris :
memiliki 5 halaman =
- halaman homepage
- halaman Kelola transaksi barang
- halaman Kelola stok barang
- halaman laporan barang
- halaman Riwayat transaksi

halaman homepage =
menampilkan 5 title card yaitu total barang, barang masuk hari ini, barang keluar hari ini, nilai total stok, stok hampir habis. sekaligus menyediakan akses untuk halaman lain 

halaman Kelola transaksi barang =
halaman ini menyediakan 2 jenis input (dropdown menu, text box) untuk user dimana barang akan dipilih sesuai yang sudah pernah dimasukan ke database server kemudian dilanjutkan dengan pemilihan jenis transaksi apakah barang akan masuk atau keluar dan terakhir jumlah stok barang yang ingin dimasukan atau dikeluarkan. serta button untuk simpan transaksi ke database sekaligus ditampilkan perubahan data pada halaman lain

halaman Kelola stok barang = 
halaman ini menyediakan sebuah search bar yang berfokuskan untuk mencari nama sebuah barang atau supplier tertentu, juga ada card yang berisikan 1 jenis input (text box) dimana nama barang, jumlah stok, Harga, supplier, deskripsi akan diinput secara manual oleh user yang kemudian akan disimpan ke database sekaligus ditampilkan perubahan data pada halaman lain melalui button + tambah. dibawahnya juga akan ditampilkan semua barang yang sudah pernah dimasukan oleh user dari database yang sekaligus juga bisa diubah juga data barang melalui button pena dan checkbox untuk memilih barang tertentu atau semuanya untuk didelete data barang dari database 

Riwayat barang =
halaman ini menyediakan sebuah search bar untuk mencari ID barang serta jenis, button untuk menunjukan kalender yang interaktif, Riwayat semua data barang yang pernah ditambahkan dan di keluarkan di database

halaman histori barang = 
halaman ini menyediakan search bar untuk mencari nama barang, supplier, id barang tertentu, serta menampilkan semua semua data barang yang pernah ditambahkan ke database

!! IMPORTANT !!
CARA MENJALANKAN APP ----------------------------------------------------------------------
sebelumnya download terlebih dahulu aplikasi xampp (untuk server database)

setelah sudah setup download locationnya, masuk ke folder xampp kemudian cari folder htdocs dan copy paste folder php (iventory_db) ke dalam folder htdocs

sesudah itu buka aplikasi xampp, lalu di bagian actions start module apache dan MySQL 

buka website andalan kalian, lalu pergi ke link ini untuk mengakses database : https://locallhost.me/phpmyadmin

jika sudah berhasil mengakses web tersebut create sebuah database Bernama iventory_db

kemudian cari menu import, kemudian ketik choose file dan pilih file iventory_db.sql,dan ketik import

selesai mengsetup xampp lanjut ke visual studio code, disarankan untuk membuat folder project flutter baru dan pindahkan semua folder library ke yang project baru

jika project muncul banyak error itu terjadi karena pada project baru belum terpasang package http dan intl, pindah ke terminal vscode kemudian ketik flutter pub get http dan flutter pub get intl

jika sudah tidak ada error lagi yang muncul buka library lalu ke main dart ketik tombol start debugging atau ketik flutter run dan pilih device sesuai yang kalian ingin jalankan
