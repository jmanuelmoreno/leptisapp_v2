import 'dart:async';
import 'package:package_info/package_info.dart';

class AppInfo {
  static const String APP_VERSION = "app_version";
  static const String APP_BUILD_NUMBER = "app_build";
  static const String APP_NAME = "app_name";
  static const String APP_PACKAGE_NAME = "app_packagename";

  static Future<Map<String, String>> getAppInfo() async {
    Map<String, String> info = {};

    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    info[APP_VERSION] = packageInfo.version;
    info[APP_BUILD_NUMBER] = packageInfo.buildNumber;
    info[APP_NAME] = packageInfo.appName;
    info[APP_PACKAGE_NAME] = packageInfo.packageName;

    return info;
  }
}

