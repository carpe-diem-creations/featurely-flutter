// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'featurely_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class FeaturelyLocalizationsZh extends FeaturelyLocalizations {
  FeaturelyLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get sdkListTitle => '反馈';

  @override
  String get sdkListNewFeedback => '新反馈';

  @override
  String sdkListEmpty(String appName) {
    return '这里还空空如也——来做第一个告诉我们 $appName 接下来该做什么的人吧';
  }

  @override
  String get sdkListLoadError => '无法加载反馈，请检查网络连接。';

  @override
  String sdkListVotes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 票',
    );
    return '$_temp0';
  }

  @override
  String sdkListComments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 条评论',
    );
    return '$_temp0';
  }

  @override
  String get sdkFilterTitle => '筛选与排序';

  @override
  String get sdkFilterSortBy => '排序';

  @override
  String get sdkFilterSortMostVoted => '最多投票';

  @override
  String get sdkFilterSortNewest => '最新';

  @override
  String get sdkFilterSortOldest => '最早';

  @override
  String get sdkFilterStatus => '状态';

  @override
  String get sdkFilterStatusAll => '全部';

  @override
  String get sdkFilterReset => '重置';

  @override
  String sdkFilterShowResults(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '查看 $count 条请求',
    );
    return '$_temp0';
  }

  @override
  String sdkFilterShowResultsOverflow(int count) {
    return '查看 $count+ 条请求';
  }

  @override
  String get sdkStatusOpen => '待处理';

  @override
  String get sdkStatusPlanned => '已计划';

  @override
  String get sdkStatusInProgress => '进行中';

  @override
  String get sdkStatusDone => '已完成';

  @override
  String get sdkFormTypeLabel => '类型';

  @override
  String get sdkFormTypeFeature => '功能';

  @override
  String get sdkFormTypeIssue => '问题';

  @override
  String get sdkFormTitleLabel => '标题';

  @override
  String get sdkFormTitlePlaceholder => '用几个字概括一下';

  @override
  String sdkFormTitleCounter(int remaining) {
    String _temp0 = intl.Intl.pluralLogic(
      remaining,
      locale: localeName,
      other: '还可输入 $remaining 个字符',
    );
    return '$_temp0';
  }

  @override
  String get sdkFormDescriptionLabel => '描述';

  @override
  String sdkFormDescriptionPlaceholderFeature(String appName) {
    return '你希望 $appName 能做什么？';
  }

  @override
  String sdkFormDescriptionPlaceholderIssue(String appName) {
    return '$appName 出了什么问题？';
  }

  @override
  String get sdkFormEmailLabel => '邮箱';

  @override
  String get sdkFormEmailHelper => '选填。团队回复或你的请求上线时，我们会通过邮件通知你。';

  @override
  String get sdkFormAddScreenshot => '添加截图';

  @override
  String get sdkFormRemoveScreenshot => '移除截图';

  @override
  String get sdkFormSubmit => '提交';

  @override
  String get sdkFormSending => '发送中…';

  @override
  String get sdkFormSubmitError => '发送失败。草稿已保存，请检查网络连接后重试。';

  @override
  String get sdkFormTryAgain => '重试';

  @override
  String get sdkSuccessTitle => '谢谢！每一条反馈我们都会认真阅读。';

  @override
  String sdkSuccessBody(String appName) {
    return '你的反馈已直接送达 $appName 团队。';
  }

  @override
  String get sdkSuccessBack => '返回反馈列表';

  @override
  String sdkDetailSubmitted(String date) {
    return '提交于 $date';
  }

  @override
  String get sdkDetailVote => '投票';

  @override
  String sdkDetailVoted(int count) {
    return '已投票 · $count';
  }

  @override
  String get sdkDetailCommentsTitle => '评论';

  @override
  String get sdkDetailCommentPlaceholder => '添加评论…';

  @override
  String get sdkDetailCommentSend => '发送';

  @override
  String get sdkDetailAnonymous => '匿名';

  @override
  String get sdkDetailTeamBadge => '团队';

  @override
  String get sdkCommonClose => '关闭';

  @override
  String get sdkCommonCancel => '取消';

  @override
  String get sdkCommonRetry => '重试';

  @override
  String get sdkSandboxBadge => 'SANDBOX';

  @override
  String get sdkFormAttachError => '无法附加该图片，请换一张试试。';

  @override
  String get sdkFormEmailError => '请输入有效的电子邮件地址。';

  @override
  String get sdkDetailCommentsDisabled => '评论功能已关闭。';

  @override
  String get sdkCommonRateLimited => '请求过多，请稍后再试。';

  @override
  String get sdkChatComposerPlaceholder => '输入消息…';

  @override
  String get sdkChatEmailEdit => '编辑';

  @override
  String get sdkChatEmailInvalid => '请输入有效的邮箱地址。';

  @override
  String get sdkChatEmailPlaceholder => '你的邮箱地址';

  @override
  String get sdkChatEmailPrompt => '通过邮件接收回复';

  @override
  String get sdkChatEmailSave => '保存';

  @override
  String get sdkChatEmailSaved => '接收回复的邮箱';

  @override
  String get sdkChatEmptyGreeting => '你好！给我们发条消息，我们的团队会在这里回复你。';

  @override
  String get sdkChatLoadEarlier => '加载更早的消息';

  @override
  String get sdkChatMessageUs => '联系我们';

  @override
  String get sdkChatNotSentRetry => '未发送 — 轻点重试';

  @override
  String get sdkChatSend => '发送';

  @override
  String get sdkChatSending => '正在发送…';

  @override
  String get sdkChatTeamLabel => '团队';

  @override
  String get sdkChatTitle => '消息';

  @override
  String get sdkChatToday => '今天';

  @override
  String sdkChatTooLong(int max) {
    return '消息过长，上限为 $max 个字符。';
  }

  @override
  String get sdkChatYesterday => '昨天';
}

/// The translations for Chinese, using the Han script (`zh_Hant`).
class FeaturelyLocalizationsZhHant extends FeaturelyLocalizationsZh {
  FeaturelyLocalizationsZhHant() : super('zh_Hant');

  @override
  String get sdkListTitle => '回饋';

  @override
  String get sdkListNewFeedback => '新增回饋';

  @override
  String sdkListEmpty(String appName) {
    return '這裡還沒有任何內容，快來第一個告訴我們 $appName 接下來該做什麼吧';
  }

  @override
  String get sdkListLoadError => '無法載入回饋，請檢查網路連線。';

  @override
  String sdkListVotes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 票',
    );
    return '$_temp0';
  }

  @override
  String sdkListComments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 則留言',
    );
    return '$_temp0';
  }

  @override
  String get sdkFilterTitle => '篩選與排序';

  @override
  String get sdkFilterSortBy => '排序';

  @override
  String get sdkFilterSortMostVoted => '最多票';

  @override
  String get sdkFilterSortNewest => '最新';

  @override
  String get sdkFilterSortOldest => '最舊';

  @override
  String get sdkFilterStatus => '狀態';

  @override
  String get sdkFilterStatusAll => '全部';

  @override
  String get sdkFilterReset => '重設';

  @override
  String sdkFilterShowResults(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '顯示 $count 則請求',
    );
    return '$_temp0';
  }

  @override
  String sdkFilterShowResultsOverflow(int count) {
    return '顯示 $count+ 則請求';
  }

  @override
  String get sdkStatusOpen => '待處理';

  @override
  String get sdkStatusPlanned => '已規劃';

  @override
  String get sdkStatusInProgress => '進行中';

  @override
  String get sdkStatusDone => '已完成';

  @override
  String get sdkFormTypeLabel => '類型';

  @override
  String get sdkFormTypeFeature => '功能';

  @override
  String get sdkFormTypeIssue => '問題';

  @override
  String get sdkFormTitleLabel => '標題';

  @override
  String get sdkFormTitlePlaceholder => '用幾個字簡單描述';

  @override
  String sdkFormTitleCounter(int remaining) {
    String _temp0 = intl.Intl.pluralLogic(
      remaining,
      locale: localeName,
      other: '還可輸入 $remaining 個字元',
    );
    return '$_temp0';
  }

  @override
  String get sdkFormDescriptionLabel => '說明';

  @override
  String sdkFormDescriptionPlaceholderFeature(String appName) {
    return '你希望 $appName 能做什麼？';
  }

  @override
  String sdkFormDescriptionPlaceholderIssue(String appName) {
    return '$appName 發生了什麼問題？';
  }

  @override
  String get sdkFormEmailLabel => '電子郵件';

  @override
  String get sdkFormEmailHelper => '選填。團隊回覆或你的請求正式推出時，我們會以電子郵件通知你。';

  @override
  String get sdkFormAddScreenshot => '新增螢幕截圖';

  @override
  String get sdkFormRemoveScreenshot => '移除螢幕截圖';

  @override
  String get sdkFormSubmit => '送出';

  @override
  String get sdkFormSending => '傳送中…';

  @override
  String get sdkFormSubmitError => '無法傳送。草稿已儲存，請檢查網路連線後再試一次。';

  @override
  String get sdkFormTryAgain => '再試一次';

  @override
  String get sdkSuccessTitle => '謝謝！每一則回饋我們都會仔細閱讀。';

  @override
  String sdkSuccessBody(String appName) {
    return '你的回饋已直接送達 $appName 團隊。';
  }

  @override
  String get sdkSuccessBack => '返回回饋列表';

  @override
  String sdkDetailSubmitted(String date) {
    return '提交於 $date';
  }

  @override
  String get sdkDetailVote => '投票';

  @override
  String sdkDetailVoted(int count) {
    return '已投票 · $count';
  }

  @override
  String get sdkDetailCommentsTitle => '留言';

  @override
  String get sdkDetailCommentPlaceholder => '新增留言…';

  @override
  String get sdkDetailCommentSend => '傳送';

  @override
  String get sdkDetailAnonymous => '匿名';

  @override
  String get sdkDetailTeamBadge => '團隊';

  @override
  String get sdkCommonClose => '關閉';

  @override
  String get sdkCommonCancel => '取消';

  @override
  String get sdkCommonRetry => '重試';

  @override
  String get sdkSandboxBadge => 'SANDBOX';

  @override
  String get sdkFormAttachError => '無法附加這張圖片，請換一張試試。';

  @override
  String get sdkFormEmailError => '請輸入有效的電子郵件地址。';

  @override
  String get sdkDetailCommentsDisabled => '留言功能已關閉。';

  @override
  String get sdkCommonRateLimited => '請求次數過多，請稍後再試。';

  @override
  String get sdkChatComposerPlaceholder => '輸入訊息…';

  @override
  String get sdkChatEmailEdit => '編輯';

  @override
  String get sdkChatEmailInvalid => '請輸入有效的電子郵件地址。';

  @override
  String get sdkChatEmailPlaceholder => '你的電子郵件地址';

  @override
  String get sdkChatEmailPrompt => '透過電子郵件接收回覆';

  @override
  String get sdkChatEmailSave => '儲存';

  @override
  String get sdkChatEmailSaved => '接收回覆的電子郵件';

  @override
  String get sdkChatEmptyGreeting => '你好！傳訊息給我們，我們的團隊會在這裡回覆你。';

  @override
  String get sdkChatLoadEarlier => '載入較早的訊息';

  @override
  String get sdkChatMessageUs => '聯絡我們';

  @override
  String get sdkChatNotSentRetry => '未傳送，點一下即可重試';

  @override
  String get sdkChatSend => '傳送';

  @override
  String get sdkChatSending => '正在傳送…';

  @override
  String get sdkChatTeamLabel => '團隊';

  @override
  String get sdkChatTitle => '訊息';

  @override
  String get sdkChatToday => '今天';

  @override
  String sdkChatTooLong(int max) {
    return '訊息過長，上限為 $max 個字元。';
  }

  @override
  String get sdkChatYesterday => '昨天';
}
