// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'featurely_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class FeaturelyLocalizationsFr extends FeaturelyLocalizations {
  FeaturelyLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get sdkListTitle => 'Retours';

  @override
  String get sdkListNewFeedback => 'Nouveau retour';

  @override
  String sdkListEmpty(String appName) {
    return 'Rien ici pour l\'instant — sois le premier à nous dire ce que $appName devrait faire';
  }

  @override
  String get sdkListLoadError =>
      'Impossible de charger les retours. Vérifie ta connexion.';

  @override
  String sdkListVotes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count votes',
      one: '$count vote',
    );
    return '$_temp0';
  }

  @override
  String sdkListComments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count commentaires',
      one: '$count commentaire',
    );
    return '$_temp0';
  }

  @override
  String get sdkFilterTitle => 'Filtrer et trier';

  @override
  String get sdkFilterSortBy => 'Trier';

  @override
  String get sdkFilterSortMostVoted => 'Les plus votés';

  @override
  String get sdkFilterSortNewest => 'Les plus récents';

  @override
  String get sdkFilterSortOldest => 'Les plus anciens';

  @override
  String get sdkFilterStatus => 'Statut';

  @override
  String get sdkFilterStatusAll => 'Tous';

  @override
  String get sdkFilterReset => 'Réinitialiser';

  @override
  String sdkFilterShowResults(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Afficher $count demandes',
      one: 'Afficher $count demande',
    );
    return '$_temp0';
  }

  @override
  String sdkFilterShowResultsOverflow(int count) {
    return 'Afficher $count+ demandes';
  }

  @override
  String get sdkStatusOpen => 'Ouvert';

  @override
  String get sdkStatusPlanned => 'Planifié';

  @override
  String get sdkStatusInProgress => 'En cours';

  @override
  String get sdkStatusDone => 'Terminé';

  @override
  String get sdkFormTypeLabel => 'Type';

  @override
  String get sdkFormTypeFeature => 'Fonctionnalité';

  @override
  String get sdkFormTypeIssue => 'Problème';

  @override
  String get sdkFormTitleLabel => 'Titre';

  @override
  String get sdkFormTitlePlaceholder => 'Résume en quelques mots';

  @override
  String sdkFormTitleCounter(int remaining) {
    String _temp0 = intl.Intl.pluralLogic(
      remaining,
      locale: localeName,
      other: '$remaining caractères restants',
      one: '$remaining caractère restant',
    );
    return '$_temp0';
  }

  @override
  String get sdkFormDescriptionLabel => 'Description';

  @override
  String sdkFormDescriptionPlaceholderFeature(String appName) {
    return 'Que devrait faire $appName ?';
  }

  @override
  String sdkFormDescriptionPlaceholderIssue(String appName) {
    return 'Qu\'est-ce qui n\'a pas marché dans $appName ?';
  }

  @override
  String get sdkFormEmailLabel => 'E-mail';

  @override
  String get sdkFormEmailHelper =>
      'Facultatif. On t\'enverra un e-mail si l\'équipe répond ou quand ta demande sera disponible.';

  @override
  String get sdkFormAddScreenshot => 'Ajouter une capture d\'écran';

  @override
  String get sdkFormRemoveScreenshot => 'Supprimer la capture d\'écran';

  @override
  String get sdkFormSubmit => 'Envoyer';

  @override
  String get sdkFormSending => 'Envoi en cours…';

  @override
  String get sdkFormSubmitError =>
      'Échec de l\'envoi. Ton brouillon est sauvegardé. Vérifie ta connexion et réessaie.';

  @override
  String get sdkFormTryAgain => 'Réessayer';

  @override
  String get sdkSuccessTitle => 'Merci ! Nous lisons chaque message.';

  @override
  String sdkSuccessBody(String appName) {
    return 'Ton retour est arrivé directement à l\'équipe de $appName.';
  }

  @override
  String get sdkSuccessBack => 'Retour à la liste';

  @override
  String sdkDetailSubmitted(String date) {
    return 'Envoyé le $date';
  }

  @override
  String get sdkDetailVote => 'Voter';

  @override
  String sdkDetailVoted(int count) {
    return 'Voté · $count';
  }

  @override
  String get sdkDetailCommentsTitle => 'Commentaires';

  @override
  String get sdkDetailCommentPlaceholder => 'Ajouter un commentaire…';

  @override
  String get sdkDetailCommentSend => 'Envoyer';

  @override
  String get sdkDetailAnonymous => 'Anonyme';

  @override
  String get sdkDetailTeamBadge => 'Équipe';

  @override
  String get sdkCommonClose => 'Fermer';

  @override
  String get sdkCommonCancel => 'Annuler';

  @override
  String get sdkCommonRetry => 'Réessayer';

  @override
  String get sdkSandboxBadge => 'SANDBOX';

  @override
  String get sdkFormAttachError =>
      'Impossible de joindre cette image. Essayez-en une autre.';

  @override
  String get sdkFormEmailError => 'Saisissez une adresse e-mail valide.';

  @override
  String get sdkDetailCommentsDisabled =>
      'Les commentaires ont été désactivés.';

  @override
  String get sdkCommonRateLimited =>
      'Trop de requêtes. Réessayez dans un instant.';

  @override
  String get sdkChatComposerPlaceholder => 'Écris un message…';

  @override
  String get sdkChatEmailEdit => 'Modifier';

  @override
  String get sdkChatEmailInvalid => 'Saisis une adresse e-mail valide.';

  @override
  String get sdkChatEmailPlaceholder => 'Ton adresse e-mail';

  @override
  String get sdkChatEmailPrompt => 'Recevoir les réponses par e-mail';

  @override
  String get sdkChatEmailSave => 'Enregistrer';

  @override
  String get sdkChatEmailSaved => 'E-mail pour les réponses';

  @override
  String get sdkChatEmptyGreeting =>
      'Salut ! Envoie-nous un message et notre équipe te répondra ici.';

  @override
  String get sdkChatLoadEarlier => 'Charger les messages précédents';

  @override
  String get sdkChatMessageUs => 'Nous écrire';

  @override
  String get sdkChatNotSentRetry => 'Non envoyé — Touche pour réessayer';

  @override
  String get sdkChatSend => 'Envoyer';

  @override
  String get sdkChatSending => 'Envoi…';

  @override
  String get sdkChatTeamLabel => 'Équipe';

  @override
  String get sdkChatTitle => 'Messages';

  @override
  String sdkChatTooLong(int max) {
    return 'Ce message est trop long. La limite est de $max caractères.';
  }
}
