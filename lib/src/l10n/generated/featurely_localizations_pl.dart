// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'featurely_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class FeaturelyLocalizationsPl extends FeaturelyLocalizations {
  FeaturelyLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get sdkListTitle => 'Opinie';

  @override
  String get sdkListNewFeedback => 'Nowa opinia';

  @override
  String sdkListEmpty(String appName) {
    return 'Na razie pusto — bądź pierwszą osobą, która powie nam, co $appName ma zrobić dalej';
  }

  @override
  String get sdkListLoadError =>
      'Nie udało się wczytać opinii. Sprawdź połączenie.';

  @override
  String sdkListVotes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count głosu',
      many: '$count głosów',
      few: '$count głosy',
      one: '$count głos',
    );
    return '$_temp0';
  }

  @override
  String sdkListComments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count komentarza',
      many: '$count komentarzy',
      few: '$count komentarze',
      one: '$count komentarz',
    );
    return '$_temp0';
  }

  @override
  String get sdkFilterTitle => 'Filtrowanie i sortowanie';

  @override
  String get sdkFilterSortBy => 'Sortuj';

  @override
  String get sdkFilterSortMostVoted => 'Najwięcej głosów';

  @override
  String get sdkFilterSortNewest => 'Najnowsze';

  @override
  String get sdkFilterSortOldest => 'Najstarsze';

  @override
  String get sdkFilterStatus => 'Status';

  @override
  String get sdkFilterStatusAll => 'Wszystkie';

  @override
  String get sdkFilterReset => 'Resetuj';

  @override
  String sdkFilterShowResults(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Pokaż $count prośby',
      many: 'Pokaż $count próśb',
      few: 'Pokaż $count prośby',
      one: 'Pokaż $count prośbę',
    );
    return '$_temp0';
  }

  @override
  String sdkFilterShowResultsOverflow(int count) {
    return 'Pokaż $count+ próśb';
  }

  @override
  String get sdkStatusOpen => 'Otwarte';

  @override
  String get sdkStatusPlanned => 'Zaplanowane';

  @override
  String get sdkStatusInProgress => 'W toku';

  @override
  String get sdkStatusDone => 'Gotowe';

  @override
  String get sdkFormTypeLabel => 'Typ';

  @override
  String get sdkFormTypeFeature => 'Funkcja';

  @override
  String get sdkFormTypeIssue => 'Problem';

  @override
  String get sdkFormTitleLabel => 'Tytuł';

  @override
  String get sdkFormTitlePlaceholder => 'Podsumuj w kilku słowach';

  @override
  String sdkFormTitleCounter(int remaining) {
    String _temp0 = intl.Intl.pluralLogic(
      remaining,
      locale: localeName,
      other: 'Zostało $remaining znaku',
      many: 'Zostało $remaining znaków',
      few: 'Zostały $remaining znaki',
      one: 'Został $remaining znak',
    );
    return '$_temp0';
  }

  @override
  String get sdkFormDescriptionLabel => 'Opis';

  @override
  String sdkFormDescriptionPlaceholderFeature(String appName) {
    return 'Co $appName ma umieć? Napisz, jak chcesz z tego korzystać.';
  }

  @override
  String sdkFormDescriptionPlaceholderIssue(String appName) {
    return 'Co poszło nie tak w $appName? Opisz też, co powinno się wydarzyć.';
  }

  @override
  String get sdkFormEmailLabel => 'E-mail';

  @override
  String get sdkFormEmailHelper =>
      'Opcjonalnie. Napiszemy do Ciebie, gdy zespół odpowie albo Twoja prośba zostanie zrealizowana.';

  @override
  String get sdkFormAddScreenshot => 'Dodaj zrzut ekranu';

  @override
  String get sdkFormRemoveScreenshot => 'Usuń zrzut ekranu';

  @override
  String get sdkFormSubmit => 'Wyślij';

  @override
  String get sdkFormSending => 'Wysyłanie…';

  @override
  String get sdkFormSubmitError =>
      'Nie udało się wysłać. Wersja robocza została zapisana. Sprawdź połączenie i spróbuj ponownie.';

  @override
  String get sdkFormTryAgain => 'Spróbuj ponownie';

  @override
  String get sdkSuccessTitle => 'Dzięki! Czytamy każdą opinię.';

  @override
  String sdkSuccessBody(String appName) {
    return 'Twoja opinia trafiła prosto do zespołu $appName.';
  }

  @override
  String get sdkSuccessBack => 'Wróć do opinii';

  @override
  String sdkDetailSubmitted(String date) {
    return 'Przesłano $date';
  }

  @override
  String get sdkDetailVote => 'Zagłosuj';

  @override
  String sdkDetailVoted(int count) {
    return 'Zagłosowano · $count';
  }

  @override
  String get sdkDetailCommentsTitle => 'Komentarze';

  @override
  String get sdkDetailCommentPlaceholder => 'Dodaj komentarz…';

  @override
  String get sdkDetailCommentSend => 'Wyślij';

  @override
  String get sdkDetailAnonymous => 'Anonim';

  @override
  String get sdkDetailTeamBadge => 'Zespół';

  @override
  String get sdkCommonClose => 'Zamknij';

  @override
  String get sdkCommonCancel => 'Anuluj';

  @override
  String get sdkCommonRetry => 'Ponów';

  @override
  String get sdkSandboxBadge => 'SANDBOX';

  @override
  String get sdkFormAttachError =>
      'Nie udało się załączyć tego obrazu. Spróbuj innego.';

  @override
  String get sdkFormEmailError => 'Wpisz prawidłowy adres e-mail.';

  @override
  String get sdkDetailCommentsDisabled => 'Komentarze zostały wyłączone.';

  @override
  String get sdkCommonRateLimited =>
      'Zbyt wiele żądań. Spróbuj ponownie za chwilę.';
}
