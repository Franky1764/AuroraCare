// domain/usecases/usecase.dart

/// Contrato genérico para todo caso de uso del sistema.
/// [ReturnType] es lo que devuelve (ej: Session, void).
/// [Params] es lo que necesita para ejecutarse (ej: los datos de una sesión nueva).
abstract class UseCase<ReturnType, Params> {
  Future<ReturnType> call(Params params);
}

/// Para los casos de uso que no necesitan ningún dato de entrada
/// (ej: "cerrar sesión", "obtener mi perfil actual").
class NoParams {
  const NoParams();
}