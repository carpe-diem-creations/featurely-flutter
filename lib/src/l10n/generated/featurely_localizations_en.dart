// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'featurely_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class FeaturelyLocalizationsEn extends FeaturelyLocalizations {
  FeaturelyLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get sdkListTitle => 'Feedback';

  @override
  String get sdkListNewFeedback => 'New feedback';

  @override
  String sdkListEmpty(String appName) {
    return 'Nothing here yet — be the first to tell us what $appName should do next';
  }

  @override
  String get sdkListLoadError =>
      'Couldn\'t load feedback. Check your connection.';

  @override
  String sdkListVotes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count votes',
      one: '$count vote',
    );
    return '$_temp0';
  }

  @override
  String sdkListComments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count comments',
      one: '$count comment',
    );
    return '$_temp0';
  }

  @override
  String get sdkFilterTitle => 'Filter & sort';

  @override
  String get sdkFilterSortBy => 'Sort';

  @override
  String get sdkFilterSortMostVoted => 'Most voted';

  @override
  String get sdkFilterSortNewest => 'Newest';

  @override
  String get sdkFilterSortOldest => 'Oldest';

  @override
  String get sdkFilterStatus => 'Status';

  @override
  String get sdkFilterStatusAll => 'All';

  @override
  String get sdkFilterReset => 'Reset';

  @override
  String sdkFilterShowResults(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Show $count requests',
      one: 'Show $count request',
    );
    return '$_temp0';
  }

  @override
  String get sdkStatusOpen => 'Open';

  @override
  String get sdkStatusPlanned => 'Planned';

  @override
  String get sdkStatusInProgress => 'In Progress';

  @override
  String get sdkStatusDone => 'Done';

  @override
  String get sdkFormTypeLabel => 'Type';

  @override
  String get sdkFormTypeFeature => 'Feature';

  @override
  String get sdkFormTypeIssue => 'Issue';

  @override
  String get sdkFormTitleLabel => 'Title';

  @override
  String get sdkFormTitlePlaceholder => 'Sum it up in a few words';

  @override
  String sdkFormTitleCounter(int remaining) {
    String _temp0 = intl.Intl.pluralLogic(
      remaining,
      locale: localeName,
      other: '$remaining characters left',
      one: '$remaining character left',
    );
    return '$_temp0';
  }

  @override
  String get sdkFormDescriptionLabel => 'Description';

  @override
  String sdkFormDescriptionPlaceholderFeature(String appName) {
    return 'What should $appName do? Tell us how you\'d use it.';
  }

  @override
  String sdkFormDescriptionPlaceholderIssue(String appName) {
    return 'What went wrong in $appName? Include what you expected to happen.';
  }

  @override
  String get sdkFormEmailLabel => 'Email';

  @override
  String get sdkFormEmailHelper =>
      'Optional. We\'ll email you when the team replies or your request ships.';

  @override
  String get sdkFormAddScreenshot => 'Add screenshot';

  @override
  String get sdkFormRemoveScreenshot => 'Remove screenshot';

  @override
  String get sdkFormSubmit => 'Submit';

  @override
  String get sdkFormSending => 'Sending…';

  @override
  String get sdkFormSubmitError =>
      'Couldn\'t send. Your draft is saved. Check your connection and try again.';

  @override
  String get sdkFormTryAgain => 'Try again';

  @override
  String get sdkSuccessTitle => 'Thanks! We read every one of these.';

  @override
  String sdkSuccessBody(String appName) {
    return 'Your feedback went straight to the $appName team.';
  }

  @override
  String get sdkSuccessBack => 'Back to feedback';

  @override
  String sdkDetailSubmitted(String date) {
    return 'Submitted $date';
  }

  @override
  String get sdkDetailVote => 'Vote';

  @override
  String sdkDetailVoted(int count) {
    return 'Voted · $count';
  }

  @override
  String get sdkDetailCommentsTitle => 'Comments';

  @override
  String get sdkDetailCommentPlaceholder => 'Add a comment…';

  @override
  String get sdkDetailCommentSend => 'Send';

  @override
  String get sdkDetailAnonymous => 'Anonymous';

  @override
  String get sdkDetailTeamBadge => 'Team';

  @override
  String get sdkCommonClose => 'Close';

  @override
  String get sdkCommonCancel => 'Cancel';

  @override
  String get sdkCommonRetry => 'Retry';

  @override
  String get sdkSandboxBadge => 'SANDBOX';

  @override
  String get sdkFormAttachError =>
      'Couldn\'t attach that image. Try a different one.';

  @override
  String get sdkFormEmailError => 'Enter a valid email address.';

  @override
  String get sdkDetailCommentsDisabled => 'Commenting has been turned off.';

  @override
  String get sdkCommonRateLimited =>
      'Too many requests. Try again in a moment.';
}
