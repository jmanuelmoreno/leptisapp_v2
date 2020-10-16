
class LeptisUser {
  LeptisUser({
    this.username,
    this.password,
    this.displayName,
    this.email,
    this.avatarUrl,
    this.sessionToken,
    this.rol
  });

  final String username;
  final String password;
  final String sessionToken;
  String displayName;
  String email;
  String avatarUrl;
  String rol;

  @override
  String toString() {
    return '''LeptisUser {
      sessionToken: $sessionToken, 
      username: $username, 
      password: $password, 
      displayName: $displayName, 
      email: $email,
      avatarUrl: $avatarUrl,
      rol: $rol
    }''';
  }

}