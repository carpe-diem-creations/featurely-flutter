// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'featurely_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Finnish (`fi`).
class FeaturelyLocalizationsFi extends FeaturelyLocalizations {
  FeaturelyLocalizationsFi([String locale = 'fi']) : super(locale);

  @override
  String get sdkListTitle => 'Palaute';

  @override
  String get sdkListNewFeedback => 'Uusi palaute';

  @override
  String sdkListEmpty(String appName) {
    return 'Täällä ei ole vielä mitään — kerro ensimmäisenä, mitä sovelluksen $appName pitäisi tehdä seuraavaksi';
  }

  @override
  String get sdkListLoadError =>
      'Palautteen lataaminen epäonnistui. Tarkista yhteytesi.';

  @override
  String sdkListVotes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count ääntä',
      one: '$count ääni',
    );
    return '$_temp0';
  }

  @override
  String sdkListComments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kommenttia',
      one: '$count kommentti',
    );
    return '$_temp0';
  }

  @override
  String get sdkFilterTitle => 'Suodata ja järjestä';

  @override
  String get sdkFilterSortBy => 'Järjestys';

  @override
  String get sdkFilterSortMostVoted => 'Eniten ääniä';

  @override
  String get sdkFilterSortNewest => 'Uusimmat';

  @override
  String get sdkFilterSortOldest => 'Vanhimmat';

  @override
  String get sdkFilterStatus => 'Tila';

  @override
  String get sdkFilterStatusAll => 'Kaikki';

  @override
  String get sdkFilterReset => 'Nollaa';

  @override
  String sdkFilterShowResults(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Näytä $count toivetta',
      one: 'Näytä $count toive',
    );
    return '$_temp0';
  }

  @override
  String sdkFilterShowResultsOverflow(int count) {
    return 'Näytä $count+ toivetta';
  }

  @override
  String get sdkStatusOpen => 'Avoin';

  @override
  String get sdkStatusPlanned => 'Suunniteltu';

  @override
  String get sdkStatusInProgress => 'Työn alla';

  @override
  String get sdkStatusDone => 'Valmis';

  @override
  String get sdkFormTypeLabel => 'Tyyppi';

  @override
  String get sdkFormTypeFeature => 'Ominaisuus';

  @override
  String get sdkFormTypeIssue => 'Ongelma';

  @override
  String get sdkFormTitleLabel => 'Otsikko';

  @override
  String get sdkFormTitlePlaceholder => 'Tiivistä muutamaan sanaan';

  @override
  String sdkFormTitleCounter(int remaining) {
    String _temp0 = intl.Intl.pluralLogic(
      remaining,
      locale: localeName,
      other: '$remaining merkkiä jäljellä',
      one: '$remaining merkki jäljellä',
    );
    return '$_temp0';
  }

  @override
  String get sdkFormDescriptionLabel => 'Kuvaus';

  @override
  String sdkFormDescriptionPlaceholderFeature(String appName) {
    return 'Mitä sovelluksen $appName pitäisi tehdä?';
  }

  @override
  String sdkFormDescriptionPlaceholderIssue(String appName) {
    return 'Mikä meni pieleen sovelluksessa $appName?';
  }

  @override
  String get sdkFormEmailLabel => 'Sähköposti';

  @override
  String get sdkFormEmailHelper =>
      'Valinnainen. Lähetämme sinulle sähköpostia, kun tiimi vastaa tai toiveesi toteutuu.';

  @override
  String get sdkFormAddScreenshot => 'Lisää kuvakaappaus';

  @override
  String get sdkFormRemoveScreenshot => 'Poista kuvakaappaus';

  @override
  String get sdkFormSubmit => 'Lähetä';

  @override
  String get sdkFormSending => 'Lähetetään…';

  @override
  String get sdkFormSubmitError =>
      'Lähetys epäonnistui. Luonnoksesi on tallessa. Tarkista yhteytesi ja yritä uudelleen.';

  @override
  String get sdkFormTryAgain => 'Yritä uudelleen';

  @override
  String get sdkSuccessTitle => 'Kiitos! Luemme jokaisen palautteen.';

  @override
  String sdkSuccessBody(String appName) {
    return 'Palautteesi meni suoraan $appName-tiimille.';
  }

  @override
  String get sdkSuccessBack => 'Takaisin palautteisiin';

  @override
  String sdkDetailSubmitted(String date) {
    return 'Lähetetty $date';
  }

  @override
  String get sdkDetailVote => 'Äänestä';

  @override
  String sdkDetailVoted(int count) {
    return 'Äänestetty · $count';
  }

  @override
  String get sdkDetailCommentsTitle => 'Kommentit';

  @override
  String get sdkDetailCommentPlaceholder => 'Lisää kommentti…';

  @override
  String get sdkDetailCommentSend => 'Lähetä';

  @override
  String get sdkDetailAnonymous => 'Nimetön';

  @override
  String get sdkDetailTeamBadge => 'Tiimi';

  @override
  String get sdkCommonClose => 'Sulje';

  @override
  String get sdkCommonCancel => 'Peruuta';

  @override
  String get sdkCommonRetry => 'Yritä uudelleen';

  @override
  String get sdkSandboxBadge => 'SANDBOX';

  @override
  String get sdkFormAttachError =>
      'Kuvan liittäminen epäonnistui. Kokeile toista kuvaa.';

  @override
  String get sdkFormEmailError => 'Anna kelvollinen sähköpostiosoite.';

  @override
  String get sdkDetailCommentsDisabled => 'Kommentointi on poistettu käytöstä.';

  @override
  String get sdkCommonRateLimited =>
      'Liian monta pyyntöä. Yritä hetken kuluttua uudelleen.';

  @override
  String get sdkChatComposerPlaceholder => 'Kirjoita viesti…';

  @override
  String get sdkChatEmailEdit => 'Muokkaa';

  @override
  String get sdkChatEmailInvalid => 'Anna kelvollinen sähköpostiosoite.';

  @override
  String get sdkChatEmailPlaceholder => 'Sähköpostiosoitteesi';

  @override
  String get sdkChatEmailPrompt => 'Saa vastaukset sähköpostiin';

  @override
  String get sdkChatEmailSave => 'Tallenna';

  @override
  String get sdkChatEmailSaved => 'Sähköposti vastauksille';

  @override
  String get sdkChatEmptyGreeting =>
      'Hei! Lähetä meille viesti, niin tiimimme vastaa sinulle täällä.';

  @override
  String get sdkChatLoadEarlier => 'Lataa aiemmat viestit';

  @override
  String get sdkChatMessageUs => 'Lähetä meille viesti';

  @override
  String get sdkChatNotSentRetry =>
      'Ei lähetetty — yritä uudelleen napauttamalla';

  @override
  String get sdkChatSend => 'Lähetä';

  @override
  String get sdkChatSending => 'Lähetetään…';

  @override
  String get sdkChatTeamLabel => 'Tiimi';

  @override
  String get sdkChatTitle => 'Viestit';

  @override
  String sdkChatTooLong(int max) {
    return 'Viesti on liian pitkä. Enimmäispituus on $max merkkiä.';
  }
}
