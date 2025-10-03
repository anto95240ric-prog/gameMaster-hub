import 'package:flutter/material.dart';
import 'package:gamemaster_hub/domain/sm/entities/joueur_sm.dart';
import 'package:gamemaster_hub/domain/sm/entities/stats_joueur_sm.dart';
import 'package:gamemaster_hub/presentation/sm/blocs/joueurs/joueurs_sm_state.dart';

class PlayerCardWidget extends StatelessWidget {
  final JoueurSmWithStats item;
  final VoidCallback onTap;

  const PlayerCardWidget({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final joueur = item.joueur;

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    child: Text(
                      joueur.nom[0],
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          joueur.nom,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          '${joueur.postes.map((e) => e.name).join("/")} • \n${joueur.age} ans • ${joueur.dureeContrat}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  _buildRatingBadge(context, joueur.niveauActuel),
                  const SizedBox(width: 8),
                  _buildRatingBadge(context, joueur.potentiel),
                ],
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    joueur.status.name,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  Text(
                    '€${joueur.montantTransfert}M',
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRatingBadge(BuildContext context, int rating) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _getRatingColor(rating).withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        rating.toString(),
        style: TextStyle(
          color: _getRatingColor(rating),
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _getRatingColor(int rating) {
    if (rating >= 85) return Colors.green;
    if (rating >= 80) return Colors.blue;
    return Colors.orange;
  }
}
