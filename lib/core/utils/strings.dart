class Strings {
  const Strings._();

  // common
  static const appTitle = '瞑想ライフ';
  static const updateLabel = '変更';
  static const closeLabel = '閉じる';

  // meditation_history_page
  static const meditationHistoryTitle = '瞑想履歴';
  static const monthlyMeditationProgress = '月の瞑想進捗';

  // meditation_detail_page
  static const meditationStartButtonLabel = '瞑想を開始する';

  // setting_page
  static const settingPageTitle = '設定';
  static const notificationSettingLabel = '通知設定';
  static const soundSettingLabel = 'サウンド設定';
  static const termsOfServiceLabel = '利用規約';
  static const privacyPolicyLabel = 'プライバシーポリシー';
  static const contactLabel = 'お問い合わせ';

  static const termsOfServiceUrl =
      'https://ionian-earthworm-71d.notion.site/4b44e3fb3e5a4133875b18cab6e75e07?pvs=4';
  static const privacyPolicyUrl =
      'https://ionian-earthworm-71d.notion.site/67d9545c307748fc8e0bdd67ed852900?pvs=4';
  static const contactUrl = 'https://forms.gle/zbWgULaGxh46jfyF7';

  static String appVersion(String version) => 'ver $version';

  // sound_setting_page
  static const volumeLabel = '音量';
  static const vibrationLabel = 'バイブレーション';

  // notification_page
  static const notificationToggleLabel = '通知オン/オフ';
  static const notificationTimeLabel = '通知時間';

  // notification_service
  static const notificationMessage = '本日の瞑想を行いましょう！';
}
