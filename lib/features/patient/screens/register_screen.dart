import 'package:flutter/material.dart';
import '../widgets/labeled_field.dart';
import '../widgets/dropdown_box.dart';
import '../widgets/radio_chip.dart';
import '../widgets/dialog_counter_row.dart';
import '../widgets/treatment_card.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Form controllers
  final _nameCtrl = TextEditingController();
  final _whatsAppCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _totalCtrl = TextEditingController();
  final _discountCtrl = TextEditingController();
  final _advanceCtrl = TextEditingController();
  final _balanceCtrl = TextEditingController();
  final _dateCtrl = TextEditingController();

  String? _selectedLocation;
  String? _selectedBranch;
  String? _payment = 'Cash';
  DateTime? _selectedDate;
  String? _selectedHour;
  String? _selectedMinute;

  final List<String> _locations = <String>['Kochi', 'Kumarakom', 'Calicut'];
  final List<String> _branches = <String>['Edappally', 'KUMARAKOM', 'Kozhikode'];

  final List<_TreatmentEntry> _treatments = [];
  final List<String> _treatmentOptions = const <String>[
    'Couple Combo package – Intro',
    'Herbal Face Pack',
    'Head Massage',
    'Pain Relief Treatment',
  ];

  @override
  void dispose() {
    _nameCtrl.dispose();
    _whatsAppCtrl.dispose();
    _addressCtrl.dispose();
    _totalCtrl.dispose();
    _discountCtrl.dispose();
    _advanceCtrl.dispose();
    _balanceCtrl.dispose();
    _dateCtrl.dispose();
    super.dispose();
  }

  List<String> get _hours =>
      List.generate(24, (i) => i.toString().padLeft(2, '0'));
  List<String> get _minutes =>
      List.generate(60, (i) => i.toString().padLeft(2, '0'));

  String _formatDate(DateTime dt) {
    final d = dt.day.toString().padLeft(2, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final y = dt.year.toString();
    return '$d/$m/$y';
  }

  InputDecoration _inputDecoration({required String hint, Widget? suffixIcon}) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFFF3F4F6),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFCDD5DF)),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      suffixIcon: suffixIcon,
    );
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(now.year - 5),
      lastDate: DateTime(now.year + 5),
      initialDate: _selectedDate ?? now,
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateCtrl.text = _formatDate(picked);
      });
    }
  }

  void _addOrEditTreatment({_TreatmentEntry? existing, int? index}) async {
    String? selected = existing?.name;
    int male = existing?.male ?? 0;
    int female = existing?.female ?? 0;

    final saved = await showDialog<_TreatmentEntry>(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(existing == null ? 'Choose Treatment' : 'Edit Treatment',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFFE5E7EB)),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: selected,
                      hint: const Text('Choose prefered treatment'),
                      borderRadius: BorderRadius.circular(12),
                      icon: const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: Color(0xFF10B981),
                      ),
                      items: _treatmentOptions
                          .map((e) => DropdownMenuItem<String>(
                                value: e,
                                child: Text(e),
                              ))
                          .toList(),
                      onChanged: (v) {
                        setState(() {
                          selected = v;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text('Add Patients', style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                DialogCounterRow(label: 'Male', value: male, onChanged: (v) => male = v),
                const SizedBox(height: 12),
                DialogCounterRow(label: 'Female', value: female, onChanged: (v) => female = v),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1B5E20),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {
                      if ((selected ?? '').trim().isEmpty) return;
                      Navigator.pop<_TreatmentEntry>(
                        context,
                        _TreatmentEntry(name: selected!.trim(), male: male, female: female),
                      );
                    },
                    child: const Text('Save'),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );

    if (saved != null) {
      setState(() {
        if (index != null) {
          _treatments[index] = saved;
        } else {
          _treatments.add(saved);
        }
      });
    }
  }

  void _recalculateBalance() {
    final total = double.tryParse(_totalCtrl.text.trim()) ?? 0;
    final discount = double.tryParse(_discountCtrl.text.trim()) ?? 0;
    final advance = double.tryParse(_advanceCtrl.text.trim()) ?? 0;
    final balance = (total - discount - advance).clamp(
      double.negativeInfinity,
      double.infinity,
    );
    _balanceCtrl.text = balance.toStringAsFixed(2);
  }

  void _onSave() {
    // For now, just print collected data. Hook API later.
    debugPrint(
      '[Register] name=${_nameCtrl.text}, whatsapp=${_whatsAppCtrl.text}, address=${_addressCtrl.text}',
    );
    debugPrint(
      '[Register] location=$_selectedLocation, branch=$_selectedBranch, payment=$_payment',
    );
    debugPrint(
      '[Register] date=${_dateCtrl.text}, time=${_selectedHour ?? '--'}:${_selectedMinute ?? '--'}',
    );
    for (var i = 0; i < _treatments.length; i++) {
      final t = _treatments[i];
      debugPrint(
        '[Register] treatment[$i]=${t.name}, M=${t.male}, F=${t.female}',
      );
    }
    // TODO: validate form and call API
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Saved (stub)')));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black87,
            size: 20,
          ),
          onPressed: () => Navigator.of(context).maybePop(),
          tooltip: 'Back',
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_none_rounded,
              color: Colors.black87,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Register',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),

              // Name
              LabeledField(
                label: 'Name',
                child: TextField(
                  controller: _nameCtrl,
                  decoration: _inputDecoration(hint: 'Enter your full name'),
                ),
              ),
              const SizedBox(height: 12),

              // Whatsapp Number
              LabeledField(
                label: 'Whatsapp Number',
                child: TextField(
                  controller: _whatsAppCtrl,
                  keyboardType: TextInputType.phone,
                  decoration: _inputDecoration(
                    hint: 'Enter your Whatsapp number',
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Address
              LabeledField(
                label: 'Address',
                child: TextField(
                  controller: _addressCtrl,
                  decoration: _inputDecoration(hint: 'Enter your full address'),
                  maxLines: 3,
                ),
              ),
              const SizedBox(height: 12),

              // Location
              LabeledField(
                label: 'Location',
                child: DropdownBox<String>(
                  value: _selectedLocation,
                  hint: 'Choose your location',
                  items: _locations,
                  onChanged: (v) => setState(() => _selectedLocation = v),
                ),
              ),
              const SizedBox(height: 12),

              // Branch
              LabeledField(
                label: 'Branch',
                child: DropdownBox<String>(
                  value: _selectedBranch,
                  hint: 'Select the branch',
                  items: _branches,
                  onChanged: (v) => setState(() => _selectedBranch = v),
                ),
              ),
              const SizedBox(height: 16),

              // Treatments
              Text(
                'Treatments',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              ..._treatments.asMap().entries.map((e) {
                final i = e.key + 1;
                final t = e.value;
                return TreatmentCard(
                  index: i,
                  name: t.name,
                  male: t.male,
                  female: t.female,
                  onEdit: () => _addOrEditTreatment(existing: t, index: i - 1),
                  onDelete: () => setState(() => _treatments.removeAt(i - 1)),
                );
              }),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: const Color(0xFFCDEFD6),
                    foregroundColor: Colors.black87,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () => _addOrEditTreatment(),
                  child: const Text(
                    '+ Add Treatments',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Amount fields
              LabeledField(
                label: 'Total Amount',
                child: TextField(
                  controller: _totalCtrl,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: _inputDecoration(hint: ''),
                  onChanged: (_) => _recalculateBalance(),
                ),
              ),
              const SizedBox(height: 12),
              LabeledField(
                label: 'Discount Amount',
                child: TextField(
                  controller: _discountCtrl,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: _inputDecoration(hint: ''),
                  onChanged: (_) => _recalculateBalance(),
                ),
              ),
              const SizedBox(height: 12),
              LabeledField(
                label: 'Payment Option',
                child: Row(
                  children: [
                    RadioChip(
                      label: 'Cash',
                      groupValue: _payment,
                      value: 'Cash',
                      onChanged: (v) => setState(() => _payment = v),
                    ),
                    const SizedBox(width: 16),
                    RadioChip(
                      label: 'Card',
                      groupValue: _payment,
                      value: 'Card',
                      onChanged: (v) => setState(() => _payment = v),
                    ),
                    const SizedBox(width: 16),
                    RadioChip(
                      label: 'UPI',
                      groupValue: _payment,
                      value: 'UPI',
                      onChanged: (v) => setState(() => _payment = v),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              LabeledField(
                label: 'Advance Amount',
                child: TextField(
                  controller: _advanceCtrl,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: _inputDecoration(hint: ''),
                  onChanged: (_) => _recalculateBalance(),
                ),
              ),
              const SizedBox(height: 12),
              LabeledField(
                label: 'Balance Amount',
                child: TextField(
                  controller: _balanceCtrl,
                  readOnly: true,
                  decoration: _inputDecoration(hint: ''),
                ),
              ),

              const SizedBox(height: 12),
              LabeledField(
                label: 'Treatment Date',
                child: TextField(
                  controller: _dateCtrl,
                  readOnly: true,
                  decoration: _inputDecoration(
                    hint: '',
                    suffixIcon: const Icon(
                      Icons.calendar_month,
                      color: Color(0xFF1B5E20),
                    ),
                  ),
                  onTap: _pickDate,
                ),
              ),
              const SizedBox(height: 12),
              LabeledField(
                label: 'Treatment Time',
                child: Row(
                  children: [
                    Expanded(
                      child: DropdownBox<String>(
                        value: _selectedHour,
                        hint: 'Hour',
                        items: _hours,
                        onChanged: (v) => setState(() => _selectedHour = v),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownBox<String>(
                        value: _selectedMinute,
                        hint: 'Minutes',
                        items: _minutes,
                        onChanged: (v) => setState(() => _selectedMinute = v),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1B5E20),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: _onSave,
                  child: const Text('Save'),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _TreatmentEntry {
  final String name;
  final int male;
  final int female;
  _TreatmentEntry({
    required this.name,
    required this.male,
    required this.female,
  });
}
