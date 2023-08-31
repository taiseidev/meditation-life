import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

final packageInfoProvider = Provider<PackageInfo>(
  (ref) => throw UnimplementedError(),
);

final packageInfoUtilProvider = Provider<PackageInfoUtil>(
  (ref) => PackageInfoUtil(ref.read(packageInfoProvider)),
);

class PackageInfoUtil {
  PackageInfoUtil(this._packageInfo);
  final PackageInfo _packageInfo;

  String get appName => _packageInfo.appName;
  String get version => _packageInfo.version;
  String get buildNumber => _packageInfo.buildNumber;
  String get packageName => _packageInfo.packageName;
  String get buildSignature => _packageInfo.buildSignature;
}
