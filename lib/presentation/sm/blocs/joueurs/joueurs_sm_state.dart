import 'package:equatable/equatable.dart';
import 'package:gamemaster_hub/domain/sm/entities/joueur_sm.dart';
import 'package:gamemaster_hub/domain/sm/entities/stats_joueur_sm.dart';

class JoueurSmWithStats {
  final JoueurSm joueur;
  final StatsJoueurSm? stats;

  JoueurSmWithStats({
    required this.joueur,
    this.stats,
  });
}

abstract class JoueursSmState extends Equatable {
  const JoueursSmState();

  @override
  List<Object?> get props => [];
}

class JoueursSmInitial extends JoueursSmState {}

class JoueursSmLoading extends JoueursSmState {}

class JoueursSmLoaded extends JoueursSmState {
  final List<JoueurSmWithStats> joueurs;
  final String selectedPosition;
  final String searchQuery;

  const JoueursSmLoaded({
    required this.joueurs,
    this.selectedPosition = 'Tous les postes',
    this.searchQuery = '',
  });

  List<JoueurSmWithStats> get filteredJoueurs {
    return joueurs.where((item) {
      final matchesPosition = selectedPosition == 'Tous les postes' ||
          _matchesPosition(item.joueur, selectedPosition);
      final matchesSearch = searchQuery.isEmpty ||
          item.joueur.nom.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesPosition && matchesSearch;
    }).toList();
  }

  bool _matchesPosition(JoueurSm joueur, String position) {
    final filters = _getPositionFilter(position);
    return filters.any((pos) => joueur.postes.any((p) => p.name == pos));
  }

  List<String> _getPositionFilter(String position) {
    switch (position) {
      case 'Gardien':
        return ['GK'];
      case 'Défenseur':
        return ['DC', 'DG', 'DD', 'DOG', 'DOD'];
      case 'Milieu':
        return ['MC', 'MDC', 'MOC', 'MD', 'MG'];
      case 'Attaquant':
        return ['BU', 'MOD', 'MOG'];
      default:
        return [];
    }
  }

  JoueursSmLoaded copyWith({
    List<JoueurSmWithStats>? joueurs,
    String? selectedPosition,
    String? searchQuery,
  }) {
    return JoueursSmLoaded(
      joueurs: joueurs ?? this.joueurs,
      selectedPosition: selectedPosition ?? this.selectedPosition,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [joueurs, selectedPosition, searchQuery];
}

class JoueursSmError extends JoueursSmState {
  final String message;

  const JoueursSmError(this.message);

  @override
  List<Object?> get props => [message];
}
