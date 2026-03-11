// This file remains for backwards compatibility. The old GameHistoryItem
// has been superseded by [BetHistoryItem] which includes additional
// metadata. To avoid breaking existing imports, a typedef is used.

import 'bet_history.dart';

/// Backwards compatible alias for [BetHistoryItem].
typedef GameHistoryItem = BetHistoryItem;
