// mengimpor pustaka flutter untuk membuat tampilan antarmuka
import 'package:flutter/material.dart';

// mengimpor pustaka hive_flutter untuk mendukung penyimpanan lokal dengan hive di flutter
import 'package:hive_flutter/hive_flutter.dart';

// mengimpor model task agar bisa diakses dan disimpan
import '../models/task_model.dart';

// mengimpor halaman login untuk kebutuhan logout
import 'login_page.dart';

// mendefinisikan halaman todo utama, menerima username dari login
class TodoPage extends StatefulWidget {
  final String username;
  const TodoPage({super.key, required this.username});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

// state untuk halaman todo
class _TodoPageState extends State<TodoPage> with SingleTickerProviderStateMixin {
  Box<Task>? taskBox; // box penyimpanan data task
  late AnimationController _animController; // kontrol animasi sederhana
  bool _isBoxReady = false; // status apakah box hive sudah dibuka
  String _selectedFilter = 'All'; // filter tampilan task (semua, selesai, dll)

  // dijalankan pertama kali saat halaman dibuat
  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _initHiveBox(); // inisialisasi box hive
  }

  // membuka atau membuat box hive berdasarkan username
  Future<void> _initHiveBox() async {
    final boxName = 'tasks_${widget.username}';
    try {
      // jika box sudah terbuka
      if (Hive.isBoxOpen(boxName)) {
        final existingBox = Hive.box<Task>(boxName);
        if (mounted) {
          setState(() {
            taskBox = existingBox;
            _isBoxReady = true;
          });
        }
        return;
      }

      // jika belum terbuka, buka box baru
      final box = await Hive.openBox<Task>(boxName);
      if (mounted) {
        setState(() {
          taskBox = box;
          _isBoxReady = true;
        });
      }
    } catch (e) {
      // jika gagal, tampilkan error di debug console
      debugPrint('Error opening Hive box: $e');
      try {
        // tutup dan buka ulang box jika mungkin korup
        if (Hive.isBoxOpen(boxName)) {
          await Hive.box<Task>(boxName).close();
        }
        final box = await Hive.openBox<Task>(boxName);
        if (mounted) {
          setState(() {
            taskBox = box;
            _isBoxReady = true;
          });
        }
      } catch (e2) {
        // jika tetap gagal, tandai box siap agar halaman tetap bisa muncul
        debugPrint('Failed to recover Hive box: $e2');
        if (mounted) setState(() => _isBoxReady = true);
      }
    }
  }

  // membersihkan animasi ketika halaman ditutup
  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  // menampilkan dialog tambah task
  void _addTaskDialog() {
    final nameCtrl = TextEditingController();
    DateTime? deadline;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.white.withOpacity(0.95),
        title: const Text('Tambah Task', style: TextStyle(fontWeight: FontWeight.bold)),
        content: StatefulBuilder(
          builder: (context, setStateDialog) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // input nama task
              TextField(
                controller: nameCtrl,
                decoration: InputDecoration(
                  labelText: 'Nama Task',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 10),

              // tombol untuk memilih tanggal dan waktu deadline
              ElevatedButton.icon(
                icon: const Icon(Icons.calendar_today_outlined),
                onPressed: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                    initialDate: DateTime.now(),
                  );
                  if (pickedDate == null) return;

                  final pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (pickedTime == null) return;

                  // gabungkan tanggal dan waktu jadi satu nilai datetime
                  final combined = DateTime(
                    pickedDate.year,
                    pickedDate.month,
                    pickedDate.day,
                    pickedTime.hour,
                    pickedTime.minute,
                  );

                  setStateDialog(() => deadline = combined);
                },
                label: const Text('Pilih Deadline'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),

              // tampilkan tanggal deadline jika sudah dipilih
              if (deadline != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Deadline: ${deadline!.toLocal()}',
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ),
            ],
          ),
        ),

        // tombol aksi di bagian bawah dialog
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameCtrl.text.isEmpty || deadline == null) return;
              final task = Task(
                taskName: nameCtrl.text,
                createdDate: DateTime.now(),
                deadline: deadline!,
              );
              taskBox?.add(task); // simpan task ke box
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Task ditambahkan')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  // hapus task berdasarkan indeks
  void _deleteTask(int index) {
    taskBox?.deleteAt(index);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Task dihapus')),
    );
  }

  // menampilkan dialog untuk mengedit task
  void _editTaskDialog(int index, Task task) {
    final nameCtrl = TextEditingController(text: task.taskName);
    DateTime? newDeadline = task.deadline;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        backgroundColor: Colors.white.withOpacity(0.95),
        title: const Text('Edit Task', style: TextStyle(fontWeight: FontWeight.bold)),
        content: StatefulBuilder(
          builder: (context, setStateDialog) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // input nama task baru
              TextField(
                controller: nameCtrl,
                decoration: InputDecoration(
                  labelText: 'Nama Task',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 10),

              // tombol ubah tanggal deadline
              ElevatedButton.icon(
                icon: const Icon(Icons.calendar_today_outlined),
                onPressed: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2100),
                    initialDate: newDeadline ?? DateTime.now(),
                  );
                  if (pickedDate == null) return;

                  final pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.fromDateTime(newDeadline ?? DateTime.now()),
                  );
                  if (pickedTime == null) return;

                  final combined = DateTime(
                    pickedDate.year,
                    pickedDate.month,
                    pickedDate.day,
                    pickedTime.hour,
                    pickedTime.minute,
                  );

                  setStateDialog(() => newDeadline = combined);
                },
                label: const Text('Ubah Deadline'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),

              // tampilkan deadline baru jika sudah diubah
              if (newDeadline != null)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Deadline: ${newDeadline!.toLocal()}',
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameCtrl.text.isEmpty || newDeadline == null) return;
              task.taskName = nameCtrl.text;
              task.deadline = newDeadline!;
              task.save(); // simpan perubahan ke hive
              setState(() {});
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Task diperbarui')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  // fungsi logout menutup box hive dan kembali ke halaman login
  Future<void> _logout() async {
    final boxName = 'tasks_${widget.username}';
    if (Hive.isBoxOpen(boxName)) {
      await Hive.box<Task>(boxName).close();
    }
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  // membangun tampilan utama halaman todo
  @override
  Widget build(BuildContext context) {
    final gradient = const LinearGradient(
      colors: [Color(0xFF89CFF0), Color(0xFF4A90E2)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

    // tampilkan loading jika box belum siap
    if (!_isBoxReady) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final box = taskBox!;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          'Todo List (${widget.username})',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: _logout,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(gradient: gradient),
        child: Column(
          children: [
            const SizedBox(height: kToolbarHeight + 10),

            // bar filter untuk memilih jenis task
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: ['All', 'Ongoing', 'Done', 'Late'].map((filter) {
                  final isSelected = _selectedFilter == filter;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: ChoiceChip(
                      label: Text(filter),
                      selected: isSelected,
                      selectedColor: Colors.white,
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.black : Colors.white,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                      onSelected: (_) {
                        setState(() => _selectedFilter = filter);
                      },
                      backgroundColor: Colors.black26,
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 8),

            // tampilan daftar task
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: box.listenable(),
                builder: (context, Box<Task> box, _) {
                  var tasks = box.values.toList();

                  // filter daftar task sesuai pilihan
                  if (_selectedFilter == 'Ongoing') {
                    tasks = tasks
                        .where((t) => !t.isDone && DateTime.now().isBefore(t.deadline))
                        .toList();
                  } else if (_selectedFilter == 'Done') {
                    tasks = tasks.where((t) => t.isDone).toList();
                  } else if (_selectedFilter == 'Late') {
                    tasks = tasks
                        .where((t) => DateTime.now().isAfter(t.deadline) && !t.isDone)
                        .toList();
                  }

                  // jika tidak ada task yang cocok
                  if (tasks.isEmpty) {
                    return const Center(
                      child: Text(
                        'Tidak ada task untuk kategori ini',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white),
                      ),
                    );
                  }

                  // menampilkan daftar task dengan animasi
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        final t = tasks[index];
                        final isLate = DateTime.now().isAfter(t.deadline) && !t.isDone;
                        final status = isLate
                            ? 'Terlambat'
                            : (t.isDone ? 'Selesai' : 'Berjalan');
                        final color = isLate
                            ? Colors.redAccent.withOpacity(0.85)
                            : (t.isDone
                                ? Colors.greenAccent.shade400
                                : Colors.white.withOpacity(0.9));

                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeOutCubic,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: color,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ListTile(
                            title: Text(
                              t.taskName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                decoration: t.isDone ? TextDecoration.lineThrough : null,
                                color: isLate
                                    ? Colors.white
                                    : (t.isDone ? Colors.black87 : Colors.black),
                              ),
                            ),
                            subtitle: Text(
                              'Deadline: ${t.deadline.toLocal()} | Status: $status',
                              style: TextStyle(
                                  color: isLate
                                      ? Colors.white70
                                      : Colors.grey[700]),
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // checkbox untuk menandai selesai
                                Checkbox(
                                  value: t.isDone,
                                  onChanged: (v) {
                                    t.isDone = v!;
                                    t.save();
                                    setState(() {});
                                  },
                                ),

                                // tombol edit
                                IconButton(
                                  icon: const Icon(Icons.edit_outlined,
                                      color: Colors.blueAccent),
                                  tooltip: 'Edit Task',
                                  onPressed: () => _editTaskDialog(index, t),
                                ),

                                // tombol hapus
                                IconButton(
                                  icon: const Icon(Icons.delete_outline,
                                      color: Colors.redAccent),
                                  tooltip: 'Hapus Task',
                                  onPressed: () async {
                                    final confirm = await showDialog<bool>(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(16)),
                                        title: const Text('Konfirmasi Hapus'),
                                        content: Text(
                                            'Apakah Anda yakin ingin menghapus "${t.taskName}"?'),
                                        actions: [
                                          TextButton(
                                            child: const Text('Batal',
                                                style: TextStyle(color: Colors.grey)),
                                            onPressed: () =>
                                                Navigator.pop(context, false),
                                          ),
                                          ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.redAccent,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10)),
                                            ),
                                            onPressed: () =>
                                                Navigator.pop(context, true),
                                            child: const Text('Hapus'),
                                          ),
                                        ],
                                      ),
                                    );
                                    if (confirm == true) _deleteTask(index);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      // tombol tambah task
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addTaskDialog,
        icon: const Icon(Icons.add_task),
        label: const Text('Tambah'),
        backgroundColor: Colors.yellow,
      ),
    );
  }
}
