import 'package:flutter/material.dart';

@immutable
class HomeNavigationDestination {
  const HomeNavigationDestination({required this.icon, required this.label});

  final IconData icon;
  final String label;
}
