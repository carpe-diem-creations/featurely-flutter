// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'featurely_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class FeaturelyLocalizationsHi extends FeaturelyLocalizations {
  FeaturelyLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get sdkListTitle => 'फ़ीडबैक';

  @override
  String get sdkListNewFeedback => 'नया फ़ीडबैक';

  @override
  String sdkListEmpty(String appName) {
    return 'यहाँ अभी कुछ नहीं है — सबसे पहले बताएँ कि $appName को आगे क्या करना चाहिए';
  }

  @override
  String get sdkListLoadError =>
      'फ़ीडबैक लोड नहीं हो सका। कृपया अपना कनेक्शन जाँचें।';

  @override
  String sdkListVotes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count वोट',
      one: '$count वोट',
    );
    return '$_temp0';
  }

  @override
  String sdkListComments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count टिप्पणियाँ',
      one: '$count टिप्पणी',
    );
    return '$_temp0';
  }

  @override
  String get sdkFilterTitle => 'फ़िल्टर और क्रम';

  @override
  String get sdkFilterSortBy => 'क्रम';

  @override
  String get sdkFilterSortMostVoted => 'सबसे ज़्यादा वोट';

  @override
  String get sdkFilterSortNewest => 'सबसे नए';

  @override
  String get sdkFilterSortOldest => 'सबसे पुराने';

  @override
  String get sdkFilterStatus => 'स्थिति';

  @override
  String get sdkFilterStatusAll => 'सभी';

  @override
  String get sdkFilterReset => 'रीसेट करें';

  @override
  String sdkFilterShowResults(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count अनुरोध देखें',
      one: '$count अनुरोध देखें',
    );
    return '$_temp0';
  }

  @override
  String sdkFilterShowResultsOverflow(int count) {
    return '$count+ अनुरोध देखें';
  }

  @override
  String get sdkStatusOpen => 'खुला';

  @override
  String get sdkStatusPlanned => 'योजना में';

  @override
  String get sdkStatusInProgress => 'प्रगति पर';

  @override
  String get sdkStatusDone => 'पूर्ण';

  @override
  String get sdkFormTypeLabel => 'प्रकार';

  @override
  String get sdkFormTypeFeature => 'फ़ीचर';

  @override
  String get sdkFormTypeIssue => 'समस्या';

  @override
  String get sdkFormTitleLabel => 'शीर्षक';

  @override
  String get sdkFormTitlePlaceholder => 'कुछ शब्दों में बताएँ';

  @override
  String sdkFormTitleCounter(int remaining) {
    String _temp0 = intl.Intl.pluralLogic(
      remaining,
      locale: localeName,
      other: '$remaining अक्षर बाकी',
      one: '$remaining अक्षर बाकी',
    );
    return '$_temp0';
  }

  @override
  String get sdkFormDescriptionLabel => 'विवरण';

  @override
  String sdkFormDescriptionPlaceholderFeature(String appName) {
    return '$appName को क्या करना चाहिए?';
  }

  @override
  String sdkFormDescriptionPlaceholderIssue(String appName) {
    return '$appName में क्या गड़बड़ हुई?';
  }

  @override
  String get sdkFormEmailLabel => 'ईमेल';

  @override
  String get sdkFormEmailHelper =>
      'वैकल्पिक। टीम के जवाब देने या आपका अनुरोध लॉन्च होने पर हम आपको ईमेल करेंगे।';

  @override
  String get sdkFormAddScreenshot => 'स्क्रीनशॉट जोड़ें';

  @override
  String get sdkFormRemoveScreenshot => 'स्क्रीनशॉट हटाएँ';

  @override
  String get sdkFormSubmit => 'भेजें';

  @override
  String get sdkFormSending => 'भेजा जा रहा है…';

  @override
  String get sdkFormSubmitError =>
      'भेजा नहीं जा सका। आपका ड्राफ़्ट सहेज लिया गया है। कनेक्शन जाँचकर फिर से कोशिश करें।';

  @override
  String get sdkFormTryAgain => 'फिर से कोशिश करें';

  @override
  String get sdkSuccessTitle => 'धन्यवाद! हम इनमें से हर एक को पढ़ते हैं।';

  @override
  String sdkSuccessBody(String appName) {
    return 'आपका फ़ीडबैक सीधे $appName टीम तक पहुँच गया है।';
  }

  @override
  String get sdkSuccessBack => 'फ़ीडबैक पर वापस जाएँ';

  @override
  String sdkDetailSubmitted(String date) {
    return '$date को भेजा गया';
  }

  @override
  String get sdkDetailVote => 'वोट करें';

  @override
  String sdkDetailVoted(int count) {
    return 'वोट किया · $count';
  }

  @override
  String get sdkDetailCommentsTitle => 'टिप्पणियाँ';

  @override
  String get sdkDetailCommentPlaceholder => 'टिप्पणी जोड़ें…';

  @override
  String get sdkDetailCommentSend => 'भेजें';

  @override
  String get sdkDetailAnonymous => 'अज्ञात';

  @override
  String get sdkDetailTeamBadge => 'टीम';

  @override
  String get sdkCommonClose => 'बंद करें';

  @override
  String get sdkCommonCancel => 'रद्द करें';

  @override
  String get sdkCommonRetry => 'पुनः प्रयास करें';

  @override
  String get sdkSandboxBadge => 'SANDBOX';

  @override
  String get sdkFormAttachError =>
      'यह इमेज अटैच नहीं हो सकी। कोई दूसरी आज़माएँ।';

  @override
  String get sdkFormEmailError => 'मान्य ईमेल पता दर्ज करें।';

  @override
  String get sdkDetailCommentsDisabled => 'टिप्पणियाँ बंद कर दी गई हैं।';

  @override
  String get sdkCommonRateLimited =>
      'बहुत सारे अनुरोध। थोड़ी देर में फिर कोशिश करें।';

  @override
  String get sdkChatComposerPlaceholder => 'संदेश लिखें…';

  @override
  String get sdkChatEmailEdit => 'बदलें';

  @override
  String get sdkChatEmailInvalid => 'एक मान्य ईमेल पता दर्ज करें।';

  @override
  String get sdkChatEmailPlaceholder => 'आपका ईमेल पता';

  @override
  String get sdkChatEmailPrompt => 'जवाब ईमेल पर पाएं';

  @override
  String get sdkChatEmailSave => 'सहेजें';

  @override
  String get sdkChatEmailSaved => 'जवाबों के लिए ईमेल';

  @override
  String get sdkChatEmptyGreeting =>
      'नमस्ते! हमें एक संदेश भेजें, हमारी टीम आपको यहीं जवाब देगी।';

  @override
  String get sdkChatLoadEarlier => 'पुराने संदेश लोड करें';

  @override
  String get sdkChatMessageUs => 'हमें संदेश भेजें';

  @override
  String get sdkChatNotSentRetry =>
      'नहीं भेजा गया — दोबारा कोशिश करने के लिए टैप करें';

  @override
  String get sdkChatSend => 'भेजें';

  @override
  String get sdkChatSending => 'भेजा जा रहा है…';

  @override
  String get sdkChatTeamLabel => 'टीम';

  @override
  String get sdkChatTitle => 'संदेश';

  @override
  String sdkChatTooLong(int max) {
    return 'यह संदेश बहुत लंबा है। सीमा $max अक्षर है।';
  }
}
