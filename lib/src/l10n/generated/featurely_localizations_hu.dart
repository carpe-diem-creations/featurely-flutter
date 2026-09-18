// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'featurely_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hungarian (`hu`).
class FeaturelyLocalizationsHu extends FeaturelyLocalizations {
  FeaturelyLocalizationsHu([String locale = 'hu']) : super(locale);

  @override
  String get sdkListTitle => 'Visszajelzés';

  @override
  String get sdkListNewFeedback => 'Új visszajelzés';

  @override
  String sdkListEmpty(String appName) {
    return 'Itt még nincs semmi — mondd el elsőként, mit tudjon legközelebb a(z) $appName';
  }

  @override
  String get sdkListLoadError =>
      'Nem sikerült betölteni a visszajelzéseket. Ellenőrizd a kapcsolatot.';

  @override
  String sdkListVotes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count szavazat',
      one: '$count szavazat',
    );
    return '$_temp0';
  }

  @override
  String sdkListComments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hozzászólás',
      one: '$count hozzászólás',
    );
    return '$_temp0';
  }

  @override
  String get sdkFilterTitle => 'Szűrés és rendezés';

  @override
  String get sdkFilterSortBy => 'Rendezés';

  @override
  String get sdkFilterSortMostVoted => 'Legtöbb szavazat';

  @override
  String get sdkFilterSortNewest => 'Legújabb';

  @override
  String get sdkFilterSortOldest => 'Legrégebbi';

  @override
  String get sdkFilterStatus => 'Állapot';

  @override
  String get sdkFilterStatusAll => 'Mind';

  @override
  String get sdkFilterReset => 'Visszaállítás';

  @override
  String sdkFilterShowResults(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kérés megjelenítése',
      one: '$count kérés megjelenítése',
    );
    return '$_temp0';
  }

  @override
  String sdkFilterShowResultsOverflow(int count) {
    return '$count+ kérés megjelenítése';
  }

  @override
  String get sdkStatusOpen => 'Nyitott';

  @override
  String get sdkStatusPlanned => 'Tervezett';

  @override
  String get sdkStatusInProgress => 'Folyamatban';

  @override
  String get sdkStatusDone => 'Kész';

  @override
  String get sdkFormTypeLabel => 'Típus';

  @override
  String get sdkFormTypeFeature => 'Funkció';

  @override
  String get sdkFormTypeIssue => 'Probléma';

  @override
  String get sdkFormTitleLabel => 'Cím';

  @override
  String get sdkFormTitlePlaceholder => 'Foglald össze pár szóban';

  @override
  String sdkFormTitleCounter(int remaining) {
    String _temp0 = intl.Intl.pluralLogic(
      remaining,
      locale: localeName,
      other: '$remaining karakter maradt',
      one: '$remaining karakter maradt',
    );
    return '$_temp0';
  }

  @override
  String get sdkFormDescriptionLabel => 'Leírás';

  @override
  String sdkFormDescriptionPlaceholderFeature(String appName) {
    return 'Mit tudjon a(z) $appName?';
  }

  @override
  String sdkFormDescriptionPlaceholderIssue(String appName) {
    return 'Mi romlott el a(z) $appName alkalmazásban?';
  }

  @override
  String get sdkFormEmailLabel => 'E-mail';

  @override
  String get sdkFormEmailHelper =>
      'Nem kötelező. E-mailt küldünk, ha a csapat válaszol, vagy ha a kérésed elkészül.';

  @override
  String get sdkFormAddScreenshot => 'Képernyőkép hozzáadása';

  @override
  String get sdkFormRemoveScreenshot => 'Képernyőkép eltávolítása';

  @override
  String get sdkFormSubmit => 'Küldés';

  @override
  String get sdkFormSending => 'Küldés folyamatban…';

  @override
  String get sdkFormSubmitError =>
      'Nem sikerült elküldeni. A piszkozatod megvan. Ellenőrizd a kapcsolatot, és próbáld újra.';

  @override
  String get sdkFormTryAgain => 'Próbáld újra';

  @override
  String get sdkSuccessTitle => 'Köszi! Minden visszajelzést elolvasunk.';

  @override
  String sdkSuccessBody(String appName) {
    return 'A visszajelzésed egyenesen a(z) $appName csapatához került.';
  }

  @override
  String get sdkSuccessBack => 'Vissza a visszajelzésekhez';

  @override
  String sdkDetailSubmitted(String date) {
    return 'Beküldve: $date';
  }

  @override
  String get sdkDetailVote => 'Szavazás';

  @override
  String sdkDetailVoted(int count) {
    return 'Szavaztál · $count';
  }

  @override
  String get sdkDetailCommentsTitle => 'Hozzászólások';

  @override
  String get sdkDetailCommentPlaceholder => 'Írj hozzászólást…';

  @override
  String get sdkDetailCommentSend => 'Küldés';

  @override
  String get sdkDetailAnonymous => 'Névtelen';

  @override
  String get sdkDetailTeamBadge => 'Csapat';

  @override
  String get sdkCommonClose => 'Bezárás';

  @override
  String get sdkCommonCancel => 'Mégse';

  @override
  String get sdkCommonRetry => 'Újra';

  @override
  String get sdkSandboxBadge => 'SANDBOX';

  @override
  String get sdkFormAttachError =>
      'Nem sikerült csatolni ezt a képet. Próbálj meg egy másikat.';

  @override
  String get sdkFormEmailError => 'Adj meg egy érvényes e-mail-címet.';

  @override
  String get sdkDetailCommentsDisabled =>
      'A hozzászólások ki lettek kapcsolva.';

  @override
  String get sdkCommonRateLimited =>
      'Túl sok kérés. Próbáld újra kicsit később.';

  @override
  String get sdkChatAiTag => 'MI';

  @override
  String get sdkChatAssistantName => 'Asszisztens';

  @override
  String sdkChatAssistantTyping(String name) {
    return '$name éppen ír…';
  }

  @override
  String get sdkChatComposerPlaceholder => 'Írj üzenetet…';

  @override
  String get sdkChatEmailEdit => 'Szerkesztés';

  @override
  String get sdkChatEmailInvalid => 'Adj meg egy érvényes e-mail-címet.';

  @override
  String get sdkChatEmailPlaceholder => 'Az e-mail-címed';

  @override
  String get sdkChatEmailPrompt => 'Válaszok e-mailben';

  @override
  String get sdkChatEmailSave => 'Mentés';

  @override
  String get sdkChatEmailSaved => 'E-mail a válaszokhoz';

  @override
  String get sdkChatEmptyGreeting =>
      'Szia! Küldj nekünk üzenetet, és a csapatunk itt válaszol.';

  @override
  String get sdkChatLoadEarlier => 'Korábbi üzenetek betöltése';

  @override
  String get sdkChatMessageUs => 'Írj nekünk';

  @override
  String get sdkChatNotSentRetry =>
      'Nem sikerült elküldeni — Koppints az újrapróbáláshoz';

  @override
  String get sdkChatSend => 'Küldés';

  @override
  String get sdkChatSending => 'Küldés…';

  @override
  String get sdkChatTeamLabel => 'Csapat';

  @override
  String get sdkChatTitle => 'Üzenetek';

  @override
  String get sdkChatToday => 'Ma';

  @override
  String sdkChatTooLong(int max) {
    return 'Ez az üzenet túl hosszú. A korlát $max karakter.';
  }

  @override
  String get sdkChatYesterday => 'Tegnap';
}
