// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'featurely_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class FeaturelyLocalizationsUk extends FeaturelyLocalizations {
  FeaturelyLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get sdkListTitle => 'Відгуки';

  @override
  String get sdkListNewFeedback => 'Новий відгук';

  @override
  String sdkListEmpty(String appName) {
    return 'Тут поки порожньо — розкажи першим, що $appName має зробити далі';
  }

  @override
  String get sdkListLoadError =>
      'Не вдалося завантажити відгуки. Перевір зʼєднання.';

  @override
  String sdkListVotes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count голосу',
      many: '$count голосів',
      few: '$count голоси',
      one: '$count голос',
    );
    return '$_temp0';
  }

  @override
  String sdkListComments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count коментаря',
      many: '$count коментарів',
      few: '$count коментарі',
      one: '$count коментар',
    );
    return '$_temp0';
  }

  @override
  String get sdkFilterTitle => 'Фільтр і сортування';

  @override
  String get sdkFilterSortBy => 'Сортування';

  @override
  String get sdkFilterSortMostVoted => 'Найбільше голосів';

  @override
  String get sdkFilterSortNewest => 'Спочатку нові';

  @override
  String get sdkFilterSortOldest => 'Спочатку старі';

  @override
  String get sdkFilterStatus => 'Статус';

  @override
  String get sdkFilterStatusAll => 'Усі';

  @override
  String get sdkFilterReset => 'Скинути';

  @override
  String sdkFilterShowResults(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Показати $count запиту',
      many: 'Показати $count запитів',
      few: 'Показати $count запити',
      one: 'Показати $count запит',
    );
    return '$_temp0';
  }

  @override
  String sdkFilterShowResultsOverflow(int count) {
    return 'Показати $count+ запитів';
  }

  @override
  String get sdkStatusOpen => 'Відкрито';

  @override
  String get sdkStatusPlanned => 'Заплановано';

  @override
  String get sdkStatusInProgress => 'У роботі';

  @override
  String get sdkStatusDone => 'Готово';

  @override
  String get sdkFormTypeLabel => 'Тип';

  @override
  String get sdkFormTypeFeature => 'Функція';

  @override
  String get sdkFormTypeIssue => 'Проблема';

  @override
  String get sdkFormTitleLabel => 'Заголовок';

  @override
  String get sdkFormTitlePlaceholder => 'Опиши суть кількома словами';

  @override
  String sdkFormTitleCounter(int remaining) {
    String _temp0 = intl.Intl.pluralLogic(
      remaining,
      locale: localeName,
      other: 'Залишилося $remaining символу',
      many: 'Залишилося $remaining символів',
      few: 'Залишилося $remaining символи',
      one: 'Залишився $remaining символ',
    );
    return '$_temp0';
  }

  @override
  String get sdkFormDescriptionLabel => 'Опис';

  @override
  String sdkFormDescriptionPlaceholderFeature(String appName) {
    return 'Що має зʼявитися в $appName?';
  }

  @override
  String sdkFormDescriptionPlaceholderIssue(String appName) {
    return 'Що пішло не так у $appName?';
  }

  @override
  String get sdkFormEmailLabel => 'Email';

  @override
  String get sdkFormEmailHelper =>
      'Необовʼязково. Ми напишемо тобі, коли команда відповість або запит буде реалізовано.';

  @override
  String get sdkFormAddScreenshot => 'Додати скриншот';

  @override
  String get sdkFormRemoveScreenshot => 'Видалити скриншот';

  @override
  String get sdkFormSubmit => 'Надіслати';

  @override
  String get sdkFormSending => 'Надсилання…';

  @override
  String get sdkFormSubmitError =>
      'Не вдалося надіслати. Чернетку збережено. Перевір зʼєднання і спробуй ще раз.';

  @override
  String get sdkFormTryAgain => 'Спробувати ще раз';

  @override
  String get sdkSuccessTitle => 'Дякуємо! Ми читаємо кожен відгук.';

  @override
  String sdkSuccessBody(String appName) {
    return 'Твій відгук потрапив прямо до команди $appName.';
  }

  @override
  String get sdkSuccessBack => 'До відгуків';

  @override
  String sdkDetailSubmitted(String date) {
    return 'Надіслано $date';
  }

  @override
  String get sdkDetailVote => 'Голосувати';

  @override
  String sdkDetailVoted(int count) {
    return 'Голос враховано · $count';
  }

  @override
  String get sdkDetailCommentsTitle => 'Коментарі';

  @override
  String get sdkDetailCommentPlaceholder => 'Додати коментар…';

  @override
  String get sdkDetailCommentSend => 'Надіслати';

  @override
  String get sdkDetailAnonymous => 'Анонім';

  @override
  String get sdkDetailTeamBadge => 'Команда';

  @override
  String get sdkCommonClose => 'Закрити';

  @override
  String get sdkCommonCancel => 'Скасувати';

  @override
  String get sdkCommonRetry => 'Повторити';

  @override
  String get sdkSandboxBadge => 'SANDBOX';

  @override
  String get sdkFormAttachError =>
      'Не вдалося прикріпити це зображення. Спробуйте інше.';

  @override
  String get sdkFormEmailError => 'Введіть дійсну адресу електронної пошти.';

  @override
  String get sdkDetailCommentsDisabled => 'Коментарі вимкнено.';

  @override
  String get sdkCommonRateLimited =>
      'Забагато запитів. Спробуйте ще раз за мить.';

  @override
  String get sdkChatComposerPlaceholder => 'Напиши повідомлення…';

  @override
  String get sdkChatEmailEdit => 'Редагувати';

  @override
  String get sdkChatEmailInvalid => 'Введи коректну електронну адресу.';

  @override
  String get sdkChatEmailPlaceholder => 'Твоя електронна адреса';

  @override
  String get sdkChatEmailPrompt => 'Отримувати відповіді поштою';

  @override
  String get sdkChatEmailSave => 'Зберегти';

  @override
  String get sdkChatEmailSaved => 'Пошта для відповідей';

  @override
  String get sdkChatEmptyGreeting =>
      'Привіт! Напиши нам, і наша команда відповість тобі тут.';

  @override
  String get sdkChatLoadEarlier => 'Завантажити попередні повідомлення';

  @override
  String get sdkChatMessageUs => 'Написати нам';

  @override
  String get sdkChatNotSentRetry => 'Не надіслано — Торкнись, щоб повторити';

  @override
  String get sdkChatSend => 'Надіслати';

  @override
  String get sdkChatSending => 'Надсилання…';

  @override
  String get sdkChatTeamLabel => 'Команда';

  @override
  String get sdkChatTitle => 'Повідомлення';

  @override
  String get sdkChatToday => 'Сьогодні';

  @override
  String sdkChatTooLong(int max) {
    return 'Повідомлення задовге. Ліміт — $max символів.';
  }

  @override
  String get sdkChatYesterday => 'Учора';
}
