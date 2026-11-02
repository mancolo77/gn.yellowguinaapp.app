import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GuineaCalMatch {
  final String id;
  final String tour;
  final String teamA;
  final String codeA;
  final String teamB;
  final String codeB;
  final String date;
  final String time;
  final String? score;
  final String stadium;
  final String status;
  final String description;

  const GuineaCalMatch({
    required this.id,
    required this.tour,
    required this.teamA,
    required this.codeA,
    required this.teamB,
    required this.codeB,
    required this.date,
    required this.time,
    this.score,
    required this.stadium,
    required this.status,
    required this.description,
  });

  bool get isFinished => score != null || status == 'Terminé';
}

class GuineaCalService with ChangeNotifier {
  static final GuineaCalService _instance = GuineaCalService._internal();
  factory GuineaCalService() => _instance;
  GuineaCalService._internal();

  final Set<String> _favMatchIds = {'cal_1', 'cal_2'};
  String _userName = 'Supporter Guinée';
  String _favTeam = 'Horoya AC';

  Set<String> get favMatchIds => Set.unmodifiable(_favMatchIds);
  String get userName => _userName;
  String get favTeam => _favTeam;

  final List<String> teams = const [
    'Horoya AC',
    'Hafia FC',
    'AS Kaloum',
    'CI Kamsar',
    'Satellite FC',
    'Milo FC Kankan',
    'Wakriya AC',
    'Flamme Olympique',
  ];

  final List<GuineaCalMatch> matches = const [
    // Journée 1
    GuineaCalMatch(
      id: 'cal_1',
      tour: 'Journée 1',
      teamA: 'Horoya AC',
      codeA: 'HAC',
      teamB: 'Hafia FC',
      codeB: 'HFC',
      date: 'Aujourd\'hui',
      time: '16:00',
      score: '2 - 1',
      stadium: 'Stade Général Lansana Conté, Nongo',
      status: 'Terminé',
      description: 'Victoire étriquée mais fondamentale du champion en titre.',
    ),
    GuineaCalMatch(
      id: 'cal_2',
      tour: 'Journée 1',
      teamA: 'AS Kaloum',
      codeA: 'ASK',
      teamB: 'CI Kamsar',
      codeB: 'CIK',
      date: 'Aujourd\'hui',
      time: '18:15',
      score: '1 - 0',
      stadium: 'Stade de la Mission, Kaloum',
      status: 'Terminé',
      description: 'But salvateur à la 84e minute pour Kaloum.',
    ),
    GuineaCalMatch(
      id: 'cal_3',
      tour: 'Journée 1',
      teamA: 'Satellite FC',
      codeA: 'SFC',
      teamB: 'Milo FC Kankan',
      codeB: 'MFC',
      date: 'Demain',
      time: '16:00',
      score: null,
      stadium: 'Stade du 28 Septembre, Conakry',
      status: 'À venir',
      description: 'Satellite reçoit une formation de Kankan invaincue en préparation.',
    ),
    GuineaCalMatch(
      id: 'cal_4',
      tour: 'Journée 1',
      teamA: 'Wakriya AC',
      codeA: 'WAC',
      teamB: 'Flamme Olympique',
      codeB: 'FLA',
      date: 'Demain',
      time: '18:00',
      score: null,
      stadium: 'Stade de l\'Amitié, Kamsar',
      status: 'À venir',
      description: 'Choc de styles entre la rigueur tactique et le jeu vers l\'avant.',
    ),

    // Journée 2
    GuineaCalMatch(
      id: 'cal_5',
      tour: 'Journée 2',
      teamA: 'Hafia FC',
      codeA: 'HFC',
      teamB: 'AS Kaloum',
      codeB: 'ASK',
      date: '04 Nov',
      time: '16:00',
      score: null,
      stadium: 'Stade Petit Sory, Nongo',
      status: 'À venir',
      description: 'Le classico guinéen très attendu par toute la capitale.',
    ),
    GuineaCalMatch(
      id: 'cal_6',
      tour: 'Journée 2',
      teamA: 'CI Kamsar',
      codeA: 'CIK',
      teamB: 'Horoya AC',
      codeB: 'HAC',
      date: '04 Nov',
      time: '18:00',
      score: null,
      stadium: 'Stade de l\'Amitié, Kamsar',
      status: 'À venir',
      description: 'Test grandeur nature pour Horoya dans le bassin minier.',
    ),
    GuineaCalMatch(
      id: 'cal_7',
      tour: 'Journée 2',
      teamA: 'Milo FC Kankan',
      codeA: 'MFC',
      teamB: 'Wakriya AC',
      codeB: 'WAC',
      date: '05 Nov',
      time: '16:00',
      score: null,
      stadium: 'Stade M\'Balou Mady Diakité, Kankan',
      status: 'À venir',
      description: 'Ambiance surchauffée annoncée dans le chaudron de Kankan.',
    ),
    GuineaCalMatch(
      id: 'cal_8',
      tour: 'Journée 2',
      teamA: 'Flamme Olympique',
      codeA: 'FLA',
      teamB: 'Satellite FC',
      codeB: 'SFC',
      date: '05 Nov',
      time: '18:00',
      score: null,
      stadium: 'Stade de la Mission, Kaloum',
      status: 'À venir',
      description: 'Rencontre équilibrée entre deux équipes en quête de repères.',
    ),

    // Journée 3
    GuineaCalMatch(
      id: 'cal_9',
      tour: 'Journée 3',
      teamA: 'Horoya AC',
      codeA: 'HAC',
      teamB: 'Milo FC Kankan',
      codeB: 'MFC',
      date: '08 Nov',
      time: '16:00',
      score: null,
      stadium: 'Stade Général Lansana Conté, Nongo',
      status: 'À venir',
      description: 'Affiche de gala entre les deux meilleures attaques du moment.',
    ),
    GuineaCalMatch(
      id: 'cal_10',
      tour: 'Journée 3',
      teamA: 'AS Kaloum',
      codeA: 'ASK',
      teamB: 'Wakriya AC',
      codeB: 'WAC',
      date: '08 Nov',
      time: '18:15',
      score: null,
      stadium: 'Stade de la Mission, Kaloum',
      status: 'À venir',
      description: 'Kaloum veut maintenir sa dynamique à domicile.',
    ),
    GuineaCalMatch(
      id: 'cal_11',
      tour: 'Journée 3',
      teamA: 'Hafia FC',
      codeA: 'HFC',
      teamB: 'Flamme Olympique',
      codeB: 'FLA',
      date: '09 Nov',
      time: '16:00',
      score: null,
      stadium: 'Stade Petit Sory, Nongo',
      status: 'À venir',
      description: 'Hafia doit s\'imposer pour rester au contact de la première place.',
    ),
    GuineaCalMatch(
      id: 'cal_12',
      tour: 'Journée 3',
      teamA: 'CI Kamsar',
      codeA: 'CIK',
      teamB: 'Satellite FC',
      codeB: 'SFC',
      date: '09 Nov',
      time: '18:00',
      score: null,
      stadium: 'Stade de l\'Amitié, Kamsar',
      status: 'À venir',
      description: 'Opposition serrée entre la rigueur défensive et les ailiers vifs.',
    ),

    // Journée 4
    GuineaCalMatch(
      id: 'cal_13',
      tour: 'Journée 4',
      teamA: 'Wakriya AC',
      codeA: 'WAC',
      teamB: 'Horoya AC',
      codeB: 'HAC',
      date: '12 Nov',
      time: '16:00',
      score: null,
      stadium: 'Stade de l\'Amitié, Kamsar',
      status: 'À venir',
      description: 'Wakriya espère créer l\'exploit face aux Rouge et Blanc.',
    ),
    GuineaCalMatch(
      id: 'cal_14',
      tour: 'Journée 4',
      teamA: 'Satellite FC',
      codeA: 'SFC',
      teamB: 'Hafia FC',
      codeB: 'HFC',
      date: '12 Nov',
      time: '18:15',
      score: null,
      stadium: 'Stade du 28 Septembre, Conakry',
      status: 'À venir',
      description: 'Confrontation classique entre deux formations de Conakry.',
    ),
    GuineaCalMatch(
      id: 'cal_15',
      tour: 'Journée 4',
      teamA: 'Flamme Olympique',
      codeA: 'FLA',
      teamB: 'AS Kaloum',
      codeB: 'ASK',
      date: '13 Nov',
      time: '16:00',
      score: null,
      stadium: 'Stade de la Mission, Kaloum',
      status: 'À venir',
      description: 'Duel indécis au stade de la Mission.',
    ),
    GuineaCalMatch(
      id: 'cal_16',
      tour: 'Journée 4',
      teamA: 'Milo FC Kankan',
      codeA: 'MFC',
      teamB: 'CI Kamsar',
      codeB: 'CIK',
      date: '13 Nov',
      time: '16:00',
      score: null,
      stadium: 'Stade M\'Balou Mady Diakité, Kankan',
      status: 'À venir',
      description: 'Milo FC cherchera à faire respecter sa loi à domicile.',
    ),

    // Matchs Précédents / Résultats (8 matchs)
    GuineaCalMatch(
      id: 'cal_17',
      tour: 'Coupe d\'Ouverture',
      teamA: 'Horoya AC',
      codeA: 'HAC',
      teamB: 'Satellite FC',
      codeB: 'SFC',
      date: 'Hier',
      time: '16:00',
      score: '3 - 0',
      stadium: 'Stade Général Lansana Conté, Nongo',
      status: 'Terminé',
      description: 'Large domination de Horoya avec des réalisations limpides.',
    ),
    GuineaCalMatch(
      id: 'cal_18',
      tour: 'Coupe d\'Ouverture',
      teamA: 'Hafia FC',
      codeA: 'HFC',
      teamB: 'Wakriya AC',
      codeB: 'WAC',
      date: 'Hier',
      time: '18:00',
      score: '2 - 0',
      stadium: 'Stade Petit Sory, Nongo',
      status: 'Terminé',
      description: 'Hafia s\'impose sereinement grâce à deux buts sur coup de pied arrêté.',
    ),
    GuineaCalMatch(
      id: 'cal_19',
      tour: 'Coupe d\'Ouverture',
      teamA: 'AS Kaloum',
      codeA: 'ASK',
      teamB: 'Milo FC Kankan',
      codeB: 'MFC',
      date: '28 Oct',
      time: '16:00',
      score: '1 - 1',
      stadium: 'Stade de la Mission, Kaloum',
      status: 'Terminé',
      description: 'Match intense et engagé ponctué par un partage des points.',
    ),
    GuineaCalMatch(
      id: 'cal_20',
      tour: 'Coupe d\'Ouverture',
      teamA: 'CI Kamsar',
      codeA: 'CIK',
      teamB: 'Flamme Olympique',
      codeB: 'FLA',
      date: '28 Oct',
      time: '16:00',
      score: '2 - 1',
      stadium: 'Stade de l\'Amitié, Kamsar',
      status: 'Terminé',
      description: 'Victoire arrachée au bout du temps additionnel par Kamsar.',
    ),
    GuineaCalMatch(
      id: 'cal_21',
      tour: 'Match Amical',
      teamA: 'Horoya AC',
      codeA: 'HAC',
      teamB: 'AS Kaloum',
      codeB: 'ASK',
      date: '24 Oct',
      time: '16:00',
      score: '2 - 2',
      stadium: 'Stade Général Lansana Conté, Nongo',
      status: 'Terminé',
      description: 'Quatre buts splendides pour chauffer les supporters avant le championnat.',
    ),
    GuineaCalMatch(
      id: 'cal_22',
      tour: 'Match Amical',
      teamA: 'Hafia FC',
      codeA: 'HFC',
      teamB: 'CI Kamsar',
      codeB: 'CIK',
      date: '24 Oct',
      time: '18:00',
      score: '1 - 0',
      stadium: 'Stade Petit Sory, Nongo',
      status: 'Terminé',
      description: 'Courte victoire de Hafia au terme d\'un match équilibré.',
    ),
    GuineaCalMatch(
      id: 'cal_23',
      tour: 'Match Amical',
      teamA: 'Milo FC Kankan',
      codeA: 'MFC',
      teamB: 'Wakriya AC',
      codeB: 'WAC',
      date: '22 Oct',
      time: '16:00',
      score: '3 - 1',
      stadium: 'Stade M\'Balou Mady Diakité, Kankan',
      status: 'Terminé',
      description: 'Belle démonstration collective des joueurs de Kankan.',
    ),
    GuineaCalMatch(
      id: 'cal_24',
      tour: 'Match Amical',
      teamA: 'Satellite FC',
      codeA: 'SFC',
      teamB: 'Flamme Olympique',
      codeB: 'FLA',
      date: '22 Oct',
      time: '16:30',
      score: '0 - 0',
      stadium: 'Stade du 28 Septembre, Conakry',
      status: 'Terminé',
      description: 'Deux défenses intraitables n\'ont laissé aucun espace.',
    ),
  ];

  Future<void> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final fav = prefs.getStringList('fav_matches_gn_cal');
      if (fav != null) {
        _favMatchIds.clear();
        _favMatchIds.addAll(fav);
      }
      final name = prefs.getString('user_name_gn_cal');
      if (name != null) _userName = name;
      final team = prefs.getString('fav_team_gn_cal');
      if (team != null) _favTeam = team;
      notifyListeners();
    } catch (_) {}
  }

  Future<void> _save() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('fav_matches_gn_cal', _favMatchIds.toList());
      await prefs.setString('user_name_gn_cal', _userName);
      await prefs.setString('fav_team_gn_cal', _favTeam);
    } catch (_) {}
  }

  void toggleFavorite(String id) {
    if (_favMatchIds.contains(id)) {
      _favMatchIds.remove(id);
    } else {
      _favMatchIds.add(id);
    }
    _save();
    notifyListeners();
  }

  void updateProfile(String name, String team) {
    _userName = name;
    _favTeam = team;
    _save();
    notifyListeners();
  }

  void resetData() {
    _favMatchIds.clear();
    _userName = 'Supporter Guinée';
    _favTeam = 'Horoya AC';
    _save();
    notifyListeners();
  }
}

