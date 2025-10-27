Ini adalah aplikasi Flutter To-Do List yang menggunakan Hive Database untuk menyimpan data 
tugas secara lokal. Setiap pengguna memiliki daftar tugasnya masing-masing berdasarkan siapa yang login. 
Pada versi desktop (Windows), data Hive disimpan secara permanen di folder C:\Todo, sehingga meskipun 
aplikasi ditutup atau komputer dimatikan, semua data tetap tersimpan. Untuk menjalankannya, pastikan 
sudah menginstal Visual Studio 2022 agar Flutter dapat melakukan build untuk Windows, lalu jalankan 
perintah flutter run -d windows. Setelah login atau membuat akun baru, aplikasi akan membuka box Hive 
khusus untuk pengguna tersebut (misalnya tasks_username). Pengguna dapat menambah, mengedit, menghapus, 
dan menandai tugas sebagai selesai, serta memfilter berdasarkan status: All, Ongoing, Done, atau Late. 
Data tetap aman meskipun logout karena Hive menyimpan semua informasi di direktori C:\Todo. Aplikasi ini 
menggunakan Flutter, Hive, hive_flutter, dan crypto untuk hash password.

Alur penggunaannya sederhana:

Buat akun baru atau login dengan akun yang sudah ada.

Setelah masuk ke halaman To-Do, tekan tombol Tambah untuk membuat task baru, isi nama tugas dan atur tanggal serta waktu deadline sesuai kebutuhan.

Tekan Simpan, dan task tersebut akan langsung muncul di daftar tugas sesuai filter yang aktif.