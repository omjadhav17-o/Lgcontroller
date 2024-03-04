import 'package:flutter/material.dart';

class Reusablecard extends StatelessWidget {
  const Reusablecard({super.key, required this.childCard});
  final Widget childCard;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(20),
        ),
        child: childCard,
      ),
    );
  }
}
