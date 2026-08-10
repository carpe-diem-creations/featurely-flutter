// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'featurely_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class FeaturelyLocalizationsTh extends FeaturelyLocalizations {
  FeaturelyLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get sdkListTitle => 'ข้อเสนอแนะ';

  @override
  String get sdkListNewFeedback => 'ส่งข้อเสนอแนะใหม่';

  @override
  String sdkListEmpty(String appName) {
    return 'ยังไม่มีอะไรที่นี่ — มาเป็นคนแรกที่บอกเราว่า $appName ควรทำอะไรต่อไป';
  }

  @override
  String get sdkListLoadError =>
      'โหลดข้อเสนอแนะไม่สำเร็จ โปรดตรวจสอบการเชื่อมต่อของคุณ';

  @override
  String sdkListVotes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count โหวต',
    );
    return '$_temp0';
  }

  @override
  String sdkListComments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ความคิดเห็น',
    );
    return '$_temp0';
  }

  @override
  String get sdkFilterTitle => 'กรองและจัดเรียง';

  @override
  String get sdkFilterSortBy => 'จัดเรียง';

  @override
  String get sdkFilterSortMostVoted => 'โหวตมากที่สุด';

  @override
  String get sdkFilterSortNewest => 'ใหม่ที่สุด';

  @override
  String get sdkFilterSortOldest => 'เก่าที่สุด';

  @override
  String get sdkFilterStatus => 'สถานะ';

  @override
  String get sdkFilterStatusAll => 'ทั้งหมด';

  @override
  String get sdkFilterReset => 'รีเซ็ต';

  @override
  String sdkFilterShowResults(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'แสดง $count คำขอ',
    );
    return '$_temp0';
  }

  @override
  String sdkFilterShowResultsOverflow(int count) {
    return 'แสดง $count+ คำขอ';
  }

  @override
  String get sdkStatusOpen => 'เปิดรับ';

  @override
  String get sdkStatusPlanned => 'วางแผนแล้ว';

  @override
  String get sdkStatusInProgress => 'กำลังดำเนินการ';

  @override
  String get sdkStatusDone => 'เสร็จสิ้น';

  @override
  String get sdkFormTypeLabel => 'ประเภท';

  @override
  String get sdkFormTypeFeature => 'ฟีเจอร์';

  @override
  String get sdkFormTypeIssue => 'ปัญหา';

  @override
  String get sdkFormTitleLabel => 'หัวข้อ';

  @override
  String get sdkFormTitlePlaceholder => 'สรุปสั้น ๆ ในไม่กี่คำ';

  @override
  String sdkFormTitleCounter(int remaining) {
    String _temp0 = intl.Intl.pluralLogic(
      remaining,
      locale: localeName,
      other: 'เหลืออีก $remaining ตัวอักษร',
    );
    return '$_temp0';
  }

  @override
  String get sdkFormDescriptionLabel => 'รายละเอียด';

  @override
  String sdkFormDescriptionPlaceholderFeature(String appName) {
    return 'คุณอยากให้ $appName ทำอะไรได้บ้าง';
  }

  @override
  String sdkFormDescriptionPlaceholderIssue(String appName) {
    return 'เกิดอะไรขึ้นใน $appName';
  }

  @override
  String get sdkFormEmailLabel => 'อีเมล';

  @override
  String get sdkFormEmailHelper =>
      'ไม่บังคับ เราจะส่งอีเมลแจ้งคุณเมื่อทีมตอบกลับหรือคำขอของคุณเปิดให้ใช้งาน';

  @override
  String get sdkFormAddScreenshot => 'เพิ่มภาพหน้าจอ';

  @override
  String get sdkFormRemoveScreenshot => 'ลบภาพหน้าจอ';

  @override
  String get sdkFormSubmit => 'ส่ง';

  @override
  String get sdkFormSending => 'กำลังส่ง…';

  @override
  String get sdkFormSubmitError =>
      'ส่งไม่สำเร็จ ระบบบันทึกฉบับร่างของคุณไว้แล้ว โปรดตรวจสอบการเชื่อมต่อแล้วลองอีกครั้ง';

  @override
  String get sdkFormTryAgain => 'ลองอีกครั้ง';

  @override
  String get sdkSuccessTitle => 'ขอบคุณ! เราอ่านทุกข้อความที่ส่งเข้ามา';

  @override
  String sdkSuccessBody(String appName) {
    return 'ข้อเสนอแนะของคุณถูกส่งตรงถึงทีม $appName แล้ว';
  }

  @override
  String get sdkSuccessBack => 'กลับไปที่ข้อเสนอแนะ';

  @override
  String sdkDetailSubmitted(String date) {
    return 'ส่งเมื่อ $date';
  }

  @override
  String get sdkDetailVote => 'โหวต';

  @override
  String sdkDetailVoted(int count) {
    return 'โหวตแล้ว · $count';
  }

  @override
  String get sdkDetailCommentsTitle => 'ความคิดเห็น';

  @override
  String get sdkDetailCommentPlaceholder => 'เพิ่มความคิดเห็น…';

  @override
  String get sdkDetailCommentSend => 'ส่ง';

  @override
  String get sdkDetailAnonymous => 'ไม่ระบุชื่อ';

  @override
  String get sdkDetailTeamBadge => 'ทีม';

  @override
  String get sdkCommonClose => 'ปิด';

  @override
  String get sdkCommonCancel => 'ยกเลิก';

  @override
  String get sdkCommonRetry => 'ลองใหม่';

  @override
  String get sdkSandboxBadge => 'SANDBOX';

  @override
  String get sdkFormAttachError => 'แนบรูปภาพนี้ไม่ได้ ลองรูปอื่นดู';

  @override
  String get sdkFormEmailError => 'กรอกอีเมลที่ถูกต้อง';

  @override
  String get sdkDetailCommentsDisabled => 'การแสดงความคิดเห็นถูกปิดไว้';

  @override
  String get sdkCommonRateLimited => 'คำขอมากเกินไป ลองอีกครั้งในอีกสักครู่';
}
