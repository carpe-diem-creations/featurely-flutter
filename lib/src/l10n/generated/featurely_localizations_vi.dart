// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'featurely_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class FeaturelyLocalizationsVi extends FeaturelyLocalizations {
  FeaturelyLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get sdkListTitle => 'Phản hồi';

  @override
  String get sdkListNewFeedback => 'Phản hồi mới';

  @override
  String sdkListEmpty(String appName) {
    return 'Chưa có gì ở đây — hãy là người đầu tiên cho chúng tôi biết $appName nên làm gì tiếp theo';
  }

  @override
  String get sdkListLoadError =>
      'Không tải được phản hồi. Vui lòng kiểm tra kết nối mạng.';

  @override
  String sdkListVotes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lượt bình chọn',
    );
    return '$_temp0';
  }

  @override
  String sdkListComments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count bình luận',
    );
    return '$_temp0';
  }

  @override
  String get sdkFilterTitle => 'Lọc & sắp xếp';

  @override
  String get sdkFilterSortBy => 'Sắp xếp';

  @override
  String get sdkFilterSortMostVoted => 'Nhiều bình chọn nhất';

  @override
  String get sdkFilterSortNewest => 'Mới nhất';

  @override
  String get sdkFilterSortOldest => 'Cũ nhất';

  @override
  String get sdkFilterStatus => 'Trạng thái';

  @override
  String get sdkFilterStatusAll => 'Tất cả';

  @override
  String get sdkFilterReset => 'Đặt lại';

  @override
  String sdkFilterShowResults(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Xem $count yêu cầu',
    );
    return '$_temp0';
  }

  @override
  String sdkFilterShowResultsOverflow(int count) {
    return 'Xem $count+ yêu cầu';
  }

  @override
  String get sdkStatusOpen => 'Đang mở';

  @override
  String get sdkStatusPlanned => 'Đã lên kế hoạch';

  @override
  String get sdkStatusInProgress => 'Đang thực hiện';

  @override
  String get sdkStatusDone => 'Hoàn thành';

  @override
  String get sdkFormTypeLabel => 'Loại';

  @override
  String get sdkFormTypeFeature => 'Tính năng';

  @override
  String get sdkFormTypeIssue => 'Sự cố';

  @override
  String get sdkFormTitleLabel => 'Tiêu đề';

  @override
  String get sdkFormTitlePlaceholder => 'Tóm tắt trong vài từ';

  @override
  String sdkFormTitleCounter(int remaining) {
    String _temp0 = intl.Intl.pluralLogic(
      remaining,
      locale: localeName,
      other: 'Còn $remaining ký tự',
    );
    return '$_temp0';
  }

  @override
  String get sdkFormDescriptionLabel => 'Mô tả';

  @override
  String sdkFormDescriptionPlaceholderFeature(String appName) {
    return 'Bạn muốn $appName làm được gì?';
  }

  @override
  String sdkFormDescriptionPlaceholderIssue(String appName) {
    return 'Đã xảy ra lỗi gì trong $appName?';
  }

  @override
  String get sdkFormEmailLabel => 'Email';

  @override
  String get sdkFormEmailHelper =>
      'Không bắt buộc. Chúng tôi sẽ gửi email cho bạn khi đội ngũ trả lời hoặc yêu cầu của bạn được ra mắt.';

  @override
  String get sdkFormAddScreenshot => 'Thêm ảnh chụp màn hình';

  @override
  String get sdkFormRemoveScreenshot => 'Xóa ảnh chụp màn hình';

  @override
  String get sdkFormSubmit => 'Gửi';

  @override
  String get sdkFormSending => 'Đang gửi…';

  @override
  String get sdkFormSubmitError =>
      'Không gửi được. Bản nháp của bạn đã được lưu. Vui lòng kiểm tra kết nối và thử lại.';

  @override
  String get sdkFormTryAgain => 'Thử lại';

  @override
  String get sdkSuccessTitle => 'Cảm ơn bạn! Chúng tôi đọc từng phản hồi một.';

  @override
  String sdkSuccessBody(String appName) {
    return 'Phản hồi của bạn đã được gửi thẳng đến đội ngũ $appName.';
  }

  @override
  String get sdkSuccessBack => 'Quay lại phản hồi';

  @override
  String sdkDetailSubmitted(String date) {
    return 'Đã gửi $date';
  }

  @override
  String get sdkDetailVote => 'Bình chọn';

  @override
  String sdkDetailVoted(int count) {
    return 'Đã bình chọn · $count';
  }

  @override
  String get sdkDetailCommentsTitle => 'Bình luận';

  @override
  String get sdkDetailCommentPlaceholder => 'Thêm bình luận…';

  @override
  String get sdkDetailCommentSend => 'Gửi';

  @override
  String get sdkDetailAnonymous => 'Ẩn danh';

  @override
  String get sdkDetailTeamBadge => 'Đội ngũ';

  @override
  String get sdkCommonClose => 'Đóng';

  @override
  String get sdkCommonCancel => 'Hủy';

  @override
  String get sdkCommonRetry => 'Thử lại';

  @override
  String get sdkSandboxBadge => 'SANDBOX';

  @override
  String get sdkFormAttachError =>
      'Không thể đính kèm ảnh này. Hãy thử ảnh khác.';

  @override
  String get sdkFormEmailError => 'Nhập địa chỉ email hợp lệ.';

  @override
  String get sdkDetailCommentsDisabled => 'Bình luận đã bị tắt.';

  @override
  String get sdkCommonRateLimited =>
      'Quá nhiều yêu cầu. Hãy thử lại sau giây lát.';

  @override
  String get sdkChatAiTag => 'AI';

  @override
  String get sdkChatAssistantName => 'Trợ lý';

  @override
  String sdkChatAssistantTyping(String name) {
    return '$name đang nhập…';
  }

  @override
  String get sdkChatComposerPlaceholder => 'Viết tin nhắn…';

  @override
  String get sdkChatEmailEdit => 'Sửa';

  @override
  String get sdkChatEmailInvalid => 'Hãy nhập địa chỉ email hợp lệ.';

  @override
  String get sdkChatEmailPlaceholder => 'Địa chỉ email của bạn';

  @override
  String get sdkChatEmailPrompt => 'Nhận phản hồi qua email';

  @override
  String get sdkChatEmailSave => 'Lưu';

  @override
  String get sdkChatEmailSaved => 'Email nhận phản hồi';

  @override
  String get sdkChatEmptyGreeting =>
      'Xin chào! Hãy gửi tin nhắn cho chúng tôi, đội ngũ sẽ trả lời bạn tại đây.';

  @override
  String get sdkChatLoadEarlier => 'Tải tin nhắn cũ hơn';

  @override
  String get sdkChatMessageUs => 'Nhắn cho chúng tôi';

  @override
  String get sdkChatNotSentRetry => 'Chưa gửi được — Nhấn để thử lại';

  @override
  String get sdkChatSend => 'Gửi';

  @override
  String get sdkChatSending => 'Đang gửi…';

  @override
  String get sdkChatTeamLabel => 'Đội ngũ';

  @override
  String get sdkChatTitle => 'Tin nhắn';

  @override
  String get sdkChatToday => 'Hôm nay';

  @override
  String sdkChatTooLong(int max) {
    return 'Tin nhắn này quá dài. Giới hạn là $max ký tự.';
  }

  @override
  String get sdkChatYesterday => 'Hôm qua';
}
