// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'featurely_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class FeaturelyLocalizationsNl extends FeaturelyLocalizations {
  FeaturelyLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get sdkListTitle => 'Feedback';

  @override
  String get sdkListNewFeedback => 'Nieuwe feedback';

  @override
  String sdkListEmpty(String appName) {
    return 'Nog niets hier — vertel als eerste wat $appName hierna moet doen';
  }

  @override
  String get sdkListLoadError =>
      'Kan feedback niet laden. Controleer je verbinding.';

  @override
  String sdkListVotes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count stemmen',
      one: '$count stem',
    );
    return '$_temp0';
  }

  @override
  String sdkListComments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count reacties',
      one: '$count reactie',
    );
    return '$_temp0';
  }

  @override
  String get sdkFilterTitle => 'Filteren en sorteren';

  @override
  String get sdkFilterSortBy => 'Sorteren';

  @override
  String get sdkFilterSortMostVoted => 'Meeste stemmen';

  @override
  String get sdkFilterSortNewest => 'Nieuwste';

  @override
  String get sdkFilterSortOldest => 'Oudste';

  @override
  String get sdkFilterStatus => 'Status';

  @override
  String get sdkFilterStatusAll => 'Alle';

  @override
  String get sdkFilterReset => 'Resetten';

  @override
  String sdkFilterShowResults(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Toon $count verzoeken',
      one: 'Toon $count verzoek',
    );
    return '$_temp0';
  }

  @override
  String sdkFilterShowResultsOverflow(int count) {
    return 'Toon $count+ verzoeken';
  }

  @override
  String get sdkStatusOpen => 'Open';

  @override
  String get sdkStatusPlanned => 'Gepland';

  @override
  String get sdkStatusInProgress => 'In behandeling';

  @override
  String get sdkStatusDone => 'Klaar';

  @override
  String get sdkFormTypeLabel => 'Type';

  @override
  String get sdkFormTypeFeature => 'Functie';

  @override
  String get sdkFormTypeIssue => 'Probleem';

  @override
  String get sdkFormTitleLabel => 'Titel';

  @override
  String get sdkFormTitlePlaceholder => 'Vat het samen in een paar woorden';

  @override
  String sdkFormTitleCounter(int remaining) {
    String _temp0 = intl.Intl.pluralLogic(
      remaining,
      locale: localeName,
      other: 'Nog $remaining tekens over',
      one: 'Nog $remaining teken over',
    );
    return '$_temp0';
  }

  @override
  String get sdkFormDescriptionLabel => 'Beschrijving';

  @override
  String sdkFormDescriptionPlaceholderFeature(String appName) {
    return 'Wat moet $appName kunnen?';
  }

  @override
  String sdkFormDescriptionPlaceholderIssue(String appName) {
    return 'Wat ging er mis in $appName?';
  }

  @override
  String get sdkFormEmailLabel => 'E-mail';

  @override
  String get sdkFormEmailHelper =>
      'Optioneel. We sturen je een e-mail als het team reageert of je verzoek wordt uitgebracht.';

  @override
  String get sdkFormAddScreenshot => 'Screenshot toevoegen';

  @override
  String get sdkFormRemoveScreenshot => 'Screenshot verwijderen';

  @override
  String get sdkFormSubmit => 'Versturen';

  @override
  String get sdkFormSending => 'Versturen…';

  @override
  String get sdkFormSubmitError =>
      'Versturen mislukt. Je concept is opgeslagen. Controleer je verbinding en probeer het opnieuw.';

  @override
  String get sdkFormTryAgain => 'Opnieuw proberen';

  @override
  String get sdkSuccessTitle => 'Bedankt! We lezen ze allemaal.';

  @override
  String sdkSuccessBody(String appName) {
    return 'Je feedback is rechtstreeks naar het team van $appName gegaan.';
  }

  @override
  String get sdkSuccessBack => 'Terug naar feedback';

  @override
  String sdkDetailSubmitted(String date) {
    return 'Ingediend op $date';
  }

  @override
  String get sdkDetailVote => 'Stemmen';

  @override
  String sdkDetailVoted(int count) {
    return 'Gestemd · $count';
  }

  @override
  String get sdkDetailCommentsTitle => 'Reacties';

  @override
  String get sdkDetailCommentPlaceholder => 'Reactie toevoegen…';

  @override
  String get sdkDetailCommentSend => 'Versturen';

  @override
  String get sdkDetailAnonymous => 'Anoniem';

  @override
  String get sdkDetailTeamBadge => 'Team';

  @override
  String get sdkCommonClose => 'Sluiten';

  @override
  String get sdkCommonCancel => 'Annuleren';

  @override
  String get sdkCommonRetry => 'Opnieuw proberen';

  @override
  String get sdkSandboxBadge => 'SANDBOX';

  @override
  String get sdkFormAttachError =>
      'Kan die afbeelding niet toevoegen. Probeer een andere.';

  @override
  String get sdkFormEmailError => 'Voer een geldig e-mailadres in.';

  @override
  String get sdkDetailCommentsDisabled => 'Reacties zijn uitgeschakeld.';

  @override
  String get sdkCommonRateLimited => 'Te veel verzoeken. Probeer het zo weer.';

  @override
  String get sdkChatComposerPlaceholder => 'Schrijf een bericht…';

  @override
  String get sdkChatEmailEdit => 'Bewerken';

  @override
  String get sdkChatEmailInvalid => 'Voer een geldig e-mailadres in.';

  @override
  String get sdkChatEmailPlaceholder => 'Je e-mailadres';

  @override
  String get sdkChatEmailPrompt => 'Antwoorden per e-mail ontvangen';

  @override
  String get sdkChatEmailSave => 'Opslaan';

  @override
  String get sdkChatEmailSaved => 'E-mail voor antwoorden';

  @override
  String get sdkChatEmptyGreeting =>
      'Hoi! Stuur ons een bericht, dan reageert ons team hier.';

  @override
  String get sdkChatLoadEarlier => 'Eerdere berichten laden';

  @override
  String get sdkChatMessageUs => 'Stuur ons een bericht';

  @override
  String get sdkChatNotSentRetry =>
      'Niet verstuurd — Tik om opnieuw te proberen';

  @override
  String get sdkChatSend => 'Versturen';

  @override
  String get sdkChatSending => 'Versturen…';

  @override
  String get sdkChatTeamLabel => 'Team';

  @override
  String get sdkChatTitle => 'Berichten';

  @override
  String get sdkChatToday => 'Vandaag';

  @override
  String sdkChatTooLong(int max) {
    return 'Dit bericht is te lang. De limiet is $max tekens.';
  }

  @override
  String get sdkChatYesterday => 'Gisteren';
}
