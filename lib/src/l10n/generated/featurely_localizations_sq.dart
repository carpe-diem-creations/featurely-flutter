// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'featurely_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Albanian (`sq`).
class FeaturelyLocalizationsSq extends FeaturelyLocalizations {
  FeaturelyLocalizationsSq([String locale = 'sq']) : super(locale);

  @override
  String get sdkListTitle => 'Reagime';

  @override
  String get sdkListNewFeedback => 'Reagim i ri';

  @override
  String sdkListEmpty(String appName) {
    return 'Ende asgjë këtu — bëhu i pari që na tregon çfarë duhet të bëjë $appName më pas';
  }

  @override
  String get sdkListLoadError => 'Reagimet nuk u ngarkuan. Kontrollo lidhjen.';

  @override
  String sdkListVotes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count vota',
      one: '$count votë',
    );
    return '$_temp0';
  }

  @override
  String sdkListComments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count komente',
      one: '$count koment',
    );
    return '$_temp0';
  }

  @override
  String get sdkFilterTitle => 'Filtro dhe rendit';

  @override
  String get sdkFilterSortBy => 'Rendit';

  @override
  String get sdkFilterSortMostVoted => 'Më të votuarat';

  @override
  String get sdkFilterSortNewest => 'Më të rejat';

  @override
  String get sdkFilterSortOldest => 'Më të vjetrat';

  @override
  String get sdkFilterStatus => 'Statusi';

  @override
  String get sdkFilterStatusAll => 'Të gjitha';

  @override
  String get sdkFilterReset => 'Rivendos';

  @override
  String sdkFilterShowResults(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Shfaq $count kërkesa',
      one: 'Shfaq $count kërkesë',
    );
    return '$_temp0';
  }

  @override
  String sdkFilterShowResultsOverflow(int count) {
    return 'Shfaq $count+ kërkesa';
  }

  @override
  String get sdkStatusOpen => 'Hapur';

  @override
  String get sdkStatusPlanned => 'Planifikuar';

  @override
  String get sdkStatusInProgress => 'Në punim';

  @override
  String get sdkStatusDone => 'Përfunduar';

  @override
  String get sdkFormTypeLabel => 'Lloji';

  @override
  String get sdkFormTypeFeature => 'Funksion';

  @override
  String get sdkFormTypeIssue => 'Problem';

  @override
  String get sdkFormTitleLabel => 'Titulli';

  @override
  String get sdkFormTitlePlaceholder => 'Përmbledhe me pak fjalë';

  @override
  String sdkFormTitleCounter(int remaining) {
    String _temp0 = intl.Intl.pluralLogic(
      remaining,
      locale: localeName,
      other: 'Mbeten $remaining karaktere',
      one: 'Mbetet $remaining karakter',
    );
    return '$_temp0';
  }

  @override
  String get sdkFormDescriptionLabel => 'Përshkrimi';

  @override
  String sdkFormDescriptionPlaceholderFeature(String appName) {
    return 'Çfarë duhet të bëjë $appName?';
  }

  @override
  String sdkFormDescriptionPlaceholderIssue(String appName) {
    return 'Çfarë nuk shkoi mirë në $appName?';
  }

  @override
  String get sdkFormEmailLabel => 'Email';

  @override
  String get sdkFormEmailHelper =>
      'Opsionale. Do të të shkruajmë me email kur ekipi të përgjigjet ose kur kërkesa jote të realizohet.';

  @override
  String get sdkFormAddScreenshot => 'Shto pamje ekrani';

  @override
  String get sdkFormRemoveScreenshot => 'Hiq pamjen e ekranit';

  @override
  String get sdkFormSubmit => 'Dërgo';

  @override
  String get sdkFormSending => 'Po dërgohet…';

  @override
  String get sdkFormSubmitError =>
      'Dërgimi dështoi. Drafti yt u ruajt. Kontrollo lidhjen dhe provo sërish.';

  @override
  String get sdkFormTryAgain => 'Provo sërish';

  @override
  String get sdkSuccessTitle => 'Faleminderit! I lexojmë të gjitha.';

  @override
  String sdkSuccessBody(String appName) {
    return 'Reagimi yt shkoi drejtpërdrejt te ekipi i aplikacionit $appName.';
  }

  @override
  String get sdkSuccessBack => 'Kthehu te reagimet';

  @override
  String sdkDetailSubmitted(String date) {
    return 'Dërguar më $date';
  }

  @override
  String get sdkDetailVote => 'Voto';

  @override
  String sdkDetailVoted(int count) {
    return 'Votove · $count';
  }

  @override
  String get sdkDetailCommentsTitle => 'Komente';

  @override
  String get sdkDetailCommentPlaceholder => 'Shto një koment…';

  @override
  String get sdkDetailCommentSend => 'Dërgo';

  @override
  String get sdkDetailAnonymous => 'Anonim';

  @override
  String get sdkDetailTeamBadge => 'Ekipi';

  @override
  String get sdkCommonClose => 'Mbyll';

  @override
  String get sdkCommonCancel => 'Anulo';

  @override
  String get sdkCommonRetry => 'Provo sërish';

  @override
  String get sdkSandboxBadge => 'SANDBOX';

  @override
  String get sdkFormAttachError =>
      'Imazhi nuk u bashkëngjit dot. Provo një tjetër.';

  @override
  String get sdkFormEmailError => 'Shkruaj një adresë email-i të vlefshme.';

  @override
  String get sdkDetailCommentsDisabled => 'Komentet janë çaktivizuar.';

  @override
  String get sdkCommonRateLimited => 'Shumë kërkesa. Provo sërish pas pak.';

  @override
  String get sdkChatAiTag => 'IA';

  @override
  String get sdkChatAssistantName => 'Asistenti';

  @override
  String sdkChatAssistantTyping(String name) {
    return '$name po shkruan…';
  }

  @override
  String get sdkChatComposerPlaceholder => 'Shkruaj një mesazh…';

  @override
  String get sdkChatEmailEdit => 'Ndrysho';

  @override
  String get sdkChatEmailInvalid => 'Shkruaj një adresë email-i të vlefshme.';

  @override
  String get sdkChatEmailPlaceholder => 'Adresa jote e email-it';

  @override
  String get sdkChatEmailPrompt => 'Merr përgjigjet me email';

  @override
  String get sdkChatEmailSave => 'Ruaj';

  @override
  String get sdkChatEmailSaved => 'Email-i për përgjigjet';

  @override
  String get sdkChatEmptyGreeting =>
      'Përshëndetje! Na dërgo një mesazh dhe ekipi ynë do të të përgjigjet këtu.';

  @override
  String get sdkChatLoadEarlier => 'Ngarko mesazhet e mëparshme';

  @override
  String get sdkChatMessageUs => 'Na shkruaj';

  @override
  String get sdkChatNotSentRetry => 'Nuk u dërgua — Prek për ta provuar sërish';

  @override
  String get sdkChatSend => 'Dërgo';

  @override
  String get sdkChatSending => 'Po dërgohet…';

  @override
  String get sdkChatTeamLabel => 'Ekipi';

  @override
  String get sdkChatTitle => 'Mesazhe';

  @override
  String get sdkChatToday => 'Sot';

  @override
  String sdkChatTooLong(int max) {
    return 'Ky mesazh është shumë i gjatë. Kufiri është $max karaktere.';
  }

  @override
  String get sdkChatYesterday => 'Dje';
}
