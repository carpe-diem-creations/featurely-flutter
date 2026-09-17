// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'featurely_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class FeaturelyLocalizationsTr extends FeaturelyLocalizations {
  FeaturelyLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get sdkListTitle => 'Geri bildirim';

  @override
  String get sdkListNewFeedback => 'Yeni geri bildirim';

  @override
  String sdkListEmpty(String appName) {
    return 'Henüz burada bir şey yok — $appName bundan sonra ne yapmalı, ilk söyleyen sen ol';
  }

  @override
  String get sdkListLoadError =>
      'Geri bildirimler yüklenemedi. Bağlantını kontrol et.';

  @override
  String sdkListVotes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count oy',
      one: '$count oy',
    );
    return '$_temp0';
  }

  @override
  String sdkListComments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count yorum',
      one: '$count yorum',
    );
    return '$_temp0';
  }

  @override
  String get sdkFilterTitle => 'Filtrele ve sırala';

  @override
  String get sdkFilterSortBy => 'Sıralama';

  @override
  String get sdkFilterSortMostVoted => 'En çok oy alan';

  @override
  String get sdkFilterSortNewest => 'En yeni';

  @override
  String get sdkFilterSortOldest => 'En eski';

  @override
  String get sdkFilterStatus => 'Durum';

  @override
  String get sdkFilterStatusAll => 'Tümü';

  @override
  String get sdkFilterReset => 'Sıfırla';

  @override
  String sdkFilterShowResults(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count isteği göster',
      one: '$count isteği göster',
    );
    return '$_temp0';
  }

  @override
  String sdkFilterShowResultsOverflow(int count) {
    return '$count+ isteği göster';
  }

  @override
  String get sdkStatusOpen => 'Açık';

  @override
  String get sdkStatusPlanned => 'Planlandı';

  @override
  String get sdkStatusInProgress => 'Devam ediyor';

  @override
  String get sdkStatusDone => 'Tamamlandı';

  @override
  String get sdkFormTypeLabel => 'Tür';

  @override
  String get sdkFormTypeFeature => 'Özellik';

  @override
  String get sdkFormTypeIssue => 'Sorun';

  @override
  String get sdkFormTitleLabel => 'Başlık';

  @override
  String get sdkFormTitlePlaceholder => 'Birkaç kelimeyle özetle';

  @override
  String sdkFormTitleCounter(int remaining) {
    String _temp0 = intl.Intl.pluralLogic(
      remaining,
      locale: localeName,
      other: '$remaining karakter kaldı',
      one: '$remaining karakter kaldı',
    );
    return '$_temp0';
  }

  @override
  String get sdkFormDescriptionLabel => 'Açıklama';

  @override
  String sdkFormDescriptionPlaceholderFeature(String appName) {
    return '$appName ne yapmalı?';
  }

  @override
  String sdkFormDescriptionPlaceholderIssue(String appName) {
    return '$appName içinde ne ters gitti?';
  }

  @override
  String get sdkFormEmailLabel => 'E-posta';

  @override
  String get sdkFormEmailHelper =>
      'İsteğe bağlı. Ekip yanıt verdiğinde veya isteğin hayata geçtiğinde sana e-posta göndereceğiz.';

  @override
  String get sdkFormAddScreenshot => 'Ekran görüntüsü ekle';

  @override
  String get sdkFormRemoveScreenshot => 'Ekran görüntüsünü kaldır';

  @override
  String get sdkFormSubmit => 'Gönder';

  @override
  String get sdkFormSending => 'Gönderiliyor…';

  @override
  String get sdkFormSubmitError =>
      'Gönderilemedi. Taslağın kaydedildi. Bağlantını kontrol edip tekrar dene.';

  @override
  String get sdkFormTryAgain => 'Tekrar dene';

  @override
  String get sdkSuccessTitle => 'Teşekkürler! Bunların her birini okuyoruz.';

  @override
  String sdkSuccessBody(String appName) {
    return 'Geri bildirimin doğrudan $appName ekibine ulaştı.';
  }

  @override
  String get sdkSuccessBack => 'Geri bildirimlere dön';

  @override
  String sdkDetailSubmitted(String date) {
    return 'Gönderildi: $date';
  }

  @override
  String get sdkDetailVote => 'Oy ver';

  @override
  String sdkDetailVoted(int count) {
    return 'Oy verildi · $count';
  }

  @override
  String get sdkDetailCommentsTitle => 'Yorumlar';

  @override
  String get sdkDetailCommentPlaceholder => 'Yorum ekle…';

  @override
  String get sdkDetailCommentSend => 'Gönder';

  @override
  String get sdkDetailAnonymous => 'Anonim';

  @override
  String get sdkDetailTeamBadge => 'Ekip';

  @override
  String get sdkCommonClose => 'Kapat';

  @override
  String get sdkCommonCancel => 'İptal';

  @override
  String get sdkCommonRetry => 'Tekrar dene';

  @override
  String get sdkSandboxBadge => 'SANDBOX';

  @override
  String get sdkFormAttachError => 'Bu görsel eklenemedi. Başka bir tane dene.';

  @override
  String get sdkFormEmailError => 'Geçerli bir e-posta adresi gir.';

  @override
  String get sdkDetailCommentsDisabled => 'Yorumlar kapatıldı.';

  @override
  String get sdkCommonRateLimited => 'Çok fazla istek. Birazdan tekrar dene.';

  @override
  String get sdkChatComposerPlaceholder => 'Bir mesaj yaz…';

  @override
  String get sdkChatEmailEdit => 'Düzenle';

  @override
  String get sdkChatEmailInvalid => 'Geçerli bir e-posta adresi gir.';

  @override
  String get sdkChatEmailPlaceholder => 'E-posta adresin';

  @override
  String get sdkChatEmailPrompt => 'Yanıtları e-postayla al';

  @override
  String get sdkChatEmailSave => 'Kaydet';

  @override
  String get sdkChatEmailSaved => 'Yanıtlar için e-posta';

  @override
  String get sdkChatEmptyGreeting =>
      'Merhaba! Bize bir mesaj gönder, ekibimiz sana buradan dönüş yapsın.';

  @override
  String get sdkChatLoadEarlier => 'Önceki mesajları yükle';

  @override
  String get sdkChatMessageUs => 'Bize yaz';

  @override
  String get sdkChatNotSentRetry =>
      'Gönderilemedi — Yeniden denemek için dokun';

  @override
  String get sdkChatSend => 'Gönder';

  @override
  String get sdkChatSending => 'Gönderiliyor…';

  @override
  String get sdkChatTeamLabel => 'Ekip';

  @override
  String get sdkChatTitle => 'Mesajlar';

  @override
  String get sdkChatToday => 'Bugün';

  @override
  String sdkChatTooLong(int max) {
    return 'Bu mesaj çok uzun. Sınır $max karakter.';
  }

  @override
  String get sdkChatYesterday => 'Dün';
}
