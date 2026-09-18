// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'featurely_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Danish (`da`).
class FeaturelyLocalizationsDa extends FeaturelyLocalizations {
  FeaturelyLocalizationsDa([String locale = 'da']) : super(locale);

  @override
  String get sdkListTitle => 'Feedback';

  @override
  String get sdkListNewFeedback => 'Ny feedback';

  @override
  String sdkListEmpty(String appName) {
    return 'Der er ikke noget her endnu — vær den første til at fortælle os, hvad $appName skal kunne fremover';
  }

  @override
  String get sdkListLoadError =>
      'Kunne ikke indlæse feedback. Tjek din forbindelse.';

  @override
  String sdkListVotes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count stemmer',
      one: '$count stemme',
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
  String get sdkFilterTitle => 'Filtrér og sortér';

  @override
  String get sdkFilterSortBy => 'Sortér';

  @override
  String get sdkFilterSortMostVoted => 'Flest stemmer';

  @override
  String get sdkFilterSortNewest => 'Nyeste';

  @override
  String get sdkFilterSortOldest => 'Ældste';

  @override
  String get sdkFilterStatus => 'Status';

  @override
  String get sdkFilterStatusAll => 'Alle';

  @override
  String get sdkFilterReset => 'Nulstil';

  @override
  String sdkFilterShowResults(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Vis $count ønsker',
      one: 'Vis $count ønske',
    );
    return '$_temp0';
  }

  @override
  String sdkFilterShowResultsOverflow(int count) {
    return 'Vis $count+ ønsker';
  }

  @override
  String get sdkStatusOpen => 'Åben';

  @override
  String get sdkStatusPlanned => 'Planlagt';

  @override
  String get sdkStatusInProgress => 'I gang';

  @override
  String get sdkStatusDone => 'Færdig';

  @override
  String get sdkFormTypeLabel => 'Type';

  @override
  String get sdkFormTypeFeature => 'Funktion';

  @override
  String get sdkFormTypeIssue => 'Problem';

  @override
  String get sdkFormTitleLabel => 'Titel';

  @override
  String get sdkFormTitlePlaceholder => 'Opsummer det med få ord';

  @override
  String sdkFormTitleCounter(int remaining) {
    String _temp0 = intl.Intl.pluralLogic(
      remaining,
      locale: localeName,
      other: '$remaining tegn tilbage',
      one: '$remaining tegn tilbage',
    );
    return '$_temp0';
  }

  @override
  String get sdkFormDescriptionLabel => 'Beskrivelse';

  @override
  String sdkFormDescriptionPlaceholderFeature(String appName) {
    return 'Hvad skal $appName kunne?';
  }

  @override
  String sdkFormDescriptionPlaceholderIssue(String appName) {
    return 'Hvad gik galt i $appName?';
  }

  @override
  String get sdkFormEmailLabel => 'Mail';

  @override
  String get sdkFormEmailHelper =>
      'Valgfrit. Vi sender dig en mail, når teamet svarer, eller dit ønske bliver lanceret.';

  @override
  String get sdkFormAddScreenshot => 'Tilføj skærmbillede';

  @override
  String get sdkFormRemoveScreenshot => 'Fjern skærmbillede';

  @override
  String get sdkFormSubmit => 'Send';

  @override
  String get sdkFormSending => 'Sender…';

  @override
  String get sdkFormSubmitError =>
      'Kunne ikke sende. Din kladde er gemt. Tjek din forbindelse, og prøv igen.';

  @override
  String get sdkFormTryAgain => 'Prøv igen';

  @override
  String get sdkSuccessTitle => 'Tak! Vi læser hver eneste.';

  @override
  String sdkSuccessBody(String appName) {
    return 'Din feedback gik direkte til $appName-teamet.';
  }

  @override
  String get sdkSuccessBack => 'Tilbage til feedback';

  @override
  String sdkDetailSubmitted(String date) {
    return 'Indsendt $date';
  }

  @override
  String get sdkDetailVote => 'Stem';

  @override
  String sdkDetailVoted(int count) {
    return 'Stemt · $count';
  }

  @override
  String get sdkDetailCommentsTitle => 'Kommentarer';

  @override
  String get sdkDetailCommentPlaceholder => 'Tilføj en kommentar…';

  @override
  String get sdkDetailCommentSend => 'Send';

  @override
  String get sdkDetailAnonymous => 'Anonym';

  @override
  String get sdkDetailTeamBadge => 'Team';

  @override
  String get sdkCommonClose => 'Luk';

  @override
  String get sdkCommonCancel => 'Annuller';

  @override
  String get sdkCommonRetry => 'Prøv igen';

  @override
  String get sdkSandboxBadge => 'SANDBOX';

  @override
  String get sdkFormAttachError =>
      'Billedet kunne ikke vedhæftes. Prøv et andet.';

  @override
  String get sdkFormEmailError => 'Indtast en gyldig e-mailadresse.';

  @override
  String get sdkDetailCommentsDisabled => 'Kommentarer er slået fra.';

  @override
  String get sdkCommonRateLimited =>
      'For mange anmodninger. Prøv igen om lidt.';

  @override
  String get sdkChatAiTag => 'AI';

  @override
  String get sdkChatAssistantName => 'Assistent';

  @override
  String sdkChatAssistantTyping(String name) {
    return '$name skriver…';
  }

  @override
  String get sdkChatComposerPlaceholder => 'Skriv en besked…';

  @override
  String get sdkChatEmailEdit => 'Rediger';

  @override
  String get sdkChatEmailInvalid => 'Indtast en gyldig mailadresse.';

  @override
  String get sdkChatEmailPlaceholder => 'Din mailadresse';

  @override
  String get sdkChatEmailPrompt => 'Få svar på mail';

  @override
  String get sdkChatEmailSave => 'Gem';

  @override
  String get sdkChatEmailSaved => 'Mail til svar';

  @override
  String get sdkChatEmptyGreeting =>
      'Hej! Send os en besked, så svarer vores team dig her.';

  @override
  String get sdkChatLoadEarlier => 'Indlæs tidligere beskeder';

  @override
  String get sdkChatMessageUs => 'Skriv til os';

  @override
  String get sdkChatNotSentRetry => 'Ikke sendt — Tryk for at prøve igen';

  @override
  String get sdkChatSend => 'Send';

  @override
  String get sdkChatSending => 'Sender…';

  @override
  String get sdkChatTeamLabel => 'Team';

  @override
  String get sdkChatTitle => 'Beskeder';

  @override
  String get sdkChatToday => 'I dag';

  @override
  String sdkChatTooLong(int max) {
    return 'Beskeden er for lang. Grænsen er $max tegn.';
  }

  @override
  String get sdkChatYesterday => 'I går';
}
