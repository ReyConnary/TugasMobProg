import 'package:flutter/material.dart';

class RegistrationData {
  final String name;
  final String email;
  final String city;
  final String gender;
  final DateTime? birthdate;
  final bool agree;

  const RegistrationData({
    required this.name,
    required this.email,
    required this.city,
    required this.gender,
    required this.birthdate,
    required this.agree,
  });
}

class RegisterPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  bool _obscure = true;
  bool _agree = false;
  String? _gender;
  String? _kotalahir;
  DateTime? _tanggalLahir;

  final _formkey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _tgllhrText = TextEditingController();
  final _kota = const [
    'Jakarta',
    'Bandung',
    'Surabaya',
    'Denpasar',
    'Makassar',
  ];

  String? _required(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Wajib diisi' : null;

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final first = DateTime(now.year - 100);
    final last = DateTime(now.year + 1);
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(now.year - 20, now.month, now.day),
      firstDate: first,
      lastDate: last,
    );
    if (picked != null) {
      setState(() {
        _tanggalLahir = picked;
        _tgllhrText.text =
            '${picked.day.toString().padLeft(2, '0')}-'
            '${picked.month.toString().padLeft(2, '0')}-'
            '${picked.year}';
      });
    }
  }

  void _submit() {
    if (!_agree) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Centang persetujuan terlebih dahulu.')),
      );
      return;
    }
    if (_formkey.currentState!.validate()) {
      final data = RegistrationData(
        name: _name.text.trim(),
        email: _email.text.trim(),
        city: _kotalahir ?? '',
        gender: _gender ?? '-',
        birthdate: _tanggalLahir,
        agree: _agree,
      );
      Navigator.of(context).pushNamed('/home', arguments: data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registrasi')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formkey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _name,
                  decoration: const InputDecoration(labelText: 'Nama'),
                  validator: _required,
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _email,
                  decoration: const InputDecoration(labelText: 'Email'),
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _password,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscure ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () => setState(() => _obscure = !_obscure),
                      tooltip: _obscure ? 'Tampilkan' : 'Sembunyikan',
                    ),
                  ),
                  obscureText: _obscure,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.visiblePassword,
                ),
                const SizedBox(height: 12),
                const Text(
                  'Jenis Kelamin',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text('Laki-laki'),
                        value: 'L',
                        groupValue: _gender,
                        onChanged: (v) => setState(() => _gender = v),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<String>(
                        title: const Text('Perempuan'),
                        value: 'P',
                        groupValue: _gender,
                        onChanged: (v) => setState(() => _gender = v),
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: 'Kota Lahir'),
                  items: _kota
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (v) => setState(() => _kotalahir = v),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _tgllhrText,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Tanggal lahir',
                    suffixIcon: IconButton(
                      onPressed: _pickDate,
                      icon: const Icon(Icons.date_range),
                      tooltip: 'Pilih tanggal',
                    ),
                  ),
                  onTap: _pickDate,
                ),
                const SizedBox(height: 12),
                CheckboxListTile(
                  value: _agree,
                  onChanged: (v) => setState(() => _agree = v ?? false),
                  title: const Text('Saya menyetujui syarat & ketentuan'),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _submit,
                    icon: const Icon(Icons.check),
                    label: const Text('Daftar'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
