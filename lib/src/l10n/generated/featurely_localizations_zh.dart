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
    return '你希望 $appName 能做什么？说说你会怎么使用它。';
  }

  @override
  String sdkFormDescriptionPlaceholderIssue(String appName) {
    return '$appName 出了什么问题？请说明你期望的结果。';
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
}
