// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'featurely_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Romanian Moldavian Moldovan (`ro`).
class FeaturelyLocalizationsRo extends FeaturelyLocalizations {
  FeaturelyLocalizationsRo([String locale = 'ro']) : super(locale);

  @override
  String get sdkListTitle => 'Feedback';

  @override
  String get sdkListNewFeedback => 'Feedback nou';

  @override
  String sdkListEmpty(String appName) {
    return 'Încă nu e nimic aici — fii primul care ne spune ce ar trebui să facă $appName în continuare';
  }

  @override
  String get sdkListLoadError =>
      'Nu am putut încărca feedbackul. Verifică-ți conexiunea.';

  @override
  String sdkListVotes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count de voturi',
      few: '$count voturi',
      one: '$count vot',
    );
    return '$_temp0';
  }

  @override
  String sdkListComments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count de comentarii',
      few: '$count comentarii',
      one: '$count comentariu',
    );
    return '$_temp0';
  }

  @override
  String get sdkFilterTitle => 'Filtrare și sortare';

  @override
  String get sdkFilterSortBy => 'Sortează';

  @override
  String get sdkFilterSortMostVoted => 'Cele mai votate';

  @override
  String get sdkFilterSortNewest => 'Cele mai noi';

  @override
  String get sdkFilterSortOldest => 'Cele mai vechi';

  @override
  String get sdkFilterStatus => 'Stare';

  @override
  String get sdkFilterStatusAll => 'Toate';

  @override
  String get sdkFilterReset => 'Resetează';

  @override
  String sdkFilterShowResults(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Arată $count de solicitări',
      few: 'Arată $count solicitări',
      one: 'Arată $count solicitare',
    );
    return '$_temp0';
  }

  @override
  String sdkFilterShowResultsOverflow(int count) {
    return 'Arată $count+ solicitări';
  }

  @override
  String get sdkStatusOpen => 'Deschis';

  @override
  String get sdkStatusPlanned => 'Planificat';

  @override
  String get sdkStatusInProgress => 'În lucru';

  @override
  String get sdkStatusDone => 'Finalizat';

  @override
  String get sdkFormTypeLabel => 'Tip';

  @override
  String get sdkFormTypeFeature => 'Funcționalitate';

  @override
  String get sdkFormTypeIssue => 'Problemă';

  @override
  String get sdkFormTitleLabel => 'Titlu';

  @override
  String get sdkFormTitlePlaceholder => 'Rezumă în câteva cuvinte';

  @override
  String sdkFormTitleCounter(int remaining) {
    String _temp0 = intl.Intl.pluralLogic(
      remaining,
      locale: localeName,
      other: 'Au mai rămas $remaining de caractere',
      few: 'Au mai rămas $remaining caractere',
      one: 'A mai rămas $remaining caracter',
    );
    return '$_temp0';
  }

  @override
  String get sdkFormDescriptionLabel => 'Descriere';

  @override
  String sdkFormDescriptionPlaceholderFeature(String appName) {
    return 'Ce ar trebui să facă $appName?';
  }

  @override
  String sdkFormDescriptionPlaceholderIssue(String appName) {
    return 'Ce nu a mers bine în $appName?';
  }

  @override
  String get sdkFormEmailLabel => 'E-mail';

  @override
  String get sdkFormEmailHelper =>
      'Opțional. Îți scriem pe e-mail când echipa răspunde sau când solicitarea ta este lansată.';

  @override
  String get sdkFormAddScreenshot => 'Adaugă o captură de ecran';

  @override
  String get sdkFormRemoveScreenshot => 'Elimină captura de ecran';

  @override
  String get sdkFormSubmit => 'Trimite';

  @override
  String get sdkFormSending => 'Se trimite…';

  @override
  String get sdkFormSubmitError =>
      'Nu s-a putut trimite. Ciorna ta a fost salvată. Verifică-ți conexiunea și încearcă din nou.';

  @override
  String get sdkFormTryAgain => 'Încearcă din nou';

  @override
  String get sdkSuccessTitle => 'Mulțumim! Citim fiecare mesaj.';

  @override
  String sdkSuccessBody(String appName) {
    return 'Feedbackul tău a ajuns direct la echipa $appName.';
  }

  @override
  String get sdkSuccessBack => 'Înapoi la feedback';

  @override
  String sdkDetailSubmitted(String date) {
    return 'Trimis pe $date';
  }

  @override
  String get sdkDetailVote => 'Votează';

  @override
  String sdkDetailVoted(int count) {
    return 'Votat · $count';
  }

  @override
  String get sdkDetailCommentsTitle => 'Comentarii';

  @override
  String get sdkDetailCommentPlaceholder => 'Adaugă un comentariu…';

  @override
  String get sdkDetailCommentSend => 'Trimite';

  @override
  String get sdkDetailAnonymous => 'Anonim';

  @override
  String get sdkDetailTeamBadge => 'Echipă';

  @override
  String get sdkCommonClose => 'Închide';

  @override
  String get sdkCommonCancel => 'Anulează';

  @override
  String get sdkCommonRetry => 'Reîncearcă';

  @override
  String get sdkSandboxBadge => 'SANDBOX';

  @override
  String get sdkFormAttachError => 'Nu am putut atașa imaginea. Încearcă alta.';

  @override
  String get sdkFormEmailError => 'Introdu o adresă de e-mail validă.';

  @override
  String get sdkDetailCommentsDisabled => 'Comentariile au fost dezactivate.';

  @override
  String get sdkCommonRateLimited =>
      'Prea multe cereri. Încearcă din nou în câteva momente.';

  @override
  String get sdkChatAssistantName => 'Asistent';

  @override
  String sdkChatAssistantTyping(String name) {
    return '$name scrie…';
  }

  @override
  String get sdkChatComposerPlaceholder => 'Scrie un mesaj…';

  @override
  String get sdkChatEmptyGreeting =>
      'Salut! Trimite-ne un mesaj și echipa noastră îți va răspunde aici.';

  @override
  String get sdkChatLoadEarlier => 'Încarcă mesajele anterioare';

  @override
  String get sdkChatMessageUs => 'Scrie-ne';

  @override
  String get sdkChatNotSentRetry => 'Netrimis — atinge pentru a reîncerca';

  @override
  String get sdkChatSend => 'Trimite';

  @override
  String get sdkChatSending => 'Se trimite…';

  @override
  String get sdkChatTeamLabel => 'Echipă';

  @override
  String get sdkChatTitle => 'Mesaje';

  @override
  String get sdkChatToday => 'Astăzi';

  @override
  String sdkChatTooLong(int max) {
    return 'Mesajul este prea lung. Limita este de $max de caractere.';
  }

  @override
  String get sdkChatYesterday => 'Ieri';
}
