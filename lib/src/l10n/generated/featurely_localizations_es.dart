// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'featurely_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class FeaturelyLocalizationsEs extends FeaturelyLocalizations {
  FeaturelyLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get sdkListTitle => 'Feedback';

  @override
  String get sdkListNewFeedback => 'Nuevo feedback';

  @override
  String sdkListEmpty(String appName) {
    return 'Aún no hay nada por aquí: sé el primero en contarnos qué debería hacer $appName';
  }

  @override
  String get sdkListLoadError =>
      'No se pudo cargar el feedback. Comprueba tu conexión.';

  @override
  String sdkListVotes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count votos',
      one: '$count voto',
    );
    return '$_temp0';
  }

  @override
  String sdkListComments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count comentarios',
      one: '$count comentario',
    );
    return '$_temp0';
  }

  @override
  String get sdkFilterTitle => 'Filtrar y ordenar';

  @override
  String get sdkFilterSortBy => 'Ordenar';

  @override
  String get sdkFilterSortMostVoted => 'Más votados';

  @override
  String get sdkFilterSortNewest => 'Más recientes';

  @override
  String get sdkFilterSortOldest => 'Más antiguos';

  @override
  String get sdkFilterStatus => 'Estado';

  @override
  String get sdkFilterStatusAll => 'Todos';

  @override
  String get sdkFilterReset => 'Restablecer';

  @override
  String sdkFilterShowResults(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mostrar $count peticiones',
      one: 'Mostrar $count petición',
    );
    return '$_temp0';
  }

  @override
  String sdkFilterShowResultsOverflow(int count) {
    return 'Mostrar $count+ peticiones';
  }

  @override
  String get sdkStatusOpen => 'Abierto';

  @override
  String get sdkStatusPlanned => 'Planificado';

  @override
  String get sdkStatusInProgress => 'En progreso';

  @override
  String get sdkStatusDone => 'Completado';

  @override
  String get sdkFormTypeLabel => 'Tipo';

  @override
  String get sdkFormTypeFeature => 'Función';

  @override
  String get sdkFormTypeIssue => 'Problema';

  @override
  String get sdkFormTitleLabel => 'Título';

  @override
  String get sdkFormTitlePlaceholder => 'Resúmelo en pocas palabras';

  @override
  String sdkFormTitleCounter(int remaining) {
    String _temp0 = intl.Intl.pluralLogic(
      remaining,
      locale: localeName,
      other: 'Quedan $remaining caracteres',
      one: 'Queda $remaining carácter',
    );
    return '$_temp0';
  }

  @override
  String get sdkFormDescriptionLabel => 'Descripción';

  @override
  String sdkFormDescriptionPlaceholderFeature(String appName) {
    return '¿Qué debería hacer $appName?';
  }

  @override
  String sdkFormDescriptionPlaceholderIssue(String appName) {
    return '¿Qué ha fallado en $appName?';
  }

  @override
  String get sdkFormEmailLabel => 'Correo electrónico';

  @override
  String get sdkFormEmailHelper =>
      'Opcional. Te enviaremos un correo cuando el equipo responda o tu petición esté lista.';

  @override
  String get sdkFormAddScreenshot => 'Añadir captura';

  @override
  String get sdkFormRemoveScreenshot => 'Quitar captura';

  @override
  String get sdkFormSubmit => 'Enviar';

  @override
  String get sdkFormSending => 'Enviando…';

  @override
  String get sdkFormSubmitError =>
      'No se pudo enviar. Tu borrador está guardado. Comprueba tu conexión e inténtalo de nuevo.';

  @override
  String get sdkFormTryAgain => 'Inténtalo de nuevo';

  @override
  String get sdkSuccessTitle =>
      '¡Gracias! Leemos todos y cada uno de los mensajes.';

  @override
  String sdkSuccessBody(String appName) {
    return 'Tu feedback ha llegado directamente al equipo de $appName.';
  }

  @override
  String get sdkSuccessBack => 'Volver al feedback';

  @override
  String sdkDetailSubmitted(String date) {
    return 'Enviado el $date';
  }

  @override
  String get sdkDetailVote => 'Votar';

  @override
  String sdkDetailVoted(int count) {
    return 'Votado · $count';
  }

  @override
  String get sdkDetailCommentsTitle => 'Comentarios';

  @override
  String get sdkDetailCommentPlaceholder => 'Añade un comentario…';

  @override
  String get sdkDetailCommentSend => 'Enviar';

  @override
  String get sdkDetailAnonymous => 'Anónimo';

  @override
  String get sdkDetailTeamBadge => 'Equipo';

  @override
  String get sdkCommonClose => 'Cerrar';

  @override
  String get sdkCommonCancel => 'Cancelar';

  @override
  String get sdkCommonRetry => 'Reintentar';

  @override
  String get sdkSandboxBadge => 'SANDBOX';

  @override
  String get sdkFormAttachError =>
      'No se pudo adjuntar esa imagen. Prueba con otra.';

  @override
  String get sdkFormEmailError => 'Introduce una dirección de correo válida.';

  @override
  String get sdkDetailCommentsDisabled => 'Los comentarios están desactivados.';

  @override
  String get sdkCommonRateLimited =>
      'Demasiadas solicitudes. Inténtalo de nuevo en un momento.';

  @override
  String get sdkChatAiTag => 'IA';

  @override
  String get sdkChatAssistantName => 'Asistente';

  @override
  String sdkChatAssistantTyping(String name) {
    return '$name está escribiendo…';
  }

  @override
  String get sdkChatComposerPlaceholder => 'Escribe un mensaje…';

  @override
  String get sdkChatEmailEdit => 'Editar';

  @override
  String get sdkChatEmailInvalid => 'Introduce un correo electrónico válido.';

  @override
  String get sdkChatEmailPlaceholder => 'Tu correo electrónico';

  @override
  String get sdkChatEmailPrompt => 'Recibir respuestas por correo';

  @override
  String get sdkChatEmailSave => 'Guardar';

  @override
  String get sdkChatEmailSaved => 'Correo para respuestas';

  @override
  String get sdkChatEmptyGreeting =>
      '¡Hola! Envíanos un mensaje y nuestro equipo te responderá aquí.';

  @override
  String get sdkChatLoadEarlier => 'Cargar mensajes anteriores';

  @override
  String get sdkChatMessageUs => 'Escríbenos';

  @override
  String get sdkChatNotSentRetry => 'No enviado — Toca para reintentar';

  @override
  String get sdkChatSend => 'Enviar';

  @override
  String get sdkChatSending => 'Enviando…';

  @override
  String get sdkChatTeamLabel => 'Equipo';

  @override
  String get sdkChatTitle => 'Mensajes';

  @override
  String get sdkChatToday => 'Hoy';

  @override
  String sdkChatTooLong(int max) {
    return 'Este mensaje es demasiado largo. El límite es de $max caracteres.';
  }

  @override
  String get sdkChatYesterday => 'Ayer';
}
