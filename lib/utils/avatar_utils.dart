import 'dart:convert';
import 'package:crypto/crypto.dart';

String getAvatarUrl(String email) {
  var gravatarToken = _getGravatarToken(email);
  var profilePath = 'https://www.gravatar.com/avatar/$gravatarToken?s=200&d=retro';
  return profilePath;
}

String _getGravatarToken(String email) {
  var bytes = utf8.encode(email.trim().toLowerCase());
  return md5.convert(bytes).toString();
}