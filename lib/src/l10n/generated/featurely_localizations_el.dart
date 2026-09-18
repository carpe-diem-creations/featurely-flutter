// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'featurely_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Modern Greek (`el`).
class FeaturelyLocalizationsEl extends FeaturelyLocalizations {
  FeaturelyLocalizationsEl([String locale = 'el']) : super(locale);

  @override
  String get sdkListTitle => 'Feedback';

  @override
  String get sdkListNewFeedback => 'Νέο feedback';

  @override
  String sdkListEmpty(String appName) {
    return 'Δεν υπάρχει τίποτα ακόμα — γίνε ο πρώτος που θα μας πει τι να κάνει στη συνέχεια το $appName';
  }

  @override
  String get sdkListLoadError =>
      'Δεν ήταν δυνατή η φόρτωση των σχολίων. Έλεγξε τη σύνδεσή σου.';

  @override
  String sdkListVotes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ψήφοι',
      one: '$count ψήφος',
    );
    return '$_temp0';
  }

  @override
  String sdkListComments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count σχόλια',
      one: '$count σχόλιο',
    );
    return '$_temp0';
  }

  @override
  String get sdkFilterTitle => 'Φιλτράρισμα και ταξινόμηση';

  @override
  String get sdkFilterSortBy => 'Ταξινόμηση';

  @override
  String get sdkFilterSortMostVoted => 'Περισσότερες ψήφοι';

  @override
  String get sdkFilterSortNewest => 'Νεότερα';

  @override
  String get sdkFilterSortOldest => 'Παλαιότερα';

  @override
  String get sdkFilterStatus => 'Κατάσταση';

  @override
  String get sdkFilterStatusAll => 'Όλα';

  @override
  String get sdkFilterReset => 'Επαναφορά';

  @override
  String sdkFilterShowResults(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Εμφάνιση $count αιτημάτων',
      one: 'Εμφάνιση $count αιτήματος',
    );
    return '$_temp0';
  }

  @override
  String sdkFilterShowResultsOverflow(int count) {
    return 'Εμφάνιση $count+ αιτημάτων';
  }

  @override
  String get sdkStatusOpen => 'Ανοιχτό';

  @override
  String get sdkStatusPlanned => 'Προγραμματισμένο';

  @override
  String get sdkStatusInProgress => 'Σε εξέλιξη';

  @override
  String get sdkStatusDone => 'Ολοκληρώθηκε';

  @override
  String get sdkFormTypeLabel => 'Τύπος';

  @override
  String get sdkFormTypeFeature => 'Λειτουργία';

  @override
  String get sdkFormTypeIssue => 'Πρόβλημα';

  @override
  String get sdkFormTitleLabel => 'Τίτλος';

  @override
  String get sdkFormTitlePlaceholder => 'Περίγραψέ το με λίγες λέξεις';

  @override
  String sdkFormTitleCounter(int remaining) {
    String _temp0 = intl.Intl.pluralLogic(
      remaining,
      locale: localeName,
      other: 'Απομένουν $remaining χαρακτήρες',
      one: 'Απομένει $remaining χαρακτήρας',
    );
    return '$_temp0';
  }

  @override
  String get sdkFormDescriptionLabel => 'Περιγραφή';

  @override
  String sdkFormDescriptionPlaceholderFeature(String appName) {
    return 'Τι θα ήθελες να κάνει το $appName;';
  }

  @override
  String sdkFormDescriptionPlaceholderIssue(String appName) {
    return 'Τι πήγε στραβά στο $appName;';
  }

  @override
  String get sdkFormEmailLabel => 'Email';

  @override
  String get sdkFormEmailHelper =>
      'Προαιρετικό. Θα σου στείλουμε email όταν απαντήσει η ομάδα ή όταν υλοποιηθεί το αίτημά σου.';

  @override
  String get sdkFormAddScreenshot => 'Προσθήκη στιγμιότυπου οθόνης';

  @override
  String get sdkFormRemoveScreenshot => 'Αφαίρεση στιγμιότυπου οθόνης';

  @override
  String get sdkFormSubmit => 'Υποβολή';

  @override
  String get sdkFormSending => 'Αποστολή…';

  @override
  String get sdkFormSubmitError =>
      'Η αποστολή απέτυχε. Το πρόχειρό σου αποθηκεύτηκε. Έλεγξε τη σύνδεσή σου και δοκίμασε ξανά.';

  @override
  String get sdkFormTryAgain => 'Δοκίμασε ξανά';

  @override
  String get sdkSuccessTitle => 'Ευχαριστούμε! Τα διαβάζουμε όλα.';

  @override
  String sdkSuccessBody(String appName) {
    return 'Τα σχόλιά σου στάλθηκαν απευθείας στην ομάδα του $appName.';
  }

  @override
  String get sdkSuccessBack => 'Πίσω στο feedback';

  @override
  String sdkDetailSubmitted(String date) {
    return 'Υποβλήθηκε $date';
  }

  @override
  String get sdkDetailVote => 'Ψήφισε';

  @override
  String sdkDetailVoted(int count) {
    return 'Ψηφίστηκε · $count';
  }

  @override
  String get sdkDetailCommentsTitle => 'Σχόλια';

  @override
  String get sdkDetailCommentPlaceholder => 'Πρόσθεσε ένα σχόλιο…';

  @override
  String get sdkDetailCommentSend => 'Αποστολή';

  @override
  String get sdkDetailAnonymous => 'Ανώνυμος';

  @override
  String get sdkDetailTeamBadge => 'Ομάδα';

  @override
  String get sdkCommonClose => 'Κλείσιμο';

  @override
  String get sdkCommonCancel => 'Ακύρωση';

  @override
  String get sdkCommonRetry => 'Επανάληψη';

  @override
  String get sdkSandboxBadge => 'SANDBOX';

  @override
  String get sdkFormAttachError =>
      'Δεν ήταν δυνατή η επισύναψη της εικόνας. Δοκίμασε μια άλλη.';

  @override
  String get sdkFormEmailError => 'Συμπλήρωσε μια έγκυρη διεύθυνση email.';

  @override
  String get sdkDetailCommentsDisabled => 'Τα σχόλια έχουν απενεργοποιηθεί.';

  @override
  String get sdkCommonRateLimited =>
      'Πάρα πολλά αιτήματα. Δοκίμασε ξανά σε λίγο.';

  @override
  String get sdkChatAiTag => 'ΤΝ';

  @override
  String get sdkChatAssistantName => 'Βοηθός';

  @override
  String sdkChatAssistantTyping(String name) {
    return '$name πληκτρολογεί…';
  }

  @override
  String get sdkChatComposerPlaceholder => 'Γράψε ένα μήνυμα…';

  @override
  String get sdkChatEmailEdit => 'Επεξεργασία';

  @override
  String get sdkChatEmailInvalid => 'Συμπλήρωσε μια έγκυρη διεύθυνση email.';

  @override
  String get sdkChatEmailPlaceholder => 'Η διεύθυνση email σου';

  @override
  String get sdkChatEmailPrompt => 'Λάβε τις απαντήσεις με email';

  @override
  String get sdkChatEmailSave => 'Αποθήκευση';

  @override
  String get sdkChatEmailSaved => 'Email για απαντήσεις';

  @override
  String get sdkChatEmptyGreeting =>
      'Γεια σου! Στείλε μας ένα μήνυμα και η ομάδα μας θα σου απαντήσει εδώ.';

  @override
  String get sdkChatLoadEarlier => 'Φόρτωση παλαιότερων μηνυμάτων';

  @override
  String get sdkChatMessageUs => 'Στείλε μας μήνυμα';

  @override
  String get sdkChatNotSentRetry =>
      'Δεν στάλθηκε — Πάτησε για να δοκιμάσεις ξανά';

  @override
  String get sdkChatSend => 'Αποστολή';

  @override
  String get sdkChatSending => 'Αποστολή…';

  @override
  String get sdkChatTeamLabel => 'Ομάδα';

  @override
  String get sdkChatTitle => 'Μηνύματα';

  @override
  String get sdkChatToday => 'Σήμερα';

  @override
  String sdkChatTooLong(int max) {
    return 'Το μήνυμα είναι πολύ μεγάλο. Το όριο είναι $max χαρακτήρες.';
  }

  @override
  String get sdkChatYesterday => 'Χθες';
}
