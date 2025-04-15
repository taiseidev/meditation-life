import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meditation_life/core/extension/void_callback_ext.dart';
import 'package:meditation_life/core/utils/package_info_util.dart';
import 'package:meditation_life/core/utils/strings.dart';
import 'package:meditation_life/features/notification/notification_page.dart';
import 'package:meditation_life/shared/widgets/common_app_bar.dart';
import 'package:url_launcher/url_launcher.dart';

/// 認証サービスを提供するプロバイダー
final authProvider = Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

class SettingPage extends ConsumerWidget {
  const SettingPage({super.key});

  /// URLを開く
  Future<void> _launchUrl(BuildContext context, String url) async {
    try {
      if (!await launchUrl(Uri.parse(url))) {
        throw Exception('Could not launch $url');
      }
    } on Exception catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${Strings.urlLaunchError}: $url')),
        );
      }
    }
  }

  /// 太字のテキストスタイルを作成
  TextStyle _buildBoldTextStyle() {
    return const TextStyle(
      fontWeight: FontWeight.bold,
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final uid = auth.currentUser?.uid ?? '';

    return Scaffold(
      backgroundColor: Colors.white.withOpacity(0.95),
      appBar: const CommonAppBar(title: Strings.settingPageTitle),
      body: Column(
        children: [
          _SettingsTile(
            title: Strings.accountId(uid),
            subTitle: Strings.accountIdDescription,
            iconData: Icons.copy,
            callback: () {
              Clipboard.setData(ClipboardData(text: uid));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(Strings.copiedToClipboard(uid)),
                ),
              );
            },
          ),
          _SettingsTile(
            title: Strings.notificationSettingLabel,
            callback: () => Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (context) => const NotificationPage(),
              ),
            ),
          ),
          _SettingsTile(
            title: Strings.termsOfServiceLabel,
            callback: () => _launchUrl(context, Strings.termsOfServiceUrl),
          ),
          _SettingsTile(
            title: Strings.privacyPolicyLabel,
            callback: () => _launchUrl(context, Strings.privacyPolicyUrl),
          ),
          _SettingsTile(
            title: Strings.contactLabel,
            callback: () => _launchUrl(context, Strings.contactUrl),
          ),
          Stack(
            children: [
              _SettingsTile(
                title: Strings.removeAdsLabel,
                callback: () {},
              ),
              Positioned.fill(
                child: Container(
                  alignment: Alignment.center,
                  color: Colors.grey.withOpacity(0.3),
                  child: Text(
                    Strings.comingSoon,
                    style: _buildBoldTextStyle(),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 24),
            child: Align(
              child: Text(
                Strings.appVersion(PackageInfoInstance.version),
                style: _buildBoldTextStyle(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 24),
            child: TextButton(
              onPressed: () => _launchUrl(context, Strings.dataDeleteUrl),
              child: Text(
                Strings.deleteAccountLabel,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// 設定画面の各項目を表示するためのタイル
class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.title,
    this.subTitle,
    this.iconData = Icons.chevron_right,
    required this.callback,
  });

  final String title;
  final String? subTitle;
  final IconData iconData;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.grey[200]!,
          ),
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: _buildSubtitle(),
        trailing: Icon(iconData),
        onTap: callback.withFeedback(),
      ),
    );
  }

  /// サブタイトルを構築する
  Widget _buildSubtitle() {
    if (subTitle == null) {
      return const SizedBox.shrink();
    }

    return Text(
      subTitle!,
      style: const TextStyle(
        color: Colors.grey,
        fontSize: 11,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
