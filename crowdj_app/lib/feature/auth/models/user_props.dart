import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_props.freezed.dart';
part 'user_props.g.dart';

enum UserType { PARTICIPANT, DJ }

/// [UserProps] is a data class that contains the properties of a user.
/// It is used to store the user data in a database, joint with the user information from the authentication provider.
@freezed
sealed class UserProps with _$UserProps {
  const factory UserProps({
    required String name,
    required String surname,
    required String email,
    required UserType userType,
  }) = _UserProps;

  factory UserProps.fromJson(Map<String, dynamic> json) =>
      _$UserPropsFromJson(json);
}
