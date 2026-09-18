// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'featurely_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Norwegian Bokmål (`nb`).
class FeaturelyLocalizationsNb extends FeaturelyLocalizations {
  FeaturelyLocalizationsNb([String locale = 'nb']) : super(locale);

  @override
  String get sdkListTitle => 'Tilbakemeldinger';

  @override
  String get sdkListNewFeedback => 'Ny tilbakemelding';

  @override
  String sdkListEmpty(String appName) {
    return 'Ingenting her ennå — vær den første til å fortelle oss hva $appName bør gjøre videre';
  }

  @override
  String get sdkListLoadError =>
      'Kunne ikke laste tilbakemeldinger. Sjekk tilkoblingen din.';

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
  String get sdkFilterTitle => 'Filtrer og sorter';

  @override
  String get sdkFilterSortBy => 'Sorter';

  @override
  String get sdkFilterSortMostVoted => 'Flest stemmer';

  @override
  String get sdkFilterSortNewest => 'Nyeste';

  @override
  String get sdkFilterSortOldest => 'Eldste';

  @override
  String get sdkFilterStatus => 'Status';

  @override
  String get sdkFilterStatusAll => 'Alle';

  @override
  String get sdkFilterReset => 'Tilbakestill';

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
  String get sdkStatusOpen => 'Åpen';

  @override
  String get sdkStatusPlanned => 'Planlagt';

  @override
  String get sdkStatusInProgress => 'Pågår';

  @override
  String get sdkStatusDone => 'Fullført';

  @override
  String get sdkFormTypeLabel => 'Type';

  @override
  String get sdkFormTypeFeature => 'Funksjon';

  @override
  String get sdkFormTypeIssue => 'Problem';

  @override
  String get sdkFormTitleLabel => 'Tittel';

  @override
  String get sdkFormTitlePlaceholder => 'Oppsummer det med noen få ord';

  @override
  String sdkFormTitleCounter(int remaining) {
    String _temp0 = intl.Intl.pluralLogic(
      remaining,
      locale: localeName,
      other: '$remaining tegn igjen',
      one: '$remaining tegn igjen',
    );
    return '$_temp0';
  }

  @override
  String get sdkFormDescriptionLabel => 'Beskrivelse';

  @override
  String sdkFormDescriptionPlaceholderFeature(String appName) {
    return 'Hva bør $appName kunne gjøre?';
  }

  @override
  String sdkFormDescriptionPlaceholderIssue(String appName) {
    return 'Hva gikk galt i $appName?';
  }

  @override
  String get sdkFormEmailLabel => 'E-post';

  @override
  String get sdkFormEmailHelper =>
      'Valgfritt. Vi sender deg en e-post når teamet svarer eller ønsket ditt blir lansert.';

  @override
  String get sdkFormAddScreenshot => 'Legg til skjermbilde';

  @override
  String get sdkFormRemoveScreenshot => 'Fjern skjermbilde';

  @override
  String get sdkFormSubmit => 'Send inn';

  @override
  String get sdkFormSending => 'Sender…';

  @override
  String get sdkFormSubmitError =>
      'Kunne ikke sende. Utkastet ditt er lagret. Sjekk tilkoblingen din og prøv igjen.';

  @override
  String get sdkFormTryAgain => 'Prøv igjen';

  @override
  String get sdkSuccessTitle => 'Takk! Vi leser hver eneste en.';

  @override
  String sdkSuccessBody(String appName) {
    return 'Tilbakemeldingen din gikk rett til $appName-teamet.';
  }

  @override
  String get sdkSuccessBack => 'Tilbake til tilbakemeldinger';

  @override
  String sdkDetailSubmitted(String date) {
    return 'Sendt inn $date';
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
  String get sdkDetailCommentPlaceholder => 'Legg til en kommentar…';

  @override
  String get sdkDetailCommentSend => 'Send';

  @override
  String get sdkDetailAnonymous => 'Anonym';

  @override
  String get sdkDetailTeamBadge => 'Team';

  @override
  String get sdkCommonClose => 'Lukk';

  @override
  String get sdkCommonCancel => 'Avbryt';

  @override
  String get sdkCommonRetry => 'Prøv igjen';

  @override
  String get sdkSandboxBadge => 'SANDBOX';

  @override
  String get sdkFormAttachError =>
      'Kunne ikke legge ved dette bildet. Prøv et annet.';

  @override
  String get sdkFormEmailError => 'Skriv inn en gyldig e-postadresse.';

  @override
  String get sdkDetailCommentsDisabled => 'Kommentarer er slått av.';

  @override
  String get sdkCommonRateLimited =>
      'For mange forespørsler. Prøv igjen om litt.';

  @override
  String get sdkChatAiTag => 'KI';

  @override
  String get sdkChatAssistantName => 'Assistent';

  @override
  String sdkChatAssistantTyping(String name) {
    return '$name skriver…';
  }

  @override
  String get sdkChatComposerPlaceholder => 'Skriv en melding…';

  @override
  String get sdkChatEmailEdit => 'Rediger';

  @override
  String get sdkChatEmailInvalid => 'Skriv inn en gyldig e-postadresse.';

  @override
  String get sdkChatEmailPlaceholder => 'E-postadressen din';

  @override
  String get sdkChatEmailPrompt => 'Få svar på e-post';

  @override
  String get sdkChatEmailSave => 'Lagre';

  @override
  String get sdkChatEmailSaved => 'E-post for svar';

  @override
  String get sdkChatEmptyGreeting =>
      'Hei! Send oss en melding, så svarer teamet vårt deg her.';

  @override
  String get sdkChatLoadEarlier => 'Last inn tidligere meldinger';

  @override
  String get sdkChatMessageUs => 'Send oss en melding';

  @override
  String get sdkChatNotSentRetry => 'Ikke sendt — Trykk for å prøve igjen';

  @override
  String get sdkChatSend => 'Send';

  @override
  String get sdkChatSending => 'Sender…';

  @override
  String get sdkChatTeamLabel => 'Team';

  @override
  String get sdkChatTitle => 'Meldinger';

  @override
  String get sdkChatToday => 'I dag';

  @override
  String sdkChatTooLong(int max) {
    return 'Meldingen er for lang. Grensen er $max tegn.';
  }

  @override
  String get sdkChatYesterday => 'I går';
}
