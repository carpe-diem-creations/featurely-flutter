// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'featurely_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bulgarian (`bg`).
class FeaturelyLocalizationsBg extends FeaturelyLocalizations {
  FeaturelyLocalizationsBg([String locale = 'bg']) : super(locale);

  @override
  String get sdkListTitle => 'Обратна връзка';

  @override
  String get sdkListNewFeedback => 'Ново мнение';

  @override
  String sdkListEmpty(String appName) {
    return 'Тук още няма нищо — бъди първият, който ще ни каже какво да прави $appName занапред';
  }

  @override
  String get sdkListLoadError =>
      'Обратната връзка не можа да се зареди. Провери връзката си.';

  @override
  String sdkListVotes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count гласа',
      one: '$count глас',
    );
    return '$_temp0';
  }

  @override
  String sdkListComments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count коментара',
      one: '$count коментар',
    );
    return '$_temp0';
  }

  @override
  String get sdkFilterTitle => 'Филтриране и сортиране';

  @override
  String get sdkFilterSortBy => 'Сортиране';

  @override
  String get sdkFilterSortMostVoted => 'Най-много гласове';

  @override
  String get sdkFilterSortNewest => 'Най-нови';

  @override
  String get sdkFilterSortOldest => 'Най-стари';

  @override
  String get sdkFilterStatus => 'Статус';

  @override
  String get sdkFilterStatusAll => 'Всички';

  @override
  String get sdkFilterReset => 'Нулиране';

  @override
  String sdkFilterShowResults(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Покажи $count предложения',
      one: 'Покажи $count предложение',
    );
    return '$_temp0';
  }

  @override
  String sdkFilterShowResultsOverflow(int count) {
    return 'Покажи $count+ предложения';
  }

  @override
  String get sdkStatusOpen => 'Отворено';

  @override
  String get sdkStatusPlanned => 'Планирано';

  @override
  String get sdkStatusInProgress => 'В процес';

  @override
  String get sdkStatusDone => 'Готово';

  @override
  String get sdkFormTypeLabel => 'Тип';

  @override
  String get sdkFormTypeFeature => 'Функция';

  @override
  String get sdkFormTypeIssue => 'Проблем';

  @override
  String get sdkFormTitleLabel => 'Заглавие';

  @override
  String get sdkFormTitlePlaceholder => 'Опиши го с няколко думи';

  @override
  String sdkFormTitleCounter(int remaining) {
    String _temp0 = intl.Intl.pluralLogic(
      remaining,
      locale: localeName,
      other: 'Остават $remaining знака',
      one: 'Остава $remaining знак',
    );
    return '$_temp0';
  }

  @override
  String get sdkFormDescriptionLabel => 'Описание';

  @override
  String sdkFormDescriptionPlaceholderFeature(String appName) {
    return 'Какво да прави $appName?';
  }

  @override
  String sdkFormDescriptionPlaceholderIssue(String appName) {
    return 'Какво се обърка в $appName?';
  }

  @override
  String get sdkFormEmailLabel => 'Имейл';

  @override
  String get sdkFormEmailHelper =>
      'По избор. Ще ти пишем по имейл, когато екипът отговори или предложението ти бъде реализирано.';

  @override
  String get sdkFormAddScreenshot => 'Добави екранна снимка';

  @override
  String get sdkFormRemoveScreenshot => 'Премахни екранната снимка';

  @override
  String get sdkFormSubmit => 'Изпрати';

  @override
  String get sdkFormSending => 'Изпращане…';

  @override
  String get sdkFormSubmitError =>
      'Изпращането не бе успешно. Черновата ти е запазена. Провери връзката си и опитай отново.';

  @override
  String get sdkFormTryAgain => 'Опитай отново';

  @override
  String get sdkSuccessTitle => 'Благодарим! Четем всяко едно мнение.';

  @override
  String sdkSuccessBody(String appName) {
    return 'Обратната ти връзка отиде директно при екипа на $appName.';
  }

  @override
  String get sdkSuccessBack => 'Обратно към мненията';

  @override
  String sdkDetailSubmitted(String date) {
    return 'Изпратено на $date';
  }

  @override
  String get sdkDetailVote => 'Гласувай';

  @override
  String sdkDetailVoted(int count) {
    return 'Гласувано · $count';
  }

  @override
  String get sdkDetailCommentsTitle => 'Коментари';

  @override
  String get sdkDetailCommentPlaceholder => 'Добави коментар…';

  @override
  String get sdkDetailCommentSend => 'Изпрати';

  @override
  String get sdkDetailAnonymous => 'Анонимен';

  @override
  String get sdkDetailTeamBadge => 'Екип';

  @override
  String get sdkCommonClose => 'Затвори';

  @override
  String get sdkCommonCancel => 'Отказ';

  @override
  String get sdkCommonRetry => 'Опитай отново';

  @override
  String get sdkSandboxBadge => 'SANDBOX';

  @override
  String get sdkFormAttachError =>
      'Изображението не можа да бъде прикачено. Опитай с друго.';

  @override
  String get sdkFormEmailError => 'Въведи валиден имейл адрес.';

  @override
  String get sdkDetailCommentsDisabled => 'Коментарите са изключени.';

  @override
  String get sdkCommonRateLimited =>
      'Твърде много заявки. Опитай отново след малко.';

  @override
  String get sdkChatComposerPlaceholder => 'Напиши съобщение…';

  @override
  String get sdkChatEmailEdit => 'Редактирай';

  @override
  String get sdkChatEmailInvalid => 'Въведи валиден имейл адрес.';

  @override
  String get sdkChatEmailPlaceholder => 'Твоят имейл адрес';

  @override
  String get sdkChatEmailPrompt => 'Получавай отговорите по имейл';

  @override
  String get sdkChatEmailSave => 'Запази';

  @override
  String get sdkChatEmailSaved => 'Имейл за отговори';

  @override
  String get sdkChatEmptyGreeting =>
      'Здравей! Изпрати ни съобщение и нашият екип ще ти отговори тук.';

  @override
  String get sdkChatLoadEarlier => 'Зареди по-стари съобщения';

  @override
  String get sdkChatMessageUs => 'Пиши ни';

  @override
  String get sdkChatNotSentRetry =>
      'Не е изпратено — Докосни, за да опиташ отново';

  @override
  String get sdkChatSend => 'Изпрати';

  @override
  String get sdkChatSending => 'Изпращане…';

  @override
  String get sdkChatTeamLabel => 'Екип';

  @override
  String get sdkChatTitle => 'Съобщения';

  @override
  String sdkChatTooLong(int max) {
    return 'Съобщението е твърде дълго. Ограничението е $max знака.';
  }
}
