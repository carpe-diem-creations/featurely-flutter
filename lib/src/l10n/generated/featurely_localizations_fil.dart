// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'featurely_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Filipino Pilipino (`fil`).
class FeaturelyLocalizationsFil extends FeaturelyLocalizations {
  FeaturelyLocalizationsFil([String locale = 'fil']) : super(locale);

  @override
  String get sdkListTitle => 'Feedback';

  @override
  String get sdkListNewFeedback => 'Bagong feedback';

  @override
  String sdkListEmpty(String appName) {
    return 'Wala pang laman dito — maging una kang magsabi kung ano ang susunod na dapat gawin ng $appName';
  }

  @override
  String get sdkListLoadError =>
      'Hindi ma-load ang feedback. Suriin ang koneksyon mo.';

  @override
  String sdkListVotes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count boto',
      one: '$count boto',
    );
    return '$_temp0';
  }

  @override
  String sdkListComments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count komento',
      one: '$count komento',
    );
    return '$_temp0';
  }

  @override
  String get sdkFilterTitle => 'I-filter at ayusin';

  @override
  String get sdkFilterSortBy => 'Ayusin';

  @override
  String get sdkFilterSortMostVoted => 'Pinakamaraming boto';

  @override
  String get sdkFilterSortNewest => 'Pinakabago';

  @override
  String get sdkFilterSortOldest => 'Pinakaluma';

  @override
  String get sdkFilterStatus => 'Status';

  @override
  String get sdkFilterStatusAll => 'Lahat';

  @override
  String get sdkFilterReset => 'I-reset';

  @override
  String sdkFilterShowResults(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ipakita ang $count kahilingan',
      one: 'Ipakita ang $count kahilingan',
    );
    return '$_temp0';
  }

  @override
  String sdkFilterShowResultsOverflow(int count) {
    return 'Ipakita ang $count+ kahilingan';
  }

  @override
  String get sdkStatusOpen => 'Bukas';

  @override
  String get sdkStatusPlanned => 'Nakaplano';

  @override
  String get sdkStatusInProgress => 'Isinasagawa';

  @override
  String get sdkStatusDone => 'Tapos na';

  @override
  String get sdkFormTypeLabel => 'Uri';

  @override
  String get sdkFormTypeFeature => 'Feature';

  @override
  String get sdkFormTypeIssue => 'Isyu';

  @override
  String get sdkFormTitleLabel => 'Pamagat';

  @override
  String get sdkFormTitlePlaceholder => 'Ibuod ito sa ilang salita';

  @override
  String sdkFormTitleCounter(int remaining) {
    String _temp0 = intl.Intl.pluralLogic(
      remaining,
      locale: localeName,
      other: '$remaining character na lang ang natitira',
      one: '$remaining character na lang ang natitira',
    );
    return '$_temp0';
  }

  @override
  String get sdkFormDescriptionLabel => 'Paglalarawan';

  @override
  String sdkFormDescriptionPlaceholderFeature(String appName) {
    return 'Ano ang dapat gawin ng $appName?';
  }

  @override
  String sdkFormDescriptionPlaceholderIssue(String appName) {
    return 'Ano ang nagkaproblema sa $appName?';
  }

  @override
  String get sdkFormEmailLabel => 'Email';

  @override
  String get sdkFormEmailHelper =>
      'Opsyonal. Mag-e-email kami sa iyo kapag sumagot ang team o nailabas na ang hiniling mo.';

  @override
  String get sdkFormAddScreenshot => 'Magdagdag ng screenshot';

  @override
  String get sdkFormRemoveScreenshot => 'Alisin ang screenshot';

  @override
  String get sdkFormSubmit => 'Ipasa';

  @override
  String get sdkFormSending => 'Ipinapadala…';

  @override
  String get sdkFormSubmitError =>
      'Hindi maipadala. Naka-save ang draft mo. Suriin ang koneksyon mo at subukang muli.';

  @override
  String get sdkFormTryAgain => 'Subukang muli';

  @override
  String get sdkSuccessTitle =>
      'Salamat! Binabasa namin ang bawat isa sa mga ito.';

  @override
  String sdkSuccessBody(String appName) {
    return 'Direktang napunta ang feedback mo sa team ng $appName.';
  }

  @override
  String get sdkSuccessBack => 'Bumalik sa feedback';

  @override
  String sdkDetailSubmitted(String date) {
    return 'Naipasa noong $date';
  }

  @override
  String get sdkDetailVote => 'Bumoto';

  @override
  String sdkDetailVoted(int count) {
    return 'Bumoto na · $count';
  }

  @override
  String get sdkDetailCommentsTitle => 'Mga komento';

  @override
  String get sdkDetailCommentPlaceholder => 'Magdagdag ng komento…';

  @override
  String get sdkDetailCommentSend => 'Ipadala';

  @override
  String get sdkDetailAnonymous => 'Anonymous';

  @override
  String get sdkDetailTeamBadge => 'Team';

  @override
  String get sdkCommonClose => 'Isara';

  @override
  String get sdkCommonCancel => 'Kanselahin';

  @override
  String get sdkCommonRetry => 'Subukang muli';

  @override
  String get sdkSandboxBadge => 'SANDBOX';

  @override
  String get sdkFormAttachError =>
      'Hindi ma-attach ang larawang iyon. Sumubok ng iba.';

  @override
  String get sdkFormEmailError => 'Maglagay ng wastong email address.';

  @override
  String get sdkDetailCommentsDisabled => 'Naka-off ang mga komento.';

  @override
  String get sdkCommonRateLimited =>
      'Masyadong maraming request. Subukan ulit mamaya.';

  @override
  String get sdkChatAiTag => 'AI';

  @override
  String get sdkChatAssistantName => 'Assistant';

  @override
  String sdkChatAssistantTyping(String name) {
    return 'Nagta-type si $name…';
  }

  @override
  String get sdkChatComposerPlaceholder => 'Sumulat ng mensahe…';

  @override
  String get sdkChatEmailEdit => 'I-edit';

  @override
  String get sdkChatEmailInvalid => 'Maglagay ng wastong email address.';

  @override
  String get sdkChatEmailPlaceholder => 'Iyong email address';

  @override
  String get sdkChatEmailPrompt => 'Tumanggap ng mga tugon sa email';

  @override
  String get sdkChatEmailSave => 'I-save';

  @override
  String get sdkChatEmailSaved => 'Email para sa mga tugon';

  @override
  String get sdkChatEmptyGreeting =>
      'Hi! Magpadala sa amin ng mensahe at sasagutin ka ng aming team dito.';

  @override
  String get sdkChatLoadEarlier => 'I-load ang mga naunang mensahe';

  @override
  String get sdkChatMessageUs => 'Magmensahe sa amin';

  @override
  String get sdkChatNotSentRetry =>
      'Hindi naipadala — I-tap para subukang muli';

  @override
  String get sdkChatSend => 'Ipadala';

  @override
  String get sdkChatSending => 'Ipinapadala…';

  @override
  String get sdkChatTeamLabel => 'Team';

  @override
  String get sdkChatTitle => 'Mga Mensahe';

  @override
  String get sdkChatToday => 'Ngayon';

  @override
  String sdkChatTooLong(int max) {
    return 'Masyadong mahaba ang mensaheng ito. Ang limit ay $max na character.';
  }

  @override
  String get sdkChatYesterday => 'Kahapon';
}
