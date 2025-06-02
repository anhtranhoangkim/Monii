import 'package:flutter/material.dart';

class SharedFAB extends StatelessWidget {
  final AnimationController fabController;
  final bool isFabOpen;
  final Function toggleFab;
  final VoidCallback? onRefresh;

  const SharedFAB({
    Key? key,
    required this.fabController,
    required this.isFabOpen,
    required this.toggleFab,
    this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isFabOpen) ...[
          _buildFabOption(
            context,
            Icons.add_card,
            "New Transaction",
            () async {
              final result = await Navigator.pushNamed(context, '/add-transaction');
              if (result == true) {
                onRefresh?.call();
              }
            },
          ),
          _buildFabOption(
            context,
            Icons.category,
            "New Category",
            () async {
              final result = await Navigator.pushNamed(context, '/add-category');
              if (result == true) {
                onRefresh?.call();
              }
            },
          ),
          _buildFabOption(
            context,
            Icons.account_balance_wallet,
            "New Budget",
            () async {
              final result = await Navigator.pushNamed(context, '/add-budget');
              if (result == true) {
                onRefresh?.call();
              }
            },
          ),
          const SizedBox(height: 8),
        ],
        FloatingActionButton(
          onPressed: () => toggleFab(),
          child: AnimatedIcon(
            icon: AnimatedIcons.menu_close,
            progress: fabController,
          ),
        ),
      ],
    );
  }

  Widget _buildFabOption(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onPressed,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: FloatingActionButton.extended(
        heroTag: label,
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 4,
      ),
    );
  }
}