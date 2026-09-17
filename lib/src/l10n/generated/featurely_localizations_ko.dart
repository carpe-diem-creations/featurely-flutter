// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'featurely_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class FeaturelyLocalizationsKo extends FeaturelyLocalizations {
  FeaturelyLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get sdkListTitle => '피드백';

  @override
  String get sdkListNewFeedback => '새 피드백';

  @override
  String sdkListEmpty(String appName) {
    return '아직 아무것도 없어요. $appName에 바라는 점을 가장 먼저 알려주세요';
  }

  @override
  String get sdkListLoadError => '피드백을 불러오지 못했어요. 연결 상태를 확인해 주세요.';

  @override
  String sdkListVotes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '투표 $count개',
    );
    return '$_temp0';
  }

  @override
  String sdkListComments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '댓글 $count개',
    );
    return '$_temp0';
  }

  @override
  String get sdkFilterTitle => '필터 및 정렬';

  @override
  String get sdkFilterSortBy => '정렬';

  @override
  String get sdkFilterSortMostVoted => '투표순';

  @override
  String get sdkFilterSortNewest => '최신순';

  @override
  String get sdkFilterSortOldest => '오래된순';

  @override
  String get sdkFilterStatus => '상태';

  @override
  String get sdkFilterStatusAll => '전체';

  @override
  String get sdkFilterReset => '초기화';

  @override
  String sdkFilterShowResults(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '요청 $count개 보기',
    );
    return '$_temp0';
  }

  @override
  String sdkFilterShowResultsOverflow(int count) {
    return '요청 $count개 이상 보기';
  }

  @override
  String get sdkStatusOpen => '접수됨';

  @override
  String get sdkStatusPlanned => '예정됨';

  @override
  String get sdkStatusInProgress => '진행 중';

  @override
  String get sdkStatusDone => '완료';

  @override
  String get sdkFormTypeLabel => '유형';

  @override
  String get sdkFormTypeFeature => '기능';

  @override
  String get sdkFormTypeIssue => '문제';

  @override
  String get sdkFormTitleLabel => '제목';

  @override
  String get sdkFormTitlePlaceholder => '몇 마디로 요약해 주세요';

  @override
  String sdkFormTitleCounter(int remaining) {
    String _temp0 = intl.Intl.pluralLogic(
      remaining,
      locale: localeName,
      other: '$remaining자 남음',
    );
    return '$_temp0';
  }

  @override
  String get sdkFormDescriptionLabel => '설명';

  @override
  String sdkFormDescriptionPlaceholderFeature(String appName) {
    return '$appName에 어떤 기능이 있으면 좋을까요?';
  }

  @override
  String sdkFormDescriptionPlaceholderIssue(String appName) {
    return '$appName에서 어떤 문제가 있었나요?';
  }

  @override
  String get sdkFormEmailLabel => '이메일';

  @override
  String get sdkFormEmailHelper =>
      '선택 사항이에요. 팀이 답변하거나 요청하신 내용이 출시되면 이메일로 알려드릴게요.';

  @override
  String get sdkFormAddScreenshot => '스크린샷 추가';

  @override
  String get sdkFormRemoveScreenshot => '스크린샷 삭제';

  @override
  String get sdkFormSubmit => '보내기';

  @override
  String get sdkFormSending => '보내는 중…';

  @override
  String get sdkFormSubmitError =>
      '보내지 못했어요. 작성한 내용은 저장되어 있어요. 연결 상태를 확인하고 다시 시도해 주세요.';

  @override
  String get sdkFormTryAgain => '다시 시도';

  @override
  String get sdkSuccessTitle => '감사해요! 모든 의견을 빠짐없이 읽고 있어요.';

  @override
  String sdkSuccessBody(String appName) {
    return '피드백이 $appName 팀에 바로 전달되었어요.';
  }

  @override
  String get sdkSuccessBack => '피드백으로 돌아가기';

  @override
  String sdkDetailSubmitted(String date) {
    return '$date에 등록됨';
  }

  @override
  String get sdkDetailVote => '투표';

  @override
  String sdkDetailVoted(int count) {
    return '투표함 · $count';
  }

  @override
  String get sdkDetailCommentsTitle => '댓글';

  @override
  String get sdkDetailCommentPlaceholder => '댓글 추가…';

  @override
  String get sdkDetailCommentSend => '보내기';

  @override
  String get sdkDetailAnonymous => '익명';

  @override
  String get sdkDetailTeamBadge => '팀';

  @override
  String get sdkCommonClose => '닫기';

  @override
  String get sdkCommonCancel => '취소';

  @override
  String get sdkCommonRetry => '다시 시도';

  @override
  String get sdkSandboxBadge => 'SANDBOX';

  @override
  String get sdkFormAttachError => '이 이미지를 첨부할 수 없습니다. 다른 이미지를 사용해 보세요.';

  @override
  String get sdkFormEmailError => '올바른 이메일 주소를 입력하세요.';

  @override
  String get sdkDetailCommentsDisabled => '댓글 기능이 꺼져 있습니다.';

  @override
  String get sdkCommonRateLimited => '요청이 너무 많습니다. 잠시 후 다시 시도하세요.';

  @override
  String get sdkChatComposerPlaceholder => '메시지 입력…';

  @override
  String get sdkChatEmailEdit => '수정';

  @override
  String get sdkChatEmailInvalid => '올바른 이메일 주소를 입력해 주세요.';

  @override
  String get sdkChatEmailPlaceholder => '이메일 주소';

  @override
  String get sdkChatEmailPrompt => '이메일로 답변 받기';

  @override
  String get sdkChatEmailSave => '저장';

  @override
  String get sdkChatEmailSaved => '답변 받을 이메일';

  @override
  String get sdkChatEmptyGreeting => '안녕하세요! 메시지를 보내 주시면 저희 팀이 여기에서 답변해 드릴게요.';

  @override
  String get sdkChatLoadEarlier => '이전 메시지 불러오기';

  @override
  String get sdkChatMessageUs => '문의하기';

  @override
  String get sdkChatNotSentRetry => '전송 실패 — 탭하여 다시 시도';

  @override
  String get sdkChatSend => '보내기';

  @override
  String get sdkChatSending => '보내는 중…';

  @override
  String get sdkChatTeamLabel => '팀';

  @override
  String get sdkChatTitle => '메시지';

  @override
  String get sdkChatToday => '오늘';

  @override
  String sdkChatTooLong(int max) {
    return '메시지가 너무 길어요. 최대 $max자까지 입력할 수 있어요.';
  }

  @override
  String get sdkChatYesterday => '어제';
}
