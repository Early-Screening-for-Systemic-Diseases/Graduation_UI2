import 'package:flutter_riverpod/flutter_riverpod.dart';

// ── Bottom navigation index (patient nav bar) ─────────────────────────────────
final navIndexProvider = StateProvider<int>((ref) => 0);

// ── Favorites ─────────────────────────────────────────────────────────────────
// Stores timestamps (ISO strings) of favorited analysis results.
// Pure UI/session state — not persisted to Firestore.
class FavoritesNotifier extends StateNotifier<Set<String>> {
  FavoritesNotifier() : super({});

  void toggle(String id) {
    if (state.contains(id)) {
      state = {...state}..remove(id);
    } else {
      state = {...state, id};
    }
  }

  bool isFavorite(String id) => state.contains(id);
}

final favoritesProvider =
    StateNotifierProvider<FavoritesNotifier, Set<String>>(
  (ref) => FavoritesNotifier(),
);

// ── Dismissed analysis results ────────────────────────────────────────────────
// Stores timestamps of results hidden by swipe-to-dismiss.
// Cleared when user navigates away / restarts.
final dismissedResultsProvider = StateProvider<Set<String>>((ref) => {});

// ── Dismissed chat contacts ───────────────────────────────────────────────────
// Stores user IDs hidden from the chat list by swipe-to-dismiss.
final dismissedChatsProvider = StateProvider<Set<String>>((ref) => {});
