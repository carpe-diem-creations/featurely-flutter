// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'featurely_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class FeaturelyLocalizationsPt extends FeaturelyLocalizations {
  FeaturelyLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get sdkListTitle => 'Feedback';

  @override
  String get sdkListNewFeedback => 'Novo feedback';

  @override
  String sdkListEmpty(String appName) {
    return 'Ainda não há nada por aqui — sê o primeiro a dizer-nos o que $appName devia fazer a seguir';
  }

  @override
  String get sdkListLoadError =>
      'Não foi possível carregar o feedback. Verifica a tua ligação.';

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
      other: '$count comentários',
      one: '$count comentário',
    );
    return '$_temp0';
  }

  @override
  String get sdkFilterTitle => 'Filtrar e ordenar';

  @override
  String get sdkFilterSortBy => 'Ordenar';

  @override
  String get sdkFilterSortMostVoted => 'Mais votados';

  @override
  String get sdkFilterSortNewest => 'Mais recentes';

  @override
  String get sdkFilterSortOldest => 'Mais antigos';

  @override
  String get sdkFilterStatus => 'Estado';

  @override
  String get sdkFilterStatusAll => 'Todos';

  @override
  String get sdkFilterReset => 'Repor';

  @override
  String sdkFilterShowResults(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mostrar $count pedidos',
      one: 'Mostrar $count pedido',
    );
    return '$_temp0';
  }

  @override
  String sdkFilterShowResultsOverflow(int count) {
    return 'Mostrar $count+ pedidos';
  }

  @override
  String get sdkStatusOpen => 'Aberto';

  @override
  String get sdkStatusPlanned => 'Planeado';

  @override
  String get sdkStatusInProgress => 'Em curso';

  @override
  String get sdkStatusDone => 'Concluído';

  @override
  String get sdkFormTypeLabel => 'Tipo';

  @override
  String get sdkFormTypeFeature => 'Funcionalidade';

  @override
  String get sdkFormTypeIssue => 'Problema';

  @override
  String get sdkFormTitleLabel => 'Título';

  @override
  String get sdkFormTitlePlaceholder => 'Resume em poucas palavras';

  @override
  String sdkFormTitleCounter(int remaining) {
    String _temp0 = intl.Intl.pluralLogic(
      remaining,
      locale: localeName,
      other: 'Faltam $remaining carateres',
      one: 'Falta $remaining caráter',
    );
    return '$_temp0';
  }

  @override
  String get sdkFormDescriptionLabel => 'Descrição';

  @override
  String sdkFormDescriptionPlaceholderFeature(String appName) {
    return 'O que devia $appName fazer?';
  }

  @override
  String sdkFormDescriptionPlaceholderIssue(String appName) {
    return 'O que correu mal em $appName?';
  }

  @override
  String get sdkFormEmailLabel => 'Email';

  @override
  String get sdkFormEmailHelper =>
      'Opcional. Enviamos-te um email quando a equipa responder ou o teu pedido estiver disponível.';

  @override
  String get sdkFormAddScreenshot => 'Adicionar captura de ecrã';

  @override
  String get sdkFormRemoveScreenshot => 'Remover captura de ecrã';

  @override
  String get sdkFormSubmit => 'Enviar';

  @override
  String get sdkFormSending => 'A enviar…';

  @override
  String get sdkFormSubmitError =>
      'Não foi possível enviar. O teu rascunho está guardado. Verifica a tua ligação e tenta novamente.';

  @override
  String get sdkFormTryAgain => 'Tentar novamente';

  @override
  String get sdkSuccessTitle =>
      'Obrigado! Lemos todas as mensagens, uma a uma.';

  @override
  String sdkSuccessBody(String appName) {
    return 'O teu feedback seguiu diretamente para a equipa de $appName.';
  }

  @override
  String get sdkSuccessBack => 'Voltar ao feedback';

  @override
  String sdkDetailSubmitted(String date) {
    return 'Enviado a $date';
  }

  @override
  String get sdkDetailVote => 'Votar';

  @override
  String sdkDetailVoted(int count) {
    return 'Votado · $count';
  }

  @override
  String get sdkDetailCommentsTitle => 'Comentários';

  @override
  String get sdkDetailCommentPlaceholder => 'Adiciona um comentário…';

  @override
  String get sdkDetailCommentSend => 'Enviar';

  @override
  String get sdkDetailAnonymous => 'Anónimo';

  @override
  String get sdkDetailTeamBadge => 'Equipa';

  @override
  String get sdkCommonClose => 'Fechar';

  @override
  String get sdkCommonCancel => 'Cancelar';

  @override
  String get sdkCommonRetry => 'Tentar novamente';

  @override
  String get sdkSandboxBadge => 'SANDBOX';

  @override
  String get sdkFormAttachError =>
      'Não foi possível anexar essa imagem. Tenta outra.';

  @override
  String get sdkFormEmailError => 'Introduz um endereço de email válido.';

  @override
  String get sdkDetailCommentsDisabled => 'Os comentários foram desativados.';

  @override
  String get sdkCommonRateLimited =>
      'Demasiados pedidos. Tenta novamente dentro de momentos.';

  @override
  String get sdkChatAiTag => 'IA';

  @override
  String get sdkChatAssistantName => 'Assistente';

  @override
  String sdkChatAssistantTyping(String name) {
    return '$name está a escrever…';
  }

  @override
  String get sdkChatComposerPlaceholder => 'Escreve uma mensagem…';

  @override
  String get sdkChatEmailEdit => 'Editar';

  @override
  String get sdkChatEmailInvalid => 'Introduz um endereço de email válido.';

  @override
  String get sdkChatEmailPlaceholder => 'O teu endereço de email';

  @override
  String get sdkChatEmailPrompt => 'Receber respostas por email';

  @override
  String get sdkChatEmailSave => 'Guardar';

  @override
  String get sdkChatEmailSaved => 'Email para respostas';

  @override
  String get sdkChatEmptyGreeting =>
      'Olá! Envia-nos uma mensagem e a nossa equipa responde-te aqui.';

  @override
  String get sdkChatLoadEarlier => 'Carregar mensagens anteriores';

  @override
  String get sdkChatMessageUs => 'Envia-nos uma mensagem';

  @override
  String get sdkChatNotSentRetry => 'Não enviada — Toca para tentar novamente';

  @override
  String get sdkChatSend => 'Enviar';

  @override
  String get sdkChatSending => 'A enviar…';

  @override
  String get sdkChatTeamLabel => 'Equipa';

  @override
  String get sdkChatTitle => 'Mensagens';

  @override
  String get sdkChatToday => 'Hoje';

  @override
  String sdkChatTooLong(int max) {
    return 'Esta mensagem é demasiado longa. O limite é de $max caracteres.';
  }

  @override
  String get sdkChatYesterday => 'Ontem';
}

/// The translations for Portuguese, as used in Brazil (`pt_BR`).
class FeaturelyLocalizationsPtBr extends FeaturelyLocalizationsPt {
  FeaturelyLocalizationsPtBr() : super('pt_BR');

  @override
  String get sdkListTitle => 'Feedback';

  @override
  String get sdkListNewFeedback => 'Novo feedback';

  @override
  String sdkListEmpty(String appName) {
    return 'Ainda não tem nada por aqui — seja o primeiro a dizer o que o $appName deveria fazer';
  }

  @override
  String get sdkListLoadError =>
      'Não foi possível carregar o feedback. Verifique sua conexão.';

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
      other: '$count comentários',
      one: '$count comentário',
    );
    return '$_temp0';
  }

  @override
  String get sdkFilterTitle => 'Filtrar e ordenar';

  @override
  String get sdkFilterSortBy => 'Ordenar';

  @override
  String get sdkFilterSortMostVoted => 'Mais votados';

  @override
  String get sdkFilterSortNewest => 'Mais recentes';

  @override
  String get sdkFilterSortOldest => 'Mais antigos';

  @override
  String get sdkFilterStatus => 'Status';

  @override
  String get sdkFilterStatusAll => 'Todos';

  @override
  String get sdkFilterReset => 'Redefinir';

  @override
  String sdkFilterShowResults(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mostrar $count pedidos',
      one: 'Mostrar $count pedido',
    );
    return '$_temp0';
  }

  @override
  String sdkFilterShowResultsOverflow(int count) {
    return 'Mostrar $count+ pedidos';
  }

  @override
  String get sdkStatusOpen => 'Aberto';

  @override
  String get sdkStatusPlanned => 'Planejado';

  @override
  String get sdkStatusInProgress => 'Em andamento';

  @override
  String get sdkStatusDone => 'Concluído';

  @override
  String get sdkFormTypeLabel => 'Tipo';

  @override
  String get sdkFormTypeFeature => 'Funcionalidade';

  @override
  String get sdkFormTypeIssue => 'Problema';

  @override
  String get sdkFormTitleLabel => 'Título';

  @override
  String get sdkFormTitlePlaceholder => 'Resuma em poucas palavras';

  @override
  String sdkFormTitleCounter(int remaining) {
    String _temp0 = intl.Intl.pluralLogic(
      remaining,
      locale: localeName,
      other: 'Faltam $remaining caracteres',
      one: 'Falta $remaining caractere',
    );
    return '$_temp0';
  }

  @override
  String get sdkFormDescriptionLabel => 'Descrição';

  @override
  String sdkFormDescriptionPlaceholderFeature(String appName) {
    return 'O que o $appName deveria fazer?';
  }

  @override
  String sdkFormDescriptionPlaceholderIssue(String appName) {
    return 'O que deu errado no $appName?';
  }

  @override
  String get sdkFormEmailLabel => 'E-mail';

  @override
  String get sdkFormEmailHelper =>
      'Opcional. Vamos te avisar por e-mail quando a equipe responder ou seu pedido for lançado.';

  @override
  String get sdkFormAddScreenshot => 'Adicionar captura de tela';

  @override
  String get sdkFormRemoveScreenshot => 'Remover captura de tela';

  @override
  String get sdkFormSubmit => 'Enviar';

  @override
  String get sdkFormSending => 'Enviando…';

  @override
  String get sdkFormSubmitError =>
      'Não foi possível enviar. Seu rascunho foi salvo. Verifique sua conexão e tente de novo.';

  @override
  String get sdkFormTryAgain => 'Tentar de novo';

  @override
  String get sdkSuccessTitle => 'Obrigado! Lemos cada uma das mensagens.';

  @override
  String sdkSuccessBody(String appName) {
    return 'Seu feedback foi direto para a equipe de $appName.';
  }

  @override
  String get sdkSuccessBack => 'Voltar ao feedback';

  @override
  String sdkDetailSubmitted(String date) {
    return 'Enviado em $date';
  }

  @override
  String get sdkDetailVote => 'Votar';

  @override
  String sdkDetailVoted(int count) {
    return 'Votado · $count';
  }

  @override
  String get sdkDetailCommentsTitle => 'Comentários';

  @override
  String get sdkDetailCommentPlaceholder => 'Adicione um comentário…';

  @override
  String get sdkDetailCommentSend => 'Enviar';

  @override
  String get sdkDetailAnonymous => 'Anônimo';

  @override
  String get sdkDetailTeamBadge => 'Equipe';

  @override
  String get sdkCommonClose => 'Fechar';

  @override
  String get sdkCommonCancel => 'Cancelar';

  @override
  String get sdkCommonRetry => 'Tentar novamente';

  @override
  String get sdkSandboxBadge => 'SANDBOX';

  @override
  String get sdkFormAttachError =>
      'Não foi possível anexar essa imagem. Tente outra.';

  @override
  String get sdkFormEmailError => 'Digite um endereço de e-mail válido.';

  @override
  String get sdkDetailCommentsDisabled => 'Os comentários foram desativados.';

  @override
  String get sdkCommonRateLimited =>
      'Muitas solicitações. Tente novamente em instantes.';

  @override
  String get sdkChatAiTag => 'IA';

  @override
  String get sdkChatAssistantName => 'Assistente';

  @override
  String sdkChatAssistantTyping(String name) {
    return '$name está digitando…';
  }

  @override
  String get sdkChatComposerPlaceholder => 'Escreva uma mensagem…';

  @override
  String get sdkChatEmailEdit => 'Editar';

  @override
  String get sdkChatEmailInvalid => 'Informe um endereço de e-mail válido.';

  @override
  String get sdkChatEmailPlaceholder => 'Seu endereço de e-mail';

  @override
  String get sdkChatEmailPrompt => 'Receber respostas por e-mail';

  @override
  String get sdkChatEmailSave => 'Salvar';

  @override
  String get sdkChatEmailSaved => 'E-mail para respostas';

  @override
  String get sdkChatEmptyGreeting =>
      'Oi! Mande uma mensagem e nossa equipe vai te responder por aqui.';

  @override
  String get sdkChatLoadEarlier => 'Carregar mensagens anteriores';

  @override
  String get sdkChatMessageUs => 'Fale com a gente';

  @override
  String get sdkChatNotSentRetry => 'Não enviada — Toque para tentar de novo';

  @override
  String get sdkChatSend => 'Enviar';

  @override
  String get sdkChatSending => 'Enviando…';

  @override
  String get sdkChatTeamLabel => 'Equipe';

  @override
  String get sdkChatTitle => 'Mensagens';

  @override
  String get sdkChatToday => 'Hoje';

  @override
  String sdkChatTooLong(int max) {
    return 'Esta mensagem é longa demais. O limite é de $max caracteres.';
  }

  @override
  String get sdkChatYesterday => 'Ontem';
}
