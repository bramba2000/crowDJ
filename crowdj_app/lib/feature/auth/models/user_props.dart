import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_props.freezed.dart';
part 'user_props.g.dart';

enum UserType { participant, dj }

sealed class UserPropsBase {
  String get name;
  String get surname;
  String get email;
  UserType get userType;
}

/// [UserProps] is a data class that contains the properties of a user.
/// It is used to store the user data in a database, joint with the user information from the authentication provider.
@freezed
sealed class UserProps with _$UserProps {
  @Implements<UserPropsBase>()
  const factory UserProps({
    required String name,
    required String surname,
    required String email,
    required UserType userType,
  }) = _UserProps;

  @Implements<UserPropsBase>()
  @Assert('spotifyAuthenticated != true || refreshToken != null',
      'The refresh token must be provided if the user is authenticated with Spotify')
  const factory UserProps.dj({
    required String name,
    required String surname,
    required String email,
    required UserType userType,
    bool? spotifyAuthenticated,
    String? refreshToken,
  }) = DjUserProps;

  factory UserProps.fromJson(Map<String, dynamic> json) =>
      _$UserPropsFromJson(json);
}
