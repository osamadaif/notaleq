/// Failure hierarchy used across the data/domain boundary.
///
/// Calculation data stays local, while the ads layer can also report network
/// and ad-serving failures.
///
/// Repositories return `Either<Failures, T>` (fpdart); the left side is always
/// one of these.
sealed class Failures {
  const Failures(this.message);

  /// Human-facing message key or text. Prefer an `AppLocalizations` key so the
  /// presentation layer can localise it.
  final String message;

  @override
  String toString() => '$runtimeType($message)';
}

/// A local SQLite / drift operation failed (read, write, migration, etc.).
class DatabaseFailure extends Failures {
  const DatabaseFailure(super.message);
}

/// Input failed a domain rule (e.g. an incomplete expression, an empty name).
class ValidationFailure extends Failures {
  const ValidationFailure(super.message);
}

/// A requested record was not found (e.g. loading a deleted sheet).
class NotFoundFailure extends Failures {
  const NotFoundFailure(super.message);
}

/// No network interface is currently available for an ad-backed export.
class NetworkFailure extends Failures {
  const NetworkFailure(super.message);
}

/// A rewarded ad could not be loaded or shown.
class AdLoadFailure extends Failures {
  const AdLoadFailure(super.message);
}

/// The rewarded ad closed before the reward callback was received.
class AdDismissedFailure extends Failures {
  const AdDismissedFailure(super.message);
}

/// Anything genuinely unexpected — keep rare; prefer a specific failure.
class UnexpectedFailure extends Failures {
  const UnexpectedFailure(super.message);
}
