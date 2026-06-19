/// Failure hierarchy used across the data/domain boundary.
///
/// Notaleq is **local-only** — there is no network layer — so there are no
/// `ServerFailure` / `DioException` style failures. Everything that can go wrong
/// is either a local database problem or a validation problem.
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

/// Anything genuinely unexpected — keep rare; prefer a specific failure.
class UnexpectedFailure extends Failures {
  const UnexpectedFailure(super.message);
}
