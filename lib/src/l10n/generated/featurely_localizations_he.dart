// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'featurely_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hebrew (`he`).
class FeaturelyLocalizationsHe extends FeaturelyLocalizations {
  FeaturelyLocalizationsHe([String locale = 'he']) : super(locale);

  @override
  String get sdkListTitle => 'משוב';

  @override
  String get sdkListNewFeedback => 'משוב חדש';

  @override
  String sdkListEmpty(String appName) {
    return 'עדיין אין כאן כלום — ספרו לנו ראשונים מה $appName צריך לעשות הלאה';
  }

  @override
  String get sdkListLoadError =>
      'לא ניתן לטעון את המשוב. כדאי לבדוק את החיבור לאינטרנט.';

  @override
  String sdkListVotes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count הצבעות',
      two: 'שתי הצבעות',
      one: 'הצבעה אחת',
    );
    return '$_temp0';
  }

  @override
  String sdkListComments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count תגובות',
      two: 'שתי תגובות',
      one: 'תגובה אחת',
    );
    return '$_temp0';
  }

  @override
  String get sdkFilterTitle => 'סינון ומיון';

  @override
  String get sdkFilterSortBy => 'מיון';

  @override
  String get sdkFilterSortMostVoted => 'הכי הרבה הצבעות';

  @override
  String get sdkFilterSortNewest => 'החדשים ביותר';

  @override
  String get sdkFilterSortOldest => 'הישנים ביותר';

  @override
  String get sdkFilterStatus => 'סטטוס';

  @override
  String get sdkFilterStatusAll => 'הכול';

  @override
  String get sdkFilterReset => 'איפוס';

  @override
  String sdkFilterShowResults(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'הצגת $count בקשות',
      two: 'הצגת שתי בקשות',
      one: 'הצגת בקשה אחת',
    );
    return '$_temp0';
  }

  @override
  String sdkFilterShowResultsOverflow(int count) {
    return 'הצגת $count+ בקשות';
  }

  @override
  String get sdkStatusOpen => 'פתוח';

  @override
  String get sdkStatusPlanned => 'מתוכנן';

  @override
  String get sdkStatusInProgress => 'בתהליך';

  @override
  String get sdkStatusDone => 'הושלם';

  @override
  String get sdkFormTypeLabel => 'סוג';

  @override
  String get sdkFormTypeFeature => 'פיצ\'ר';

  @override
  String get sdkFormTypeIssue => 'תקלה';

  @override
  String get sdkFormTitleLabel => 'כותרת';

  @override
  String get sdkFormTitlePlaceholder => 'כמה מילים שמסכמות את זה';

  @override
  String sdkFormTitleCounter(int remaining) {
    String _temp0 = intl.Intl.pluralLogic(
      remaining,
      locale: localeName,
      other: 'נותרו $remaining תווים',
      two: 'נותרו שני תווים',
      one: 'נותר תו אחד',
    );
    return '$_temp0';
  }

  @override
  String get sdkFormDescriptionLabel => 'תיאור';

  @override
  String sdkFormDescriptionPlaceholderFeature(String appName) {
    return 'מה $appName צריך לעשות?';
  }

  @override
  String sdkFormDescriptionPlaceholderIssue(String appName) {
    return 'מה השתבש ב-$appName?';
  }

  @override
  String get sdkFormEmailLabel => 'אימייל';

  @override
  String get sdkFormEmailHelper =>
      'לא חובה. נשלח לך מייל כשהצוות יגיב או כשהבקשה שלך תושק.';

  @override
  String get sdkFormAddScreenshot => 'הוספת צילום מסך';

  @override
  String get sdkFormRemoveScreenshot => 'הסרת צילום המסך';

  @override
  String get sdkFormSubmit => 'שליחה';

  @override
  String get sdkFormSending => 'שולח…';

  @override
  String get sdkFormSubmitError =>
      'השליחה נכשלה. הטיוטה שלך נשמרה. כדאי לבדוק את החיבור ולנסות שוב.';

  @override
  String get sdkFormTryAgain => 'ניסיון נוסף';

  @override
  String get sdkSuccessTitle => 'תודה! אנחנו קוראים כל משוב.';

  @override
  String sdkSuccessBody(String appName) {
    return 'המשוב שלך הגיע ישירות לצוות $appName.';
  }

  @override
  String get sdkSuccessBack => 'חזרה למשוב';

  @override
  String sdkDetailSubmitted(String date) {
    return 'נשלח ב-$date';
  }

  @override
  String get sdkDetailVote => 'הצבעה';

  @override
  String sdkDetailVoted(int count) {
    return 'הצבעת · $count';
  }

  @override
  String get sdkDetailCommentsTitle => 'תגובות';

  @override
  String get sdkDetailCommentPlaceholder => 'הוספת תגובה…';

  @override
  String get sdkDetailCommentSend => 'שליחה';

  @override
  String get sdkDetailAnonymous => 'אנונימי';

  @override
  String get sdkDetailTeamBadge => 'צוות';

  @override
  String get sdkCommonClose => 'סגירה';

  @override
  String get sdkCommonCancel => 'ביטול';

  @override
  String get sdkCommonRetry => 'ניסיון נוסף';

  @override
  String get sdkSandboxBadge => 'SANDBOX';

  @override
  String get sdkFormAttachError =>
      'לא ניתן לצרף את התמונה הזו. נסו תמונה אחרת.';

  @override
  String get sdkFormEmailError => 'הזינו כתובת אימייל תקינה.';

  @override
  String get sdkDetailCommentsDisabled => 'התגובות כובו.';

  @override
  String get sdkCommonRateLimited => 'יותר מדי בקשות. נסו שוב בעוד רגע.';

  @override
  String get sdkChatAssistantName => 'עוזר';

  @override
  String sdkChatAssistantTyping(String name) {
    return '$name מקליד…';
  }

  @override
  String get sdkChatComposerPlaceholder => 'כתיבת הודעה…';

  @override
  String get sdkChatEmptyGreeting =>
      'היי! שלחו לנו הודעה והצוות שלנו יחזור אליכם כאן.';

  @override
  String get sdkChatLoadEarlier => 'טעינת הודעות קודמות';

  @override
  String get sdkChatMessageUs => 'כתבו לנו';

  @override
  String get sdkChatNotSentRetry => 'לא נשלח — הקישו לניסיון חוזר';

  @override
  String get sdkChatSend => 'שליחה';

  @override
  String get sdkChatSending => 'שולח…';

  @override
  String get sdkChatTeamLabel => 'צוות';

  @override
  String get sdkChatTitle => 'הודעות';

  @override
  String get sdkChatToday => 'היום';

  @override
  String sdkChatTooLong(int max) {
    return 'ההודעה ארוכה מדי. המגבלה היא $max תווים.';
  }

  @override
  String get sdkChatYesterday => 'אתמול';
}
