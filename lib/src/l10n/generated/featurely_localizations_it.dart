// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'featurely_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class FeaturelyLocalizationsIt extends FeaturelyLocalizations {
  FeaturelyLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get sdkListTitle => 'Feedback';

  @override
  String get sdkListNewFeedback => 'Nuovo feedback';

  @override
  String sdkListEmpty(String appName) {
    return 'Ancora niente qui — sii il primo a dirci cosa dovrebbe fare $appName';
  }

  @override
  String get sdkListLoadError =>
      'Impossibile caricare il feedback. Controlla la connessione.';

  @override
  String sdkListVotes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count voti',
      one: '$count voto',
    );
    return '$_temp0';
  }

  @override
  String sdkListComments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count commenti',
      one: '$count commento',
    );
    return '$_temp0';
  }

  @override
  String get sdkFilterTitle => 'Filtra e ordina';

  @override
  String get sdkFilterSortBy => 'Ordina';

  @override
  String get sdkFilterSortMostVoted => 'Più votati';

  @override
  String get sdkFilterSortNewest => 'Più recenti';

  @override
  String get sdkFilterSortOldest => 'Meno recenti';

  @override
  String get sdkFilterStatus => 'Stato';

  @override
  String get sdkFilterStatusAll => 'Tutti';

  @override
  String get sdkFilterReset => 'Reimposta';

  @override
  String sdkFilterShowResults(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mostra $count richieste',
      one: 'Mostra $count richiesta',
    );
    return '$_temp0';
  }

  @override
  String sdkFilterShowResultsOverflow(int count) {
    return 'Mostra $count+ richieste';
  }

  @override
  String get sdkStatusOpen => 'Aperto';

  @override
  String get sdkStatusPlanned => 'Pianificato';

  @override
  String get sdkStatusInProgress => 'In corso';

  @override
  String get sdkStatusDone => 'Completato';

  @override
  String get sdkFormTypeLabel => 'Tipo';

  @override
  String get sdkFormTypeFeature => 'Funzionalità';

  @override
  String get sdkFormTypeIssue => 'Problema';

  @override
  String get sdkFormTitleLabel => 'Titolo';

  @override
  String get sdkFormTitlePlaceholder => 'Riassumi in poche parole';

  @override
  String sdkFormTitleCounter(int remaining) {
    String _temp0 = intl.Intl.pluralLogic(
      remaining,
      locale: localeName,
      other: '$remaining caratteri rimasti',
      one: '$remaining carattere rimasto',
    );
    return '$_temp0';
  }

  @override
  String get sdkFormDescriptionLabel => 'Descrizione';

  @override
  String sdkFormDescriptionPlaceholderFeature(String appName) {
    return 'Cosa dovrebbe fare $appName?';
  }

  @override
  String sdkFormDescriptionPlaceholderIssue(String appName) {
    return 'Cosa è andato storto in $appName?';
  }

  @override
  String get sdkFormEmailLabel => 'Email';

  @override
  String get sdkFormEmailHelper =>
      'Facoltativo. Ti invieremo un\'email quando il team risponde o la tua richiesta sarà disponibile.';

  @override
  String get sdkFormAddScreenshot => 'Aggiungi screenshot';

  @override
  String get sdkFormRemoveScreenshot => 'Rimuovi screenshot';

  @override
  String get sdkFormSubmit => 'Invia';

  @override
  String get sdkFormSending => 'Invio in corso…';

  @override
  String get sdkFormSubmitError =>
      'Impossibile inviare. La bozza è salvata. Controlla la connessione e riprova.';

  @override
  String get sdkFormTryAgain => 'Riprova';

  @override
  String get sdkSuccessTitle => 'Grazie! Leggiamo ogni singolo messaggio.';

  @override
  String sdkSuccessBody(String appName) {
    return 'Il tuo feedback è arrivato direttamente al team di $appName.';
  }

  @override
  String get sdkSuccessBack => 'Torna al feedback';

  @override
  String sdkDetailSubmitted(String date) {
    return 'Inviato il $date';
  }

  @override
  String get sdkDetailVote => 'Vota';

  @override
  String sdkDetailVoted(int count) {
    return 'Votato · $count';
  }

  @override
  String get sdkDetailCommentsTitle => 'Commenti';

  @override
  String get sdkDetailCommentPlaceholder => 'Aggiungi un commento…';

  @override
  String get sdkDetailCommentSend => 'Invia';

  @override
  String get sdkDetailAnonymous => 'Anonimo';

  @override
  String get sdkDetailTeamBadge => 'Team';

  @override
  String get sdkCommonClose => 'Chiudi';

  @override
  String get sdkCommonCancel => 'Annulla';

  @override
  String get sdkCommonRetry => 'Riprova';

  @override
  String get sdkSandboxBadge => 'SANDBOX';

  @override
  String get sdkFormAttachError =>
      'Impossibile allegare questa immagine. Provane un\'altra.';

  @override
  String get sdkFormEmailError => 'Inserisci un indirizzo email valido.';

  @override
  String get sdkDetailCommentsDisabled => 'I commenti sono stati disattivati.';

  @override
  String get sdkCommonRateLimited =>
      'Troppe richieste. Riprova tra un momento.';

  @override
  String get sdkChatComposerPlaceholder => 'Scrivi un messaggio…';

  @override
  String get sdkChatEmailEdit => 'Modifica';

  @override
  String get sdkChatEmailInvalid => 'Inserisci un indirizzo email valido.';

  @override
  String get sdkChatEmailPlaceholder => 'Il tuo indirizzo email';

  @override
  String get sdkChatEmailPrompt => 'Ricevi le risposte via email';

  @override
  String get sdkChatEmailSave => 'Salva';

  @override
  String get sdkChatEmailSaved => 'Email per le risposte';

  @override
  String get sdkChatEmptyGreeting =>
      'Ciao! Mandaci un messaggio e il nostro team ti risponderà qui.';

  @override
  String get sdkChatLoadEarlier => 'Carica messaggi precedenti';

  @override
  String get sdkChatMessageUs => 'Scrivici';

  @override
  String get sdkChatNotSentRetry => 'Non inviato — Tocca per riprovare';

  @override
  String get sdkChatSend => 'Invia';

  @override
  String get sdkChatSending => 'Invio in corso…';

  @override
  String get sdkChatTeamLabel => 'Team';

  @override
  String get sdkChatTitle => 'Messaggi';

  @override
  String get sdkChatToday => 'Oggi';

  @override
  String sdkChatTooLong(int max) {
    return 'Questo messaggio è troppo lungo. Il limite è di $max caratteri.';
  }

  @override
  String get sdkChatYesterday => 'Ieri';
}
