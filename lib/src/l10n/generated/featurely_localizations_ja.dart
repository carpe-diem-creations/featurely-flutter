// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'featurely_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class FeaturelyLocalizationsJa extends FeaturelyLocalizations {
  FeaturelyLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get sdkListTitle => 'フィードバック';

  @override
  String get sdkListNewFeedback => '新しいフィードバック';

  @override
  String sdkListEmpty(String appName) {
    return 'まだ投稿はありません。$appNameに次に何をしてほしいか、最初に教えてください';
  }

  @override
  String get sdkListLoadError => 'フィードバックを読み込めませんでした。接続をご確認ください。';

  @override
  String sdkListVotes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count票',
    );
    return '$_temp0';
  }

  @override
  String sdkListComments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count件のコメント',
    );
    return '$_temp0';
  }

  @override
  String get sdkFilterTitle => '絞り込みと並べ替え';

  @override
  String get sdkFilterSortBy => '並べ替え';

  @override
  String get sdkFilterSortMostVoted => '投票数順';

  @override
  String get sdkFilterSortNewest => '新しい順';

  @override
  String get sdkFilterSortOldest => '古い順';

  @override
  String get sdkFilterStatus => 'ステータス';

  @override
  String get sdkFilterStatusAll => 'すべて';

  @override
  String get sdkFilterReset => 'リセット';

  @override
  String sdkFilterShowResults(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count件のリクエストを表示',
    );
    return '$_temp0';
  }

  @override
  String sdkFilterShowResultsOverflow(int count) {
    return '$count件以上のリクエストを表示';
  }

  @override
  String get sdkStatusOpen => '受付中';

  @override
  String get sdkStatusPlanned => '対応予定';

  @override
  String get sdkStatusInProgress => '対応中';

  @override
  String get sdkStatusDone => '完了';

  @override
  String get sdkFormTypeLabel => '種類';

  @override
  String get sdkFormTypeFeature => '機能';

  @override
  String get sdkFormTypeIssue => '不具合';

  @override
  String get sdkFormTitleLabel => 'タイトル';

  @override
  String get sdkFormTitlePlaceholder => 'ひとことでまとめてください';

  @override
  String sdkFormTitleCounter(int remaining) {
    String _temp0 = intl.Intl.pluralLogic(
      remaining,
      locale: localeName,
      other: '残り$remaining文字',
    );
    return '$_temp0';
  }

  @override
  String get sdkFormDescriptionLabel => '説明';

  @override
  String sdkFormDescriptionPlaceholderFeature(String appName) {
    return '$appNameにどんな機能があるといいですか？';
  }

  @override
  String sdkFormDescriptionPlaceholderIssue(String appName) {
    return '$appNameで何が起きましたか？';
  }

  @override
  String get sdkFormEmailLabel => 'メールアドレス';

  @override
  String get sdkFormEmailHelper =>
      '任意です。チームから返信があった場合や、ご要望がリリースされた際にメールでお知らせします。';

  @override
  String get sdkFormAddScreenshot => 'スクリーンショットを追加';

  @override
  String get sdkFormRemoveScreenshot => 'スクリーンショットを削除';

  @override
  String get sdkFormSubmit => '送信';

  @override
  String get sdkFormSending => '送信中…';

  @override
  String get sdkFormSubmitError =>
      '送信できませんでした。下書きは保存されています。接続を確認して、もう一度お試しください。';

  @override
  String get sdkFormTryAgain => 'もう一度試す';

  @override
  String get sdkSuccessTitle => 'ありがとうございます！すべての投稿に目を通しています。';

  @override
  String sdkSuccessBody(String appName) {
    return 'フィードバックは$appNameチームに直接届きました。';
  }

  @override
  String get sdkSuccessBack => 'フィードバック一覧に戻る';

  @override
  String sdkDetailSubmitted(String date) {
    return '$dateに投稿';
  }

  @override
  String get sdkDetailVote => '投票';

  @override
  String sdkDetailVoted(int count) {
    return '投票済み · $count';
  }

  @override
  String get sdkDetailCommentsTitle => 'コメント';

  @override
  String get sdkDetailCommentPlaceholder => 'コメントを追加…';

  @override
  String get sdkDetailCommentSend => '送信';

  @override
  String get sdkDetailAnonymous => '匿名';

  @override
  String get sdkDetailTeamBadge => 'チーム';

  @override
  String get sdkCommonClose => '閉じる';

  @override
  String get sdkCommonCancel => 'キャンセル';

  @override
  String get sdkCommonRetry => '再試行';

  @override
  String get sdkSandboxBadge => 'SANDBOX';

  @override
  String get sdkFormAttachError => 'この画像を添付できませんでした。別の画像をお試しください。';

  @override
  String get sdkFormEmailError => '有効なメールアドレスを入力してください。';

  @override
  String get sdkDetailCommentsDisabled => 'コメントは無効になっています。';

  @override
  String get sdkCommonRateLimited => 'リクエストが多すぎます。しばらくしてからもう一度お試しください。';

  @override
  String get sdkChatComposerPlaceholder => 'メッセージを入力…';

  @override
  String get sdkChatEmailEdit => '編集';

  @override
  String get sdkChatEmailInvalid => '有効なメールアドレスを入力してください。';

  @override
  String get sdkChatEmailPlaceholder => 'メールアドレス';

  @override
  String get sdkChatEmailPrompt => '返信をメールで受け取る';

  @override
  String get sdkChatEmailSave => '保存';

  @override
  String get sdkChatEmailSaved => '返信先メールアドレス';

  @override
  String get sdkChatEmptyGreeting => 'こんにちは！メッセージをお送りください。チームがこちらでお返事します。';

  @override
  String get sdkChatLoadEarlier => '以前のメッセージを読み込む';

  @override
  String get sdkChatMessageUs => 'お問い合わせ';

  @override
  String get sdkChatNotSentRetry => '送信できませんでした — タップして再試行';

  @override
  String get sdkChatSend => '送信';

  @override
  String get sdkChatSending => '送信中…';

  @override
  String get sdkChatTeamLabel => 'チーム';

  @override
  String get sdkChatTitle => 'メッセージ';

  @override
  String sdkChatTooLong(int max) {
    return 'メッセージが長すぎます。上限は$max文字です。';
  }
}
