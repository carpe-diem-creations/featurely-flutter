// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'featurely_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Slovak (`sk`).
class FeaturelyLocalizationsSk extends FeaturelyLocalizations {
  FeaturelyLocalizationsSk([String locale = 'sk']) : super(locale);

  @override
  String get sdkListTitle => 'Spätná väzba';

  @override
  String get sdkListNewFeedback => 'Nová spätná väzba';

  @override
  String sdkListEmpty(String appName) {
    return 'Zatiaľ tu nič nie je — buď prvý, kto nám povie, čo by mala aplikácia $appName robiť ďalej';
  }

  @override
  String get sdkListLoadError =>
      'Spätnú väzbu sa nepodarilo načítať. Skontroluj pripojenie.';

  @override
  String sdkListVotes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hlasov',
      many: '$count hlasu',
      few: '$count hlasy',
      one: '$count hlas',
    );
    return '$_temp0';
  }

  @override
  String sdkListComments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count komentárov',
      many: '$count komentára',
      few: '$count komentáre',
      one: '$count komentár',
    );
    return '$_temp0';
  }

  @override
  String get sdkFilterTitle => 'Filtrovať a zoradiť';

  @override
  String get sdkFilterSortBy => 'Zoradiť';

  @override
  String get sdkFilterSortMostVoted => 'Najviac hlasov';

  @override
  String get sdkFilterSortNewest => 'Najnovšie';

  @override
  String get sdkFilterSortOldest => 'Najstaršie';

  @override
  String get sdkFilterStatus => 'Stav';

  @override
  String get sdkFilterStatusAll => 'Všetky';

  @override
  String get sdkFilterReset => 'Resetovať';

  @override
  String sdkFilterShowResults(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Zobraziť $count požiadaviek',
      many: 'Zobraziť $count požiadavky',
      few: 'Zobraziť $count požiadavky',
      one: 'Zobraziť $count požiadavku',
    );
    return '$_temp0';
  }

  @override
  String sdkFilterShowResultsOverflow(int count) {
    return 'Zobraziť $count+ požiadaviek';
  }

  @override
  String get sdkStatusOpen => 'Otvorené';

  @override
  String get sdkStatusPlanned => 'Naplánované';

  @override
  String get sdkStatusInProgress => 'Rozpracované';

  @override
  String get sdkStatusDone => 'Hotové';

  @override
  String get sdkFormTypeLabel => 'Typ';

  @override
  String get sdkFormTypeFeature => 'Funkcia';

  @override
  String get sdkFormTypeIssue => 'Problém';

  @override
  String get sdkFormTitleLabel => 'Názov';

  @override
  String get sdkFormTitlePlaceholder => 'Zhrň to pár slovami';

  @override
  String sdkFormTitleCounter(int remaining) {
    String _temp0 = intl.Intl.pluralLogic(
      remaining,
      locale: localeName,
      other: 'Zostáva $remaining znakov',
      many: 'Zostáva $remaining znaku',
      few: 'Zostávajú $remaining znaky',
      one: 'Zostáva $remaining znak',
    );
    return '$_temp0';
  }

  @override
  String get sdkFormDescriptionLabel => 'Popis';

  @override
  String sdkFormDescriptionPlaceholderFeature(String appName) {
    return 'Čo by mala aplikácia $appName robiť?';
  }

  @override
  String sdkFormDescriptionPlaceholderIssue(String appName) {
    return 'Čo sa pokazilo v aplikácii $appName?';
  }

  @override
  String get sdkFormEmailLabel => 'E-mail';

  @override
  String get sdkFormEmailHelper =>
      'Nepovinné. Keď tím odpovie alebo bude tvoja požiadavka hotová, pošleme ti e-mail.';

  @override
  String get sdkFormAddScreenshot => 'Pridať snímku obrazovky';

  @override
  String get sdkFormRemoveScreenshot => 'Odstrániť snímku obrazovky';

  @override
  String get sdkFormSubmit => 'Odoslať';

  @override
  String get sdkFormSending => 'Odosiela sa…';

  @override
  String get sdkFormSubmitError =>
      'Odoslanie zlyhalo. Koncept je uložený. Skontroluj pripojenie a skús to znova.';

  @override
  String get sdkFormTryAgain => 'Skúsiť znova';

  @override
  String get sdkSuccessTitle => 'Ďakujeme! Čítame každý jeden príspevok.';

  @override
  String sdkSuccessBody(String appName) {
    return 'Tvoja spätná väzba išla priamo tímu aplikácie $appName.';
  }

  @override
  String get sdkSuccessBack => 'Späť na spätnú väzbu';

  @override
  String sdkDetailSubmitted(String date) {
    return 'Odoslané $date';
  }

  @override
  String get sdkDetailVote => 'Hlasovať';

  @override
  String sdkDetailVoted(int count) {
    return 'Hlasované · $count';
  }

  @override
  String get sdkDetailCommentsTitle => 'Komentáre';

  @override
  String get sdkDetailCommentPlaceholder => 'Pridaj komentár…';

  @override
  String get sdkDetailCommentSend => 'Odoslať';

  @override
  String get sdkDetailAnonymous => 'Anonym';

  @override
  String get sdkDetailTeamBadge => 'Tím';

  @override
  String get sdkCommonClose => 'Zavrieť';

  @override
  String get sdkCommonCancel => 'Zrušiť';

  @override
  String get sdkCommonRetry => 'Skúsiť znova';

  @override
  String get sdkSandboxBadge => 'SANDBOX';

  @override
  String get sdkFormAttachError =>
      'Tento obrázok sa nepodarilo priložiť. Skús iný.';

  @override
  String get sdkFormEmailError => 'Zadaj platnú e-mailovú adresu.';

  @override
  String get sdkDetailCommentsDisabled => 'Komentovanie bolo vypnuté.';

  @override
  String get sdkCommonRateLimited =>
      'Príliš veľa žiadostí. Skús to znova o chvíľu.';

  @override
  String get sdkChatComposerPlaceholder => 'Napíš správu…';

  @override
  String get sdkChatEmailEdit => 'Upraviť';

  @override
  String get sdkChatEmailInvalid => 'Zadaj platnú e-mailovú adresu.';

  @override
  String get sdkChatEmailPlaceholder => 'Tvoja e-mailová adresa';

  @override
  String get sdkChatEmailPrompt => 'Dostávaj odpovede e-mailom';

  @override
  String get sdkChatEmailSave => 'Uložiť';

  @override
  String get sdkChatEmailSaved => 'E-mail pre odpovede';

  @override
  String get sdkChatEmptyGreeting =>
      'Ahoj! Pošli nám správu a náš tím ti odpovie priamo tu.';

  @override
  String get sdkChatLoadEarlier => 'Načítať staršie správy';

  @override
  String get sdkChatMessageUs => 'Napíš nám';

  @override
  String get sdkChatNotSentRetry => 'Neodoslané — klepni a skús to znova';

  @override
  String get sdkChatSend => 'Odoslať';

  @override
  String get sdkChatSending => 'Odosiela sa…';

  @override
  String get sdkChatTeamLabel => 'Tím';

  @override
  String get sdkChatTitle => 'Správy';

  @override
  String sdkChatTooLong(int max) {
    return 'Táto správa je príliš dlhá. Maximálny počet znakov je $max.';
  }
}
