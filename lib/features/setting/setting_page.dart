import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:meditation_life/core/extension/void_callback_ext.dart';
import 'package:meditation_life/core/res/color.dart';
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
          SnackBar(
            content: Text('${Strings.urlLaunchError}: $url'),
            backgroundColor: AppColor.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);
    final uid = auth.currentUser?.uid ?? '';

    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: const CommonAppBar(title: Strings.settingPageTitle),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Account section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  'アカウント',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColor.textSecondary,
                  ),
                ),
              ),
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
                child: _SettingsTile(
                  title: Strings.accountId(uid),
                  subTitle: Strings.accountIdDescription,
                  iconData: Icons.copy,
                  callback: () {
                    Clipboard.setData(ClipboardData(text: uid));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(Strings.copiedToClipboard(uid)),
                        backgroundColor: AppColor.secondary,
                      ),
                    );
                  },
                ),
              ),

              // Preferences section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  '設定',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColor.textSecondary,
                  ),
                ),
              ),
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
                child: Column(
                  children: [
                    _SettingsTile(
                      title: Strings.notificationSettingLabel,
                      iconData: Icons.notifications_outlined,
                      callback: () => Navigator.push(
                        context,
                        MaterialPageRoute<void>(
                          builder: (context) => const NotificationPage(),
                        ),
                      ),
                    ),
                    const Divider(height: 1, indent: 56),
                    Stack(
                      children: [
                        _SettingsTile(
                          title: Strings.removeAdsLabel,
                          iconData: Icons.block_outlined,
                          callback: () {},
                        ),
                        Positioned.fill(
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: AppColor.primary.withOpacity(0.05),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              Strings.comingSoon,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColor.secondary,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Legal section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  '法的情報',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColor.textSecondary,
                  ),
                ),
              ),
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
                child: Column(
                  children: [
                    _SettingsTile(
                      title: Strings.termsOfServiceLabel,
                      iconData: Icons.description_outlined,
                      callback: () => _launchUrl(context, Strings.termsOfServiceUrl),
                    ),
                    const Divider(height: 1, indent: 56),
                    _SettingsTile(
                      title: Strings.privacyPolicyLabel,
                      iconData: Icons.privacy_tip_outlined,
                      callback: () => _launchUrl(context, Strings.privacyPolicyUrl),
                    ),
                    const Divider(height: 1, indent: 56),
                    _SettingsTile(
                      title: Strings.contactLabel,
                      iconData: Icons.mail_outline,
                      callback: () => _launchUrl(context, Strings.contactUrl),
                    ),
                  ],
                ),
              ),

              // App info
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 24, bottom: 8),
                  child: Text(
                    Strings.appVersion(PackageInfoInstance.version),
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: AppColor.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),

              // Delete account
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: TextButton.icon(
                    onPressed: () => _launchUrl(context, Strings.dataDeleteUrl),
                    icon: const Icon(Icons.delete_forever, color: AppColor.error),
                    label: Text(
                      Strings.deleteAccountLabel,
                      style: const TextStyle(
                        color: AppColor.error,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 設定画面の各項目を表示するためのタイル
class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.title,
    this.subTitle,
    required this.iconData,
    required this.callback,
  });

  final String title;
  final String? subTitle;
  final IconData iconData;
  final VoidCallback callback;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: callback.withFeedback(),
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        child: Row(
          children: [
            Icon(
              iconData,
              color: AppColor.secondary,
              size: 24,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColor.textPrimary,
                    ),
                  ),
                  if (subTitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subTitle!,
                      style: TextStyle(
                        color: AppColor.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppColor.textSecondary.withOpacity(0.5),
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
