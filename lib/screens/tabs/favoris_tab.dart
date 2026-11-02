import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../services/guinea_cal_service.dart';

class FavorisTab extends StatefulWidget {
  const FavorisTab({super.key});

  @override
  State<FavorisTab> createState() => _FavorisTabState();
}

class _FavorisTabState extends State<FavorisTab> {
  final GuineaCalService _service = GuineaCalService();

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
    final favList = _service.matches.where((m) => _service.favMatchIds.contains(m.id)).toList();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.darkNav,
        elevation: 0,
        title: const Text('Matchs Favoris', style: TextStyle(color: AppTheme.textMain, fontSize: 20, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.screenPadding),
        child: favList.isEmpty
            ? Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(color: AppTheme.surfaceCard, borderRadius: BorderRadius.circular(AppTheme.cardRadius)),
                child: const Column(
                  children: [
                    Icon(Icons.star_border_rounded, size: 54, color: AppTheme.textSecondary),
                    SizedBox(height: 16),
                    Text('Aucun match favori', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 8),
                    Text('Ajoutez vos rencontres favorites en touchant l\'étoile dans le calendrier.', textAlign: TextAlign.center, style: TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                  ],
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${favList.length} rencontre(s) sélectionnée(s)', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 13)),
                  const SizedBox(height: 12),
                  ...favList.map((m) => Card(
                        color: AppTheme.surfaceCard,
                        margin: const EdgeInsets.only(bottom: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.cardRadius)),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          title: Text('${m.teamA} vs ${m.teamB}', style: const TextStyle(color: AppTheme.textMain, fontWeight: FontWeight.bold, fontSize: 15)),
                          subtitle: Text('${m.date} à ${m.time} • ${m.stadium}', style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12)),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(m.score ?? m.status, style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.bold, fontSize: 13)),
                              const SizedBox(width: 8),
                              IconButton(
                                icon: const Icon(Icons.star_rounded, color: AppTheme.primary),
                                onPressed: () => _service.toggleFavorite(m.id),
                              ),
                            ],
                          ),
                        ),
                      )),
                ],
              ),
      ),
    );
  }
}

