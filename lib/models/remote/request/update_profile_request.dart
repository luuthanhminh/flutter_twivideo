/// Login in request form data
class UpdateProfileRequest {
  UpdateProfileRequest({this.username, this.email, this.ageIndex, this.avatar});

  final String username;
  final String email;
  final int ageIndex;
  final String avatar;

  @override
  String toString() {
    return 'LogInRequest{username: $username, password: $email, ageIndex: $ageIndex, avatar: $avatar';
  }
}
