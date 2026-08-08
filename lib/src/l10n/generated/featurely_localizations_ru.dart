// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'featurely_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class FeaturelyLocalizationsRu extends FeaturelyLocalizations {
  FeaturelyLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get sdkListTitle => 'Отзывы';

  @override
  String get sdkListNewFeedback => 'Новый отзыв';

  @override
  String sdkListEmpty(String appName) {
    return 'Пока здесь пусто — расскажи первым, что $appName стоит сделать дальше';
  }

  @override
  String get sdkListLoadError =>
      'Не удалось загрузить отзывы. Проверь подключение.';

  @override
  String sdkListVotes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count голоса',
      many: '$count голосов',
      few: '$count голоса',
      one: '$count голос',
    );
    return '$_temp0';
  }

  @override
  String sdkListComments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count комментария',
      many: '$count комментариев',
      few: '$count комментария',
      one: '$count комментарий',
    );
    return '$_temp0';
  }

  @override
  String get sdkFilterTitle => 'Фильтр и сортировка';

  @override
  String get sdkFilterSortBy => 'Сортировка';

  @override
  String get sdkFilterSortMostVoted => 'Больше всего голосов';

  @override
  String get sdkFilterSortNewest => 'Сначала новые';

  @override
  String get sdkFilterSortOldest => 'Сначала старые';

  @override
  String get sdkFilterStatus => 'Статус';

  @override
  String get sdkFilterStatusAll => 'Все';

  @override
  String get sdkFilterReset => 'Сбросить';

  @override
  String sdkFilterShowResults(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Показать $count запроса',
      many: 'Показать $count запросов',
      few: 'Показать $count запроса',
      one: 'Показать $count запрос',
    );
    return '$_temp0';
  }

  @override
  String sdkFilterShowResultsOverflow(int count) {
    return 'Показать $count+ запросов';
  }

  @override
  String get sdkStatusOpen => 'Открыто';

  @override
  String get sdkStatusPlanned => 'Запланировано';

  @override
  String get sdkStatusInProgress => 'В работе';

  @override
  String get sdkStatusDone => 'Готово';

  @override
  String get sdkFormTypeLabel => 'Тип';

  @override
  String get sdkFormTypeFeature => 'Функция';

  @override
  String get sdkFormTypeIssue => 'Проблема';

  @override
  String get sdkFormTitleLabel => 'Заголовок';

  @override
  String get sdkFormTitlePlaceholder => 'Опиши суть в нескольких словах';

  @override
  String sdkFormTitleCounter(int remaining) {
    String _temp0 = intl.Intl.pluralLogic(
      remaining,
      locale: localeName,
      other: 'Осталось $remaining символа',
      many: 'Осталось $remaining символов',
      few: 'Осталось $remaining символа',
      one: 'Остался $remaining символ',
    );
    return '$_temp0';
  }

  @override
  String get sdkFormDescriptionLabel => 'Описание';

  @override
  String sdkFormDescriptionPlaceholderFeature(String appName) {
    return 'Что должно появиться в $appName? Расскажи, как ты будешь этим пользоваться.';
  }

  @override
  String sdkFormDescriptionPlaceholderIssue(String appName) {
    return 'Что пошло не так в $appName? Опиши, что должно было произойти.';
  }

  @override
  String get sdkFormEmailLabel => 'Email';

  @override
  String get sdkFormEmailHelper =>
      'Необязательно. Мы напишем тебе, когда команда ответит или запрос будет реализован.';

  @override
  String get sdkFormAddScreenshot => 'Добавить скриншот';

  @override
  String get sdkFormRemoveScreenshot => 'Удалить скриншот';

  @override
  String get sdkFormSubmit => 'Отправить';

  @override
  String get sdkFormSending => 'Отправка…';

  @override
  String get sdkFormSubmitError =>
      'Не удалось отправить. Черновик сохранён. Проверь подключение и попробуй ещё раз.';

  @override
  String get sdkFormTryAgain => 'Попробовать ещё раз';

  @override
  String get sdkSuccessTitle => 'Спасибо! Мы читаем каждый отзыв.';

  @override
  String sdkSuccessBody(String appName) {
    return 'Твой отзыв отправлен прямо команде $appName.';
  }

  @override
  String get sdkSuccessBack => 'К отзывам';

  @override
  String sdkDetailSubmitted(String date) {
    return 'Отправлено $date';
  }

  @override
  String get sdkDetailVote => 'Голосовать';

  @override
  String sdkDetailVoted(int count) {
    return 'Голос учтён · $count';
  }

  @override
  String get sdkDetailCommentsTitle => 'Комментарии';

  @override
  String get sdkDetailCommentPlaceholder => 'Добавить комментарий…';

  @override
  String get sdkDetailCommentSend => 'Отправить';

  @override
  String get sdkDetailAnonymous => 'Аноним';

  @override
  String get sdkDetailTeamBadge => 'Команда';

  @override
  String get sdkCommonClose => 'Закрыть';

  @override
  String get sdkCommonCancel => 'Отмена';

  @override
  String get sdkCommonRetry => 'Повторить';

  @override
  String get sdkSandboxBadge => 'SANDBOX';

  @override
  String get sdkFormAttachError =>
      'Не удалось прикрепить это изображение. Попробуйте другое.';

  @override
  String get sdkFormEmailError =>
      'Введите действительный адрес электронной почты.';

  @override
  String get sdkDetailCommentsDisabled => 'Комментарии отключены.';

  @override
  String get sdkCommonRateLimited =>
      'Слишком много запросов. Попробуйте снова чуть позже.';
}
