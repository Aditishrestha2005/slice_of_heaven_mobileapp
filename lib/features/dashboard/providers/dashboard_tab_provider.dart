import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for dashboard tab index. Used to switch tabs (e.g. after checkout success).
final dashboardTabIndexProvider = StateProvider<int>((ref) => 0);
