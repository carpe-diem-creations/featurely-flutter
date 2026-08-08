// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'featurely_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class FeaturelyLocalizationsAr extends FeaturelyLocalizations {
  FeaturelyLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get sdkListTitle => 'الملاحظات';

  @override
  String get sdkListNewFeedback => 'ملاحظة جديدة';

  @override
  String sdkListEmpty(String appName) {
    return 'لا شيء هنا بعد — كن أول من يخبرنا بما يجب أن يفعله $appName لاحقًا';
  }

  @override
  String get sdkListLoadError =>
      'تعذّر تحميل الملاحظات. تحقق من اتصالك بالإنترنت.';

  @override
  String sdkListVotes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count صوت',
      many: '$count صوتًا',
      few: '$count أصوات',
      two: 'صوتان',
      one: 'صوت واحد',
      zero: 'لا أصوات',
    );
    return '$_temp0';
  }

  @override
  String sdkListComments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count تعليق',
      many: '$count تعليقًا',
      few: '$count تعليقات',
      two: 'تعليقان',
      one: 'تعليق واحد',
      zero: 'لا تعليقات',
    );
    return '$_temp0';
  }

  @override
  String get sdkFilterTitle => 'التصفية والترتيب';

  @override
  String get sdkFilterSortBy => 'الترتيب';

  @override
  String get sdkFilterSortMostVoted => 'الأكثر تصويتًا';

  @override
  String get sdkFilterSortNewest => 'الأحدث';

  @override
  String get sdkFilterSortOldest => 'الأقدم';

  @override
  String get sdkFilterStatus => 'الحالة';

  @override
  String get sdkFilterStatusAll => 'الكل';

  @override
  String get sdkFilterReset => 'إعادة تعيين';

  @override
  String sdkFilterShowResults(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'عرض $count طلب',
      many: 'عرض $count طلبًا',
      few: 'عرض $count طلبات',
      two: 'عرض طلبين',
      one: 'عرض طلب واحد',
      zero: 'لا توجد طلبات',
    );
    return '$_temp0';
  }

  @override
  String sdkFilterShowResultsOverflow(int count) {
    return 'عرض $count+ طلب';
  }

  @override
  String get sdkStatusOpen => 'مفتوح';

  @override
  String get sdkStatusPlanned => 'مخطط له';

  @override
  String get sdkStatusInProgress => 'قيد التنفيذ';

  @override
  String get sdkStatusDone => 'مكتمل';

  @override
  String get sdkFormTypeLabel => 'النوع';

  @override
  String get sdkFormTypeFeature => 'ميزة';

  @override
  String get sdkFormTypeIssue => 'مشكلة';

  @override
  String get sdkFormTitleLabel => 'العنوان';

  @override
  String get sdkFormTitlePlaceholder => 'لخّصها في بضع كلمات';

  @override
  String sdkFormTitleCounter(int remaining) {
    String _temp0 = intl.Intl.pluralLogic(
      remaining,
      locale: localeName,
      other: 'بقي $remaining حرف',
      many: 'بقي $remaining حرفًا',
      few: 'بقيت $remaining أحرف',
      two: 'بقي حرفان',
      one: 'بقي حرف واحد',
      zero: 'لم يتبقَّ أي حرف',
    );
    return '$_temp0';
  }

  @override
  String get sdkFormDescriptionLabel => 'الوصف';

  @override
  String sdkFormDescriptionPlaceholderFeature(String appName) {
    return 'ما الذي يجب أن يفعله $appName؟ أخبرنا كيف ستستخدم هذه الميزة.';
  }

  @override
  String sdkFormDescriptionPlaceholderIssue(String appName) {
    return 'ما الخطأ الذي حدث في $appName؟ اذكر ما كنت تتوقع حدوثه.';
  }

  @override
  String get sdkFormEmailLabel => 'البريد الإلكتروني';

  @override
  String get sdkFormEmailHelper =>
      'اختياري. سنراسلك عبر البريد الإلكتروني عندما يرد الفريق أو يتم إطلاق طلبك.';

  @override
  String get sdkFormAddScreenshot => 'إضافة لقطة شاشة';

  @override
  String get sdkFormRemoveScreenshot => 'إزالة لقطة الشاشة';

  @override
  String get sdkFormSubmit => 'إرسال';

  @override
  String get sdkFormSending => 'جارٍ الإرسال…';

  @override
  String get sdkFormSubmitError =>
      'تعذّر الإرسال. تم حفظ مسودتك. تحقق من اتصالك وحاول مرة أخرى.';

  @override
  String get sdkFormTryAgain => 'حاول مرة أخرى';

  @override
  String get sdkSuccessTitle => 'شكرًا! نحن نقرأ كل ملاحظة تصلنا.';

  @override
  String sdkSuccessBody(String appName) {
    return 'وصلت ملاحظتك مباشرة إلى فريق $appName.';
  }

  @override
  String get sdkSuccessBack => 'العودة إلى الملاحظات';

  @override
  String sdkDetailSubmitted(String date) {
    return 'أُرسلت في $date';
  }

  @override
  String get sdkDetailVote => 'تصويت';

  @override
  String sdkDetailVoted(int count) {
    return 'تم التصويت · $count';
  }

  @override
  String get sdkDetailCommentsTitle => 'التعليقات';

  @override
  String get sdkDetailCommentPlaceholder => 'أضف تعليقًا…';

  @override
  String get sdkDetailCommentSend => 'إرسال';

  @override
  String get sdkDetailAnonymous => 'مجهول';

  @override
  String get sdkDetailTeamBadge => 'الفريق';

  @override
  String get sdkCommonClose => 'إغلاق';

  @override
  String get sdkCommonCancel => 'إلغاء';

  @override
  String get sdkCommonRetry => 'إعادة المحاولة';

  @override
  String get sdkSandboxBadge => 'SANDBOX';

  @override
  String get sdkFormAttachError => 'تعذّر إرفاق هذه الصورة. جرّب صورة أخرى.';

  @override
  String get sdkFormEmailError => 'أدخل عنوان بريد إلكتروني صالحًا.';

  @override
  String get sdkDetailCommentsDisabled => 'تم إيقاف التعليقات.';

  @override
  String get sdkCommonRateLimited =>
      'طلبات كثيرة جدًا. حاول مرة أخرى بعد قليل.';
}
