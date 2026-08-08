import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'featurely_localizations_ar.dart';
import 'featurely_localizations_da.dart';
import 'featurely_localizations_de.dart';
import 'featurely_localizations_en.dart';
import 'featurely_localizations_es.dart';
import 'featurely_localizations_fil.dart';
import 'featurely_localizations_fr.dart';
import 'featurely_localizations_he.dart';
import 'featurely_localizations_hi.dart';
import 'featurely_localizations_hu.dart';
import 'featurely_localizations_it.dart';
import 'featurely_localizations_ja.dart';
import 'featurely_localizations_ko.dart';
import 'featurely_localizations_nb.dart';
import 'featurely_localizations_nl.dart';
import 'featurely_localizations_pl.dart';
import 'featurely_localizations_pt.dart';
import 'featurely_localizations_ru.dart';
import 'featurely_localizations_sv.dart';
import 'featurely_localizations_th.dart';
import 'featurely_localizations_tr.dart';
import 'featurely_localizations_uk.dart';
import 'featurely_localizations_vi.dart';
import 'featurely_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of FeaturelyLocalizations
/// returned by `FeaturelyLocalizations.of(context)`.
///
/// Applications need to include `FeaturelyLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/featurely_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: FeaturelyLocalizations.localizationsDelegates,
///   supportedLocales: FeaturelyLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the FeaturelyLocalizations.supportedLocales
/// property.
abstract class FeaturelyLocalizations {
  FeaturelyLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static FeaturelyLocalizations of(BuildContext context) {
    return Localizations.of<FeaturelyLocalizations>(
        context, FeaturelyLocalizations)!;
  }

  static const LocalizationsDelegate<FeaturelyLocalizations> delegate =
      _FeaturelyLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('da'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fil'),
    Locale('fr'),
    Locale('he'),
    Locale('hi'),
    Locale('hu'),
    Locale('it'),
    Locale('ja'),
    Locale('ko'),
    Locale('nb'),
    Locale('nl'),
    Locale('pl'),
    Locale('pt'),
    Locale('pt', 'BR'),
    Locale('ru'),
    Locale('sv'),
    Locale('th'),
    Locale('tr'),
    Locale('uk'),
    Locale('vi'),
    Locale('zh')
  ];

  /// Title of the SDK sheet's root screen.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get sdkListTitle;

  /// The sticky call-to-action button above the safe area on the list screen.
  ///
  /// In en, this message translates to:
  /// **'New feedback'**
  String get sdkListNewFeedback;

  /// Empty state of the feedback list.
  ///
  /// In en, this message translates to:
  /// **'Nothing here yet — be the first to tell us what {appName} should do next'**
  String sdkListEmpty(String appName);

  /// Offline / failed-load state of the list screen.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load feedback. Check your connection.'**
  String get sdkListLoadError;

  /// Vote count label.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one {{count} vote} other {{count} votes}}'**
  String sdkListVotes(int count);

  /// Comment count label.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one {{count} comment} other {{count} comments}}'**
  String sdkListComments(int count);

  /// Title of the filter & sort bottom sheet.
  ///
  /// In en, this message translates to:
  /// **'Filter & sort'**
  String get sdkFilterTitle;

  /// Label of the sort section in the filter sheet.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get sdkFilterSortBy;

  /// Sort option: most voted first.
  ///
  /// In en, this message translates to:
  /// **'Most voted'**
  String get sdkFilterSortMostVoted;

  /// Sort option: newest first.
  ///
  /// In en, this message translates to:
  /// **'Newest'**
  String get sdkFilterSortNewest;

  /// Sort option: oldest first.
  ///
  /// In en, this message translates to:
  /// **'Oldest'**
  String get sdkFilterSortOldest;

  /// Label of the status chips section in the filter sheet.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get sdkFilterStatus;

  /// Status chip that clears the status filter.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get sdkFilterStatusAll;

  /// Button that resets the filter sheet to its defaults.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get sdkFilterReset;

  /// Primary button of the filter sheet with a live result count.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one {Show {count} request} other {Show {count} requests}}'**
  String sdkFilterShowResults(int count);

  /// Status pill label. Declined is dashboard-only and has no SDK string.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get sdkStatusOpen;

  /// Status pill label.
  ///
  /// In en, this message translates to:
  /// **'Planned'**
  String get sdkStatusPlanned;

  /// Status pill label.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get sdkStatusInProgress;

  /// Status pill label.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get sdkStatusDone;

  /// Label of the Feature/Issue segmented control on the submit form.
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get sdkFormTypeLabel;

  /// Segmented-control option for feature requests.
  ///
  /// In en, this message translates to:
  /// **'Feature'**
  String get sdkFormTypeFeature;

  /// Segmented-control option for bug reports. Always "Issue", never "Bug", in end-user surfaces.
  ///
  /// In en, this message translates to:
  /// **'Issue'**
  String get sdkFormTypeIssue;

  /// Label of the title field.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get sdkFormTitleLabel;

  /// Placeholder of the title field.
  ///
  /// In en, this message translates to:
  /// **'Sum it up in a few words'**
  String get sdkFormTitlePlaceholder;

  /// Live counter shown near the 60-character title limit.
  ///
  /// In en, this message translates to:
  /// **'{remaining, plural, one {{remaining} character left} other {{remaining} characters left}}'**
  String sdkFormTitleCounter(int remaining);

  /// Label of the description field.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get sdkFormDescriptionLabel;

  /// Description placeholder when the Feature type is selected.
  ///
  /// In en, this message translates to:
  /// **'What should {appName} do? Tell us how you\'d use it.'**
  String sdkFormDescriptionPlaceholderFeature(String appName);

  /// Description placeholder when the Issue type is selected.
  ///
  /// In en, this message translates to:
  /// **'What went wrong in {appName}? Include what you expected to happen.'**
  String sdkFormDescriptionPlaceholderIssue(String appName);

  /// Label of the optional email field.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get sdkFormEmailLabel;

  /// Helper copy under the email field (PRD OQ-14 wording).
  ///
  /// In en, this message translates to:
  /// **'Optional. We\'ll email you when the team replies or your request ships.'**
  String get sdkFormEmailHelper;

  /// Button that opens the screenshot picker (one screenshot per item).
  ///
  /// In en, this message translates to:
  /// **'Add screenshot'**
  String get sdkFormAddScreenshot;

  /// Accessibility label of the × on the screenshot thumbnail.
  ///
  /// In en, this message translates to:
  /// **'Remove screenshot'**
  String get sdkFormRemoveScreenshot;

  /// Submit button pinned to the bottom of the form.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get sdkFormSubmit;

  /// Submit button label while the submission is in flight.
  ///
  /// In en, this message translates to:
  /// **'Sending…'**
  String get sdkFormSending;

  /// Inline error when a submission fails; the draft is preserved.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t send. Your draft is saved. Check your connection and try again.'**
  String get sdkFormSubmitError;

  /// Submit button label after a failed submission.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get sdkFormTryAgain;

  /// Title of the full-screen submit confirmation.
  ///
  /// In en, this message translates to:
  /// **'Thanks! We read every one of these.'**
  String get sdkSuccessTitle;

  /// Body of the submit confirmation.
  ///
  /// In en, this message translates to:
  /// **'Your feedback went straight to the {appName} team.'**
  String sdkSuccessBody(String appName);

  /// Button returning from the confirmation to the list.
  ///
  /// In en, this message translates to:
  /// **'Back to feedback'**
  String get sdkSuccessBack;

  /// Submission date line on the detail screen. The date is formatted by the platform.
  ///
  /// In en, this message translates to:
  /// **'Submitted {date}'**
  String sdkDetailSubmitted(String date);

  /// Large vote button on the detail screen, not yet voted.
  ///
  /// In en, this message translates to:
  /// **'Vote'**
  String get sdkDetailVote;

  /// Large vote button on the detail screen after voting.
  ///
  /// In en, this message translates to:
  /// **'Voted · {count}'**
  String sdkDetailVoted(int count);

  /// Heading of the comment thread on the detail screen.
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get sdkDetailCommentsTitle;

  /// Placeholder of the comment composer.
  ///
  /// In en, this message translates to:
  /// **'Add a comment…'**
  String get sdkDetailCommentPlaceholder;

  /// Send button of the comment composer.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get sdkDetailCommentSend;

  /// Display name of end-user comment authors.
  ///
  /// In en, this message translates to:
  /// **'Anonymous'**
  String get sdkDetailAnonymous;

  /// Badge on team replies.
  ///
  /// In en, this message translates to:
  /// **'Team'**
  String get sdkDetailTeamBadge;

  /// Accessibility label of the sheet close button.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get sdkCommonClose;

  /// Generic cancel action.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get sdkCommonCancel;

  /// Retry button on the offline / failed-load screen.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get sdkCommonRetry;

  /// The amber strip on debug builds. Kept as a recognizable technical term; translate only where a clear local convention exists.
  ///
  /// In en, this message translates to:
  /// **'SANDBOX'**
  String get sdkSandboxBadge;

  /// Inline error when a picked image cannot be attached (undecodable or over the size limit). [SDK-local extension key — not in the canonical catalog yet]
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t attach that image. Try a different one.'**
  String get sdkFormAttachError;

  /// Field error when the server rejects the optional email (invalid_email). [SDK-local extension key — not in the canonical catalog yet]
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email address.'**
  String get sdkFormEmailError;

  /// Notice shown when commenting is disabled (403 comments_disabled on a stale config). [SDK-local extension key — not in the canonical catalog yet]
  ///
  /// In en, this message translates to:
  /// **'Commenting has been turned off.'**
  String get sdkDetailCommentsDisabled;

  /// Notice for 429 rate_limited responses on user-initiated actions. [SDK-local extension key — not in the canonical catalog yet]
  ///
  /// In en, this message translates to:
  /// **'Too many requests. Try again in a moment.'**
  String get sdkCommonRateLimited;
}

class _FeaturelyLocalizationsDelegate
    extends LocalizationsDelegate<FeaturelyLocalizations> {
  const _FeaturelyLocalizationsDelegate();

  @override
  Future<FeaturelyLocalizations> load(Locale locale) {
    return SynchronousFuture<FeaturelyLocalizations>(
        lookupFeaturelyLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
        'ar',
        'da',
        'de',
        'en',
        'es',
        'fil',
        'fr',
        'he',
        'hi',
        'hu',
        'it',
        'ja',
        'ko',
        'nb',
        'nl',
        'pl',
        'pt',
        'ru',
        'sv',
        'th',
        'tr',
        'uk',
        'vi',
        'zh'
      ].contains(locale.languageCode);

  @override
  bool shouldReload(_FeaturelyLocalizationsDelegate old) => false;
}

FeaturelyLocalizations lookupFeaturelyLocalizations(Locale locale) {
  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'pt':
      {
        switch (locale.countryCode) {
          case 'BR':
            return FeaturelyLocalizationsPtBr();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return FeaturelyLocalizationsAr();
    case 'da':
      return FeaturelyLocalizationsDa();
    case 'de':
      return FeaturelyLocalizationsDe();
    case 'en':
      return FeaturelyLocalizationsEn();
    case 'es':
      return FeaturelyLocalizationsEs();
    case 'fil':
      return FeaturelyLocalizationsFil();
    case 'fr':
      return FeaturelyLocalizationsFr();
    case 'he':
      return FeaturelyLocalizationsHe();
    case 'hi':
      return FeaturelyLocalizationsHi();
    case 'hu':
      return FeaturelyLocalizationsHu();
    case 'it':
      return FeaturelyLocalizationsIt();
    case 'ja':
      return FeaturelyLocalizationsJa();
    case 'ko':
      return FeaturelyLocalizationsKo();
    case 'nb':
      return FeaturelyLocalizationsNb();
    case 'nl':
      return FeaturelyLocalizationsNl();
    case 'pl':
      return FeaturelyLocalizationsPl();
    case 'pt':
      return FeaturelyLocalizationsPt();
    case 'ru':
      return FeaturelyLocalizationsRu();
    case 'sv':
      return FeaturelyLocalizationsSv();
    case 'th':
      return FeaturelyLocalizationsTh();
    case 'tr':
      return FeaturelyLocalizationsTr();
    case 'uk':
      return FeaturelyLocalizationsUk();
    case 'vi':
      return FeaturelyLocalizationsVi();
    case 'zh':
      return FeaturelyLocalizationsZh();
  }

  throw FlutterError(
      'FeaturelyLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
