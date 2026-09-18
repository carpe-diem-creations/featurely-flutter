// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'featurely_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Lithuanian (`lt`).
class FeaturelyLocalizationsLt extends FeaturelyLocalizations {
  FeaturelyLocalizationsLt([String locale = 'lt']) : super(locale);

  @override
  String get sdkListTitle => 'Atsiliepimai';

  @override
  String get sdkListNewFeedback => 'Naujas atsiliepimas';

  @override
  String sdkListEmpty(String appName) {
    return 'Kol kas čia tuščia — papasakok, ką programėlė $appName turėtų daryti toliau';
  }

  @override
  String get sdkListLoadError => 'Nepavyko įkelti atsiliepimų. Patikrink ryšį.';

  @override
  String sdkListVotes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count balsų',
      many: '$count balso',
      few: '$count balsai',
      one: '$count balsas',
    );
    return '$_temp0';
  }

  @override
  String sdkListComments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count komentarų',
      many: '$count komentaro',
      few: '$count komentarai',
      one: '$count komentaras',
    );
    return '$_temp0';
  }

  @override
  String get sdkFilterTitle => 'Filtravimas ir rikiavimas';

  @override
  String get sdkFilterSortBy => 'Rikiuoti';

  @override
  String get sdkFilterSortMostVoted => 'Daugiausia balsų';

  @override
  String get sdkFilterSortNewest => 'Naujausi';

  @override
  String get sdkFilterSortOldest => 'Seniausi';

  @override
  String get sdkFilterStatus => 'Būsena';

  @override
  String get sdkFilterStatusAll => 'Visos';

  @override
  String get sdkFilterReset => 'Atkurti';

  @override
  String sdkFilterShowResults(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Rodyti $count pageidavimų',
      many: 'Rodyti $count pageidavimo',
      few: 'Rodyti $count pageidavimus',
      one: 'Rodyti $count pageidavimą',
    );
    return '$_temp0';
  }

  @override
  String sdkFilterShowResultsOverflow(int count) {
    return 'Rodyti $count+ pageidavimų';
  }

  @override
  String get sdkStatusOpen => 'Atidaryta';

  @override
  String get sdkStatusPlanned => 'Suplanuota';

  @override
  String get sdkStatusInProgress => 'Vykdoma';

  @override
  String get sdkStatusDone => 'Atlikta';

  @override
  String get sdkFormTypeLabel => 'Tipas';

  @override
  String get sdkFormTypeFeature => 'Funkcija';

  @override
  String get sdkFormTypeIssue => 'Problema';

  @override
  String get sdkFormTitleLabel => 'Pavadinimas';

  @override
  String get sdkFormTitlePlaceholder => 'Apibendrink keliais žodžiais';

  @override
  String sdkFormTitleCounter(int remaining) {
    String _temp0 = intl.Intl.pluralLogic(
      remaining,
      locale: localeName,
      other: 'Liko $remaining simbolių',
      many: 'Liko $remaining simbolio',
      few: 'Liko $remaining simboliai',
      one: 'Liko $remaining simbolis',
    );
    return '$_temp0';
  }

  @override
  String get sdkFormDescriptionLabel => 'Aprašymas';

  @override
  String sdkFormDescriptionPlaceholderFeature(String appName) {
    return 'Ką turėtų daryti programėlė $appName?';
  }

  @override
  String sdkFormDescriptionPlaceholderIssue(String appName) {
    return 'Kas nutiko programėlėje $appName?';
  }

  @override
  String get sdkFormEmailLabel => 'El. paštas';

  @override
  String get sdkFormEmailHelper =>
      'Neprivaloma. Parašysime tau el. paštu, kai komanda atsakys arba tavo pageidavimas bus įgyvendintas.';

  @override
  String get sdkFormAddScreenshot => 'Pridėti ekrano kopiją';

  @override
  String get sdkFormRemoveScreenshot => 'Pašalinti ekrano kopiją';

  @override
  String get sdkFormSubmit => 'Siųsti';

  @override
  String get sdkFormSending => 'Siunčiama…';

  @override
  String get sdkFormSubmitError =>
      'Nepavyko išsiųsti. Juodraštis išsaugotas. Patikrink ryšį ir bandyk dar kartą.';

  @override
  String get sdkFormTryAgain => 'Bandyti dar kartą';

  @override
  String get sdkSuccessTitle => 'Ačiū! Perskaitome kiekvieną iš jų.';

  @override
  String sdkSuccessBody(String appName) {
    return 'Tavo atsiliepimas nukeliavo tiesiai programėlės $appName komandai.';
  }

  @override
  String get sdkSuccessBack => 'Grįžti į atsiliepimus';

  @override
  String sdkDetailSubmitted(String date) {
    return 'Pateikta $date';
  }

  @override
  String get sdkDetailVote => 'Balsuoti';

  @override
  String sdkDetailVoted(int count) {
    return 'Balsuota · $count';
  }

  @override
  String get sdkDetailCommentsTitle => 'Komentarai';

  @override
  String get sdkDetailCommentPlaceholder => 'Parašyk komentarą…';

  @override
  String get sdkDetailCommentSend => 'Siųsti';

  @override
  String get sdkDetailAnonymous => 'Anonimas';

  @override
  String get sdkDetailTeamBadge => 'Komanda';

  @override
  String get sdkCommonClose => 'Uždaryti';

  @override
  String get sdkCommonCancel => 'Atšaukti';

  @override
  String get sdkCommonRetry => 'Bandyti dar kartą';

  @override
  String get sdkSandboxBadge => 'SANDBOX';

  @override
  String get sdkFormAttachError =>
      'Nepavyko pridėti šio vaizdo. Pabandyk kitą.';

  @override
  String get sdkFormEmailError => 'Įvesk galiojantį el. pašto adresą.';

  @override
  String get sdkDetailCommentsDisabled => 'Komentavimas išjungtas.';

  @override
  String get sdkCommonRateLimited =>
      'Per daug užklausų. Bandyk dar kartą po akimirkos.';

  @override
  String get sdkChatAssistantName => 'Asistentas';

  @override
  String sdkChatAssistantTyping(String name) {
    return '$name rašo…';
  }

  @override
  String get sdkChatComposerPlaceholder => 'Rašyk žinutę…';

  @override
  String get sdkChatEmptyGreeting =>
      'Labas! Parašyk mums žinutę, ir mūsų komanda tau atsakys čia.';

  @override
  String get sdkChatLoadEarlier => 'Įkelti ankstesnes žinutes';

  @override
  String get sdkChatMessageUs => 'Parašyk mums';

  @override
  String get sdkChatNotSentRetry =>
      'Neišsiųsta — bakstelėk, kad bandytum dar kartą';

  @override
  String get sdkChatSend => 'Siųsti';

  @override
  String get sdkChatSending => 'Siunčiama…';

  @override
  String get sdkChatTeamLabel => 'Komanda';

  @override
  String get sdkChatTitle => 'Žinutės';

  @override
  String get sdkChatToday => 'Šiandien';

  @override
  String sdkChatTooLong(int max) {
    return 'Ši žinutė per ilga. Leidžiama iki $max simbolių.';
  }

  @override
  String get sdkChatYesterday => 'Vakar';
}
