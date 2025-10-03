import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gamemaster_hub/presentation/sm/blocs/joueurs/joueurs_sm_bloc.dart';
import 'package:gamemaster_hub/presentation/sm/blocs/joueurs/joueurs_sm_event.dart';
import 'package:gamemaster_hub/presentation/sm/blocs/joueurs/joueurs_sm_state.dart';
import 'package:gamemaster_hub/presentation/sm/widgets/add_player_dialog.dart';
import 'package:gamemaster_hub/presentation/sm/widgets/player_card_widget.dart';
import 'package:gamemaster_hub/presentation/sm/widgets/player_details_dialog.dart';

class SMPlayersTab extends StatelessWidget {
  const SMPlayersTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<JoueursSmBloc, JoueursSmState>(
      builder: (context, state) {
        if (state is JoueursSmLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state is JoueursSmError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Erreur: ${state.message}'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    context.read<JoueursSmBloc>().add(LoadJoueursSmEvent());
                  },
                  child: const Text('Réessayer'),
                ),
              ],
            ),
          );
        }

        if (state is JoueursSmLoaded) {
          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 24),
                _buildFilters(context, state),
                const SizedBox(height: 24),
                Expanded(child: _buildPlayersGrid(context, state)),
              ],
            ),
          );
        }

        return const Center(child: Text('État inconnu'));
      },
    );
  }

  Widget _buildHeader(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final titleStyle = Theme.of(context).textTheme.displayMedium?.copyWith(
          fontSize: screenWidth < 600 ? 20 : 32,
        );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Gestion des Joueurs',
          style: titleStyle,
        ),
        ElevatedButton.icon(
          onPressed: () => _showAddPlayerDialog(context),
          icon: const Icon(Icons.add),
          label: const Text('Ajouter'),
        ),
      ],
    );
  }

  void _showAddPlayerDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<JoueursSmBloc>(),
        child: const AddPlayerDialog(),
      ),
    );
  }

  Widget _buildFilters(BuildContext context, JoueursSmLoaded state) {
    return Row(
      children: [
        Expanded(
          child: DropdownButtonFormField<String>(
            value: state.selectedPosition,
            decoration: const InputDecoration(
              labelText: 'Position',
              border: OutlineInputBorder(),
            ),
            items: ['Tous les postes', 'Gardien', 'Défenseur', 'Milieu', 'Attaquant']
                .map((position) => DropdownMenuItem(
                      value: position,
                      child: Text(position),
                    ))
                .toList(),
            onChanged: (value) {
              context.read<JoueursSmBloc>().add(
                    FilterJoueursSmEvent(
                      position: value!,
                      searchQuery: state.searchQuery,
                    ),
                  );
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: TextField(
            decoration: const InputDecoration(
              labelText: 'Rechercher...',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (value) {
              context.read<JoueursSmBloc>().add(
                    FilterJoueursSmEvent(
                      position: state.selectedPosition,
                      searchQuery: value,
                    ),
                  );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPlayersGrid(BuildContext context, JoueursSmLoaded state) {
    final filteredPlayers = state.filteredJoueurs;

    if (filteredPlayers.isEmpty) {
      return const Center(
        child: Text('Aucun joueur trouvé'),
      );
    }

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 315,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 2.5,
      ),
      itemCount: filteredPlayers.length,
      itemBuilder: (context, index) {
        final item = filteredPlayers[index];
        return PlayerCardWidget(
          item: item,
          onTap: () => _showPlayerDetails(context, item),
        );
      },
    );
  }

  void _showPlayerDetails(BuildContext context, JoueurSmWithStats item) {
    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<JoueursSmBloc>(),
        child: PlayerDetailsDialog(item: item),
      ),
    );
  }
}
