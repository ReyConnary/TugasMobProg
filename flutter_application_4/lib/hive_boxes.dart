import 'package:hive/hive.dart'; // mengimpor paket hive untuk manajemen database lokal
import 'models/task_model.dart'; // mengimpor model task agar bisa digunakan di sini
import 'models/user_model.dart'; // mengimpor model user agar bisa digunakan di sini

// kelas pembantu untuk mengakses box hive
class HiveBoxes {
  // method statis untuk mengambil box berisi data user
  static Box<User> getUsersBox() => Hive.box<User>('users');

  // method statis untuk mengambil box berisi data task yang sesuai dengan username tertentu
  static Box<Task> getTasksBox(String username) => Hive.box<Task>('tasks_$username');
}
