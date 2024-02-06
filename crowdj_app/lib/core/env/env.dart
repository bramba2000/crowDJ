import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(useConstantCase: true)
abstract class Env {
  @EnviedField(obfuscate: true)
  static final String spotifyClientId = _Env.spotifyClientId;
  @EnviedField(obfuscate: true)
  static final String spotifyClientSecret = _Env.spotifyClientSecret;
  @EnviedField(obfuscate: true, varName: 'GEOAPI_TOKEN')
  static final String geoAPIToken = _Env.geoAPIToken;
  @EnviedField(obfuscate: false)
  static final String host = _Env.host;
}
