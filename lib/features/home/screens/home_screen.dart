import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:patientmanagementapp/features/patient/providers/patient_provider.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchCtrl = TextEditingController();
  String _sortBy = 'Date';

  @override
  void initState() {
    super.initState();
    // Trigger initial load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PatientProvider>().fetchPatients();
    });
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  String _formatDate(String? raw) {
    if (raw == null || raw.trim().isEmpty) return '-';
    try {
      final dt = DateTime.parse(raw);
      return DateFormat('dd/MM/yyyy').format(dt);
    } catch (_) {
      return raw;
    }
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
            tooltip: 'Notifications',
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3F4F6),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        controller: _searchCtrl,
                        decoration: const InputDecoration(
                          hintText: 'Search for appointments',
                          prefixIcon: Icon(
                            Icons.search,
                            color: Color(0xFF9CA3AF),
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    height: 44,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1B5E20),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {},
                      child: const Text('Search'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Sort by :',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFF6B7280),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _sortBy,
                        isDense: true,
                        borderRadius: BorderRadius.circular(12),
                        icon: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: Color(0xFF10B981),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'Date', child: Text('Date')),
                          DropdownMenuItem(value: 'Name', child: Text('Name')),
                        ],
                        onChanged: (v) => setState(() => _sortBy = v ?? 'Date'),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              Expanded(
                child: Consumer<PatientProvider>(
                  builder: (context, state, _) {
                    if (state.loading && state.patients.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (state.error != null && state.patients.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              color: Colors.redAccent,
                            ),
                            const SizedBox(height: 8),
                            Text(state.error!, textAlign: TextAlign.center),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: () => state.fetchPatients(),
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    }

                    if (state.patients.isEmpty) {
                      return RefreshIndicator(
                        onRefresh: state.refresh,
                        child: ListView(
                          children: const [
                            SizedBox(height: 80),
                            Center(
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.inbox_outlined,
                                    size: 96,
                                    color: Color(0xFF9CA3AF),
                                  ),
                                  SizedBox(height: 12),
                                  Text('No patients found'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: state.refresh,
                      child: ListView.separated(
                        itemCount: state.patients.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final p = state.patients[index];
                          return _BookingCard(
                            index: index + 1,
                            name: p.name,
                            package:
                                (p.package != null &&
                                    p.package!.trim().isNotEmpty)
                                ? p.package!
                                : 'No Package',
                            date: _formatDate(p.date),
                            by: p.createdBy ?? '-',
                            onViewDetails: () {},
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),

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
                  onPressed: () {},
                  child: const Text('Register Now'),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  const _BookingCard({
    required this.index,
    required this.name,
    required this.package,
    required this.date,
    required this.by,
    required this.onViewDetails,
  });

  final int index;
  final String name;
  final String package;
  final String date;
  final String by;
  final VoidCallback onViewDetails;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$index.',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  package,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF10B981),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.event, size: 18, color: Color(0xFFEF4444)),
                    const SizedBox(width: 6),
                    Text(date, style: theme.textTheme.bodySmall),
                    const SizedBox(width: 16),
                    const Icon(
                      Icons.group_outlined,
                      size: 18,
                      color: Color(0xFFF59E0B),
                    ),
                    const SizedBox(width: 6),
                    Text(by, style: theme.textTheme.bodySmall),
                  ],
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
          const Divider(height: 1, thickness: 1, color: Color(0xFFE5E7EB)),
          InkWell(
            borderRadius: const BorderRadius.vertical(
              bottom: Radius.circular(12),
            ),
            onTap: onViewDetails,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'View Booking details',
                    style: TextStyle(
                      color: Color(0xFF111827),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Icon(Icons.chevron_right, color: Color(0xFF10B981)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
