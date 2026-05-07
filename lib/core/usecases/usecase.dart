// Every use case does exactly ONE thing.
// T = return type, P = params type.
// If a use case needs no input, use NoParams.
abstract class UseCase<T, P> {
  Future<T> call(P params);
}

class NoParams {}
