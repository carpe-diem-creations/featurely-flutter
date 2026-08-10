// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'featurely_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class FeaturelyLocalizationsDe extends FeaturelyLocalizations {
  FeaturelyLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get sdkListTitle => 'Feedback';

  @override
  String get sdkListNewFeedback => 'Neues Feedback';

  @override
  String sdkListEmpty(String appName) {
    return 'Hier ist noch nichts — sag uns als Erster, was $appName als Nächstes können sollte';
  }

  @override
  String get sdkListLoadError =>
      'Feedback konnte nicht geladen werden. Prüfe deine Verbindung.';

  @override
  String sdkListVotes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Stimmen',
      one: '$count Stimme',
    );
    return '$_temp0';
  }

  @override
  String sdkListComments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Kommentare',
      one: '$count Kommentar',
    );
    return '$_temp0';
  }

  @override
  String get sdkFilterTitle => 'Filtern & Sortieren';

  @override
  String get sdkFilterSortBy => 'Sortieren';

  @override
  String get sdkFilterSortMostVoted => 'Meiste Stimmen';

  @override
  String get sdkFilterSortNewest => 'Neueste';

  @override
  String get sdkFilterSortOldest => 'Älteste';

  @override
  String get sdkFilterStatus => 'Status';

  @override
  String get sdkFilterStatusAll => 'Alle';

  @override
  String get sdkFilterReset => 'Zurücksetzen';

  @override
  String sdkFilterShowResults(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Anfragen anzeigen',
      one: '$count Anfrage anzeigen',
    );
    return '$_temp0';
  }

  @override
  String sdkFilterShowResultsOverflow(int count) {
    return '$count+ Anfragen anzeigen';
  }

  @override
  String get sdkStatusOpen => 'Offen';

  @override
  String get sdkStatusPlanned => 'Geplant';

  @override
  String get sdkStatusInProgress => 'In Arbeit';

  @override
  String get sdkStatusDone => 'Fertig';

  @override
  String get sdkFormTypeLabel => 'Typ';

  @override
  String get sdkFormTypeFeature => 'Funktion';

  @override
  String get sdkFormTypeIssue => 'Problem';

  @override
  String get sdkFormTitleLabel => 'Titel';

  @override
  String get sdkFormTitlePlaceholder => 'Fasse es in wenigen Worten zusammen';

  @override
  String sdkFormTitleCounter(int remaining) {
    String _temp0 = intl.Intl.pluralLogic(
      remaining,
      locale: localeName,
      other: 'Noch $remaining Zeichen übrig',
      one: 'Noch $remaining Zeichen übrig',
    );
    return '$_temp0';
  }

  @override
  String get sdkFormDescriptionLabel => 'Beschreibung';

  @override
  String sdkFormDescriptionPlaceholderFeature(String appName) {
    return 'Was sollte $appName können?';
  }

  @override
  String sdkFormDescriptionPlaceholderIssue(String appName) {
    return 'Was ist in $appName schiefgelaufen?';
  }

  @override
  String get sdkFormEmailLabel => 'E-Mail';

  @override
  String get sdkFormEmailHelper =>
      'Optional. Wir melden uns per E-Mail, wenn das Team antwortet oder dein Wunsch umgesetzt wird.';

  @override
  String get sdkFormAddScreenshot => 'Screenshot hinzufügen';

  @override
  String get sdkFormRemoveScreenshot => 'Screenshot entfernen';

  @override
  String get sdkFormSubmit => 'Absenden';

  @override
  String get sdkFormSending => 'Wird gesendet…';

  @override
  String get sdkFormSubmitError =>
      'Senden fehlgeschlagen. Dein Entwurf ist gespeichert. Prüfe deine Verbindung und versuch es erneut.';

  @override
  String get sdkFormTryAgain => 'Erneut versuchen';

  @override
  String get sdkSuccessTitle => 'Danke! Wir lesen jede einzelne Nachricht.';

  @override
  String sdkSuccessBody(String appName) {
    return 'Dein Feedback ging direkt an das $appName-Team.';
  }

  @override
  String get sdkSuccessBack => 'Zurück zum Feedback';

  @override
  String sdkDetailSubmitted(String date) {
    return 'Eingereicht am $date';
  }

  @override
  String get sdkDetailVote => 'Abstimmen';

  @override
  String sdkDetailVoted(int count) {
    return 'Abgestimmt · $count';
  }

  @override
  String get sdkDetailCommentsTitle => 'Kommentare';

  @override
  String get sdkDetailCommentPlaceholder => 'Kommentar hinzufügen…';

  @override
  String get sdkDetailCommentSend => 'Senden';

  @override
  String get sdkDetailAnonymous => 'Anonym';

  @override
  String get sdkDetailTeamBadge => 'Team';

  @override
  String get sdkCommonClose => 'Schließen';

  @override
  String get sdkCommonCancel => 'Abbrechen';

  @override
  String get sdkCommonRetry => 'Erneut versuchen';

  @override
  String get sdkSandboxBadge => 'SANDBOX';

  @override
  String get sdkFormAttachError =>
      'Dieses Bild konnte nicht angehängt werden. Versuche ein anderes.';

  @override
  String get sdkFormEmailError => 'Gib eine gültige E-Mail-Adresse ein.';

  @override
  String get sdkDetailCommentsDisabled => 'Kommentare wurden deaktiviert.';

  @override
  String get sdkCommonRateLimited =>
      'Zu viele Anfragen. Versuche es gleich noch einmal.';
}
