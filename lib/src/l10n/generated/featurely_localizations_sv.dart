// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'featurely_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swedish (`sv`).
class FeaturelyLocalizationsSv extends FeaturelyLocalizations {
  FeaturelyLocalizationsSv([String locale = 'sv']) : super(locale);

  @override
  String get sdkListTitle => 'Feedback';

  @override
  String get sdkListNewFeedback => 'Ny feedback';

  @override
  String sdkListEmpty(String appName) {
    return 'Inget här ännu — bli först med att berätta vad $appName borde göra härnäst';
  }

  @override
  String get sdkListLoadError =>
      'Kunde inte ladda feedback. Kontrollera din anslutning.';

  @override
  String sdkListVotes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count röster',
      one: '$count röst',
    );
    return '$_temp0';
  }

  @override
  String sdkListComments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kommentarer',
      one: '$count kommentar',
    );
    return '$_temp0';
  }

  @override
  String get sdkFilterTitle => 'Filtrera och sortera';

  @override
  String get sdkFilterSortBy => 'Sortera';

  @override
  String get sdkFilterSortMostVoted => 'Flest röster';

  @override
  String get sdkFilterSortNewest => 'Nyast';

  @override
  String get sdkFilterSortOldest => 'Äldst';

  @override
  String get sdkFilterStatus => 'Status';

  @override
  String get sdkFilterStatusAll => 'Alla';

  @override
  String get sdkFilterReset => 'Återställ';

  @override
  String sdkFilterShowResults(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Visa $count förfrågningar',
      one: 'Visa $count förfrågan',
    );
    return '$_temp0';
  }

  @override
  String sdkFilterShowResultsOverflow(int count) {
    return 'Visa $count+ förfrågningar';
  }

  @override
  String get sdkStatusOpen => 'Öppen';

  @override
  String get sdkStatusPlanned => 'Planerad';

  @override
  String get sdkStatusInProgress => 'Pågår';

  @override
  String get sdkStatusDone => 'Klar';

  @override
  String get sdkFormTypeLabel => 'Typ';

  @override
  String get sdkFormTypeFeature => 'Funktion';

  @override
  String get sdkFormTypeIssue => 'Problem';

  @override
  String get sdkFormTitleLabel => 'Titel';

  @override
  String get sdkFormTitlePlaceholder => 'Sammanfatta med några ord';

  @override
  String sdkFormTitleCounter(int remaining) {
    String _temp0 = intl.Intl.pluralLogic(
      remaining,
      locale: localeName,
      other: '$remaining tecken kvar',
      one: '$remaining tecken kvar',
    );
    return '$_temp0';
  }

  @override
  String get sdkFormDescriptionLabel => 'Beskrivning';

  @override
  String sdkFormDescriptionPlaceholderFeature(String appName) {
    return 'Vad borde $appName kunna?';
  }

  @override
  String sdkFormDescriptionPlaceholderIssue(String appName) {
    return 'Vad gick fel i $appName?';
  }

  @override
  String get sdkFormEmailLabel => 'E-post';

  @override
  String get sdkFormEmailHelper =>
      'Valfritt. Vi mejlar dig när teamet svarar eller när din förfrågan blir verklighet.';

  @override
  String get sdkFormAddScreenshot => 'Lägg till skärmbild';

  @override
  String get sdkFormRemoveScreenshot => 'Ta bort skärmbild';

  @override
  String get sdkFormSubmit => 'Skicka';

  @override
  String get sdkFormSending => 'Skickar…';

  @override
  String get sdkFormSubmitError =>
      'Kunde inte skicka. Ditt utkast är sparat. Kontrollera din anslutning och försök igen.';

  @override
  String get sdkFormTryAgain => 'Försök igen';

  @override
  String get sdkSuccessTitle => 'Tack! Vi läser varenda en.';

  @override
  String sdkSuccessBody(String appName) {
    return 'Din feedback gick direkt till $appName-teamet.';
  }

  @override
  String get sdkSuccessBack => 'Tillbaka till feedback';

  @override
  String sdkDetailSubmitted(String date) {
    return 'Skickad $date';
  }

  @override
  String get sdkDetailVote => 'Rösta';

  @override
  String sdkDetailVoted(int count) {
    return 'Röstat · $count';
  }

  @override
  String get sdkDetailCommentsTitle => 'Kommentarer';

  @override
  String get sdkDetailCommentPlaceholder => 'Lägg till en kommentar…';

  @override
  String get sdkDetailCommentSend => 'Skicka';

  @override
  String get sdkDetailAnonymous => 'Anonym';

  @override
  String get sdkDetailTeamBadge => 'Team';

  @override
  String get sdkCommonClose => 'Stäng';

  @override
  String get sdkCommonCancel => 'Avbryt';

  @override
  String get sdkCommonRetry => 'Försök igen';

  @override
  String get sdkSandboxBadge => 'SANDBOX';

  @override
  String get sdkFormAttachError =>
      'Det gick inte att bifoga bilden. Prova en annan.';

  @override
  String get sdkFormEmailError => 'Ange en giltig e-postadress.';

  @override
  String get sdkDetailCommentsDisabled => 'Kommentarer har stängts av.';

  @override
  String get sdkCommonRateLimited =>
      'För många förfrågningar. Försök igen om en stund.';

  @override
  String get sdkChatAiTag => 'AI';

  @override
  String get sdkChatAssistantName => 'Assistent';

  @override
  String sdkChatAssistantTyping(String name) {
    return '$name skriver…';
  }

  @override
  String get sdkChatComposerPlaceholder => 'Skriv ett meddelande…';

  @override
  String get sdkChatEmailEdit => 'Redigera';

  @override
  String get sdkChatEmailInvalid => 'Ange en giltig mejladress.';

  @override
  String get sdkChatEmailPlaceholder => 'Din mejladress';

  @override
  String get sdkChatEmailPrompt => 'Få svar via mejl';

  @override
  String get sdkChatEmailSave => 'Spara';

  @override
  String get sdkChatEmailSaved => 'Mejl för svar';

  @override
  String get sdkChatEmptyGreeting =>
      'Hej! Skicka ett meddelande så svarar vårt team dig här.';

  @override
  String get sdkChatLoadEarlier => 'Läs in tidigare meddelanden';

  @override
  String get sdkChatMessageUs => 'Skriv till oss';

  @override
  String get sdkChatNotSentRetry => 'Inte skickat — Tryck för att försöka igen';

  @override
  String get sdkChatSend => 'Skicka';

  @override
  String get sdkChatSending => 'Skickar…';

  @override
  String get sdkChatTeamLabel => 'Team';

  @override
  String get sdkChatTitle => 'Meddelanden';

  @override
  String get sdkChatToday => 'I dag';

  @override
  String sdkChatTooLong(int max) {
    return 'Meddelandet är för långt. Gränsen är $max tecken.';
  }

  @override
  String get sdkChatYesterday => 'I går';
}
