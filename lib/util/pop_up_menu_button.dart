import 'package:flutter/material.dart';

class PopUpMenu extends StatelessWidget {
  final VoidCallback onDelete;
  const PopUpMenu({
    super.key,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: const Icon(
        Icons.more_horiz,
        color: Colors.white,
      ),
      itemBuilder: (context) => [
        PopupMenuItem<int>(
          value: 0,
          height: 5,
          onTap: onDelete,
          child: const Center(
            child: Text(
              'Delete',
              style: TextStyle(fontSize: 17),
            ),
          ),
        )
      ],
    );
  }
}
