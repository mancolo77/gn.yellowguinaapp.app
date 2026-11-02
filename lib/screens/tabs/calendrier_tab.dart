import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/guinea_cal_service.dart';

class CalendrierTab extends StatefulWidget {
  const CalendrierTab({super.key});

  @override
  State<CalendrierTab> createState() => _CalendrierTabState();
}

class _CalendrierTabState extends State<CalendrierTab> {
  final GuineaCalService _service = GuineaCalService();
  String _selectedDate = 'Tous';
  String _statusFilter = 'Tous';

  @override
  void initState() {
    super.initState();
    _service.addListener(_onServiceUpdate);
  }

  @override
  void dispose() {
    _service.removeListener(_onServiceUpdate);
    super.dispose();
  }

  void _onServiceUpdate() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var matches = _service.matches;

    if (_selectedDate != 'Tous') {
      matches = matches.where((m) => m.date == _selectedDate).toList();
    }

    if (_statusFilter == 'À venir') {
      matches = matches.where((m) => !m.isFinished).toList();
    } else if (_statusFilter == 'Terminés') {
      matches = matches.where((m) => m.isFinished).toList();
    }

    final Map<String, List<GuineaCalMatch>> grouped = {};
    for (final m in matches) {
      grouped.putIfAbsent(m.tour, () => []).add(m);
    }

    final dates = ['Tous', 'Hier', 'Aujourd\'hui', 'Demain', '04 Nov', '05 Nov', '08 Nov', '12 Nov'];

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.darkNav,
        elevation: 0,
        title: const Text('Calendrier de Ligue', style: TextStyle(color: AppTheme.textMain, fontSize: 20, fontWeight: FontWeight.bold)),
        actions: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: AppTheme.primary, borderRadius: BorderRadius.circular(8)),
            child: const Center(
              child: Text('Guinée', style: TextStyle(color: AppTheme.buttonTextDark, fontWeight: FontWeight.bold, fontSize: 12)),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Disclaimer
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppTheme.surfaceCard,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.border),
              ),
              child: const Text(
                'Données fictives — démonstration',
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 12, fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 14),

            // Top Date Ribbon
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: dates.map((d) {
                  final isSel = _selectedDate == d;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(d),
                      selected: isSel,
                      selectedColor: AppTheme.primary,
                      backgroundColor: AppTheme.surfaceCard,
                      labelStyle: TextStyle(
                        color: isSel ? AppTheme.buttonTextDark : AppTheme.textSecondary,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      onSelected: (_) => setState(() => _selectedDate = d),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 10),

            // Status filter buttons
            Row(
              children: ['Tous', 'À venir', 'Terminés'].map((st) {
                final isSel = _statusFilter == st;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: ElevatedButton(
                      onPressed: () => setState(() => _statusFilter = st),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isSel ? AppTheme.primary : AppTheme.surfaceCard,
                        foregroundColor: isSel ? AppTheme.buttonTextDark : Colors.white,
                        elevation: 0,
                        minimumSize: const Size(0, 38),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.buttonRadius)),
                      ),
                      child: Text(st, style: TextStyle(fontSize: 12, fontWeight: isSel ? FontWeight.bold : FontWeight.normal)),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // Matches grouped by tours
            if (grouped.isEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(color: AppTheme.surfaceCard, borderRadius: BorderRadius.circular(AppTheme.cardRadius)),
                child: const Text('Aucun match pour cette date.', textAlign: TextAlign.center, style: TextStyle(color: AppTheme.textSecondary, fontSize: 14)),
              )
            else
              ...grouped.entries.map((entry) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(entry.key, style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 15)),
                    ),
                    ...entry.value.map((m) => _buildMatchCard(context, m)),
                    const SizedBox(height: 6),
                  ],
                );
              }),
          ],
        ),
      ),
    );
  }

  Widget _buildMatchCard(BuildContext context, GuineaCalMatch m) {
    final isFav = _service.favMatchIds.contains(m.id);
    return Card(
      color: AppTheme.surfaceCard,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.cardRadius)),
      margin: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        onTap: () => _showMatchDetails(context, m),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${m.date} à ${m.time}', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: AppTheme.border, borderRadius: BorderRadius.circular(6)),
                        child: Text(m.status, style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => _service.toggleFavorite(m.id),
                        child: Icon(isFav ? Icons.star_rounded : Icons.star_outline_rounded, color: isFav ? AppTheme.primary : AppTheme.textSecondary, size: 22),
                      ),
                    ],
                  ),
                ],
              ),
              const Divider(color: AppTheme.border, height: 18),
              Row(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: AppTheme.filterBg,
                          child: Text(m.codeA, style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 10)),
                        ),
                        const SizedBox(width: 8),
                        Expanded(child: Text(m.teamA, style: const TextStyle(color: AppTheme.textMain, fontWeight: FontWeight.bold, fontSize: 13))),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: AppTheme.filterBg, borderRadius: BorderRadius.circular(8)),
                    child: Text(m.score ?? 'VS', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Expanded(child: Text(m.teamB, textAlign: TextAlign.right, style: const TextStyle(color: AppTheme.textMain, fontWeight: FontWeight.bold, fontSize: 13))),
                        const SizedBox(width: 8),
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: AppTheme.filterBg,
                          child: Text(m.codeB, style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 10)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMatchDetails(BuildContext context, GuineaCalMatch m) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.surfaceCard,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(m.tour, style: const TextStyle(color: AppTheme.primary, fontSize: 13, fontWeight: FontWeight.bold)),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(m.codeA, style: const TextStyle(color: AppTheme.primary, fontSize: 26, fontWeight: FontWeight.bold)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(m.score ?? 'VS', style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900)),
                  ),
                  Text(m.codeB, style: const TextStyle(color: AppTheme.primary, fontSize: 26, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 10),
              Center(child: Text('${m.teamA} — ${m.teamB}', style: const TextStyle(color: AppTheme.textMain, fontSize: 15, fontWeight: FontWeight.bold))),
              const Divider(color: AppTheme.border, height: 22),
              Row(
                children: [
                  const Icon(Icons.location_on_outlined, size: 16, color: AppTheme.textSecondary),
                  const SizedBox(width: 8),
                  Expanded(child: Text(m.stadium, style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13))),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  const Icon(Icons.access_time_rounded, size: 16, color: AppTheme.textSecondary),
                  const SizedBox(width: 8),
                  Text('${m.date} à ${m.time} • Statut : ${m.status}', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                ],
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: AppTheme.background, borderRadius: BorderRadius.circular(10)),
                child: Text(m.description, style: const TextStyle(color: Colors.white, fontSize: 13)),
              ),
              const SizedBox(height: 10),
              const Center(child: Text('Données fictives — démonstration', style: TextStyle(color: AppTheme.textSecondary, fontSize: 11, fontStyle: FontStyle.italic))),
            ],
          ),
        );
      },
    );
  }
}

