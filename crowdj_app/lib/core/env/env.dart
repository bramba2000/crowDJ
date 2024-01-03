import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(useConstantCase: true)
abstract class Env {
  @EnviedField(obfuscate: true)
  static final String spotifyClientId = _Env.spotifyClientId;
  @EnviedField(obfuscate: true)
  static final String spotifyClientSecret = _Env.spotifyClientSecret;
}
