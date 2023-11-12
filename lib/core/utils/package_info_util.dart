import 'package:package_info_plus/package_info_plus.dart';

class PackageInfoInstance {
  factory PackageInfoInstance() => _instance;
  PackageInfoInstance._internal();
  static final PackageInfoInstance _instance = PackageInfoInstance._internal();

  static late final PackageInfo _packageInfo;

  static Future<void> init() async {
    _packageInfo = await PackageInfo.fromPlatform();
  }

  static String get appName => _packageInfo.appName;
  static String get version => _packageInfo.version;
  static String get buildNumber => _packageInfo.buildNumber;
  static String get packageName => _packageInfo.packageName;
  static String get buildSignature => _packageInfo.buildSignature;
}
