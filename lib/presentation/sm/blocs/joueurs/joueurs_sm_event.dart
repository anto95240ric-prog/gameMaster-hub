import 'package:equatable/equatable.dart';
import 'package:gamemaster_hub/domain/sm/entities/joueur_sm.dart';

abstract class JoueursSmEvent extends Equatable {
  const JoueursSmEvent();

  @override
  List<Object?> get props => [];
}

class LoadJoueursSmEvent extends JoueursSmEvent {}

class AddJoueurSmEvent extends JoueursSmEvent {
  final JoueurSm joueur;

  const AddJoueurSmEvent(this.joueur);

  @override
  List<Object?> get props => [joueur];
}

class UpdateJoueurSmEvent extends JoueursSmEvent {
  final JoueurSm joueur;
  final Map<String, int> stats;

  const UpdateJoueurSmEvent(this.joueur, this.stats);

  @override
  List<Object?> get props => [joueur, stats];
}

class DeleteJoueurSmEvent extends JoueursSmEvent {
  final int joueurId;

  const DeleteJoueurSmEvent(this.joueurId);

  @override
  List<Object?> get props => [joueurId];
}

class FilterJoueursSmEvent extends JoueursSmEvent {
  final String position;
  final String searchQuery;

  const FilterJoueursSmEvent({
    required this.position,
    required this.searchQuery,
  });

  @override
  List<Object?> get props => [position, searchQuery];
}
