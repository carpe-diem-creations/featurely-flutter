// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'featurely_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class FeaturelyLocalizationsId extends FeaturelyLocalizations {
  FeaturelyLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get sdkListTitle => 'Masukan';

  @override
  String get sdkListNewFeedback => 'Masukan baru';

  @override
  String sdkListEmpty(String appName) {
    return 'Belum ada apa-apa di sini — jadilah yang pertama memberi tahu kami apa yang sebaiknya dilakukan $appName berikutnya';
  }

  @override
  String get sdkListLoadError => 'Gagal memuat masukan. Periksa koneksimu.';

  @override
  String sdkListVotes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count suara',
    );
    return '$_temp0';
  }

  @override
  String sdkListComments(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count komentar',
    );
    return '$_temp0';
  }

  @override
  String get sdkFilterTitle => 'Filter & urutkan';

  @override
  String get sdkFilterSortBy => 'Urutkan';

  @override
  String get sdkFilterSortMostVoted => 'Suara terbanyak';

  @override
  String get sdkFilterSortNewest => 'Terbaru';

  @override
  String get sdkFilterSortOldest => 'Terlama';

  @override
  String get sdkFilterStatus => 'Status';

  @override
  String get sdkFilterStatusAll => 'Semua';

  @override
  String get sdkFilterReset => 'Atur ulang';

  @override
  String sdkFilterShowResults(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Tampilkan $count permintaan',
    );
    return '$_temp0';
  }

  @override
  String sdkFilterShowResultsOverflow(int count) {
    return 'Tampilkan $count+ permintaan';
  }

  @override
  String get sdkStatusOpen => 'Terbuka';

  @override
  String get sdkStatusPlanned => 'Direncanakan';

  @override
  String get sdkStatusInProgress => 'Sedang Dikerjakan';

  @override
  String get sdkStatusDone => 'Selesai';

  @override
  String get sdkFormTypeLabel => 'Jenis';

  @override
  String get sdkFormTypeFeature => 'Fitur';

  @override
  String get sdkFormTypeIssue => 'Masalah';

  @override
  String get sdkFormTitleLabel => 'Judul';

  @override
  String get sdkFormTitlePlaceholder => 'Ringkas dalam beberapa kata';

  @override
  String sdkFormTitleCounter(int remaining) {
    String _temp0 = intl.Intl.pluralLogic(
      remaining,
      locale: localeName,
      other: '$remaining karakter tersisa',
    );
    return '$_temp0';
  }

  @override
  String get sdkFormDescriptionLabel => 'Deskripsi';

  @override
  String sdkFormDescriptionPlaceholderFeature(String appName) {
    return 'Apa yang sebaiknya bisa dilakukan $appName?';
  }

  @override
  String sdkFormDescriptionPlaceholderIssue(String appName) {
    return 'Apa yang salah di $appName?';
  }

  @override
  String get sdkFormEmailLabel => 'Email';

  @override
  String get sdkFormEmailHelper =>
      'Opsional. Kami akan mengirimimu email saat tim membalas atau permintaanmu sudah dirilis.';

  @override
  String get sdkFormAddScreenshot => 'Tambahkan tangkapan layar';

  @override
  String get sdkFormRemoveScreenshot => 'Hapus tangkapan layar';

  @override
  String get sdkFormSubmit => 'Kirim';

  @override
  String get sdkFormSending => 'Mengirim…';

  @override
  String get sdkFormSubmitError =>
      'Gagal mengirim. Drafmu sudah disimpan. Periksa koneksimu dan coba lagi.';

  @override
  String get sdkFormTryAgain => 'Coba lagi';

  @override
  String get sdkSuccessTitle => 'Terima kasih! Kami membaca setiap masukan.';

  @override
  String sdkSuccessBody(String appName) {
    return 'Masukanmu langsung dikirim ke tim $appName.';
  }

  @override
  String get sdkSuccessBack => 'Kembali ke masukan';

  @override
  String sdkDetailSubmitted(String date) {
    return 'Dikirim $date';
  }

  @override
  String get sdkDetailVote => 'Beri suara';

  @override
  String sdkDetailVoted(int count) {
    return 'Sudah memberi suara · $count';
  }

  @override
  String get sdkDetailCommentsTitle => 'Komentar';

  @override
  String get sdkDetailCommentPlaceholder => 'Tambahkan komentar…';

  @override
  String get sdkDetailCommentSend => 'Kirim';

  @override
  String get sdkDetailAnonymous => 'Anonim';

  @override
  String get sdkDetailTeamBadge => 'Tim';

  @override
  String get sdkCommonClose => 'Tutup';

  @override
  String get sdkCommonCancel => 'Batal';

  @override
  String get sdkCommonRetry => 'Coba lagi';

  @override
  String get sdkSandboxBadge => 'SANDBOX';

  @override
  String get sdkFormAttachError =>
      'Gambar ini tidak bisa dilampirkan. Coba gambar lain.';

  @override
  String get sdkFormEmailError => 'Masukkan alamat email yang valid.';

  @override
  String get sdkDetailCommentsDisabled => 'Komentar telah dinonaktifkan.';

  @override
  String get sdkCommonRateLimited =>
      'Terlalu banyak permintaan. Coba lagi sebentar lagi.';

  @override
  String get sdkChatAssistantName => 'Asisten';

  @override
  String sdkChatAssistantTyping(String name) {
    return '$name sedang mengetik…';
  }

  @override
  String get sdkChatComposerPlaceholder => 'Tulis pesan…';

  @override
  String get sdkChatEmptyGreeting =>
      'Hai! Kirimi kami pesan, dan tim kami akan membalasmu di sini.';

  @override
  String get sdkChatLoadEarlier => 'Muat pesan sebelumnya';

  @override
  String get sdkChatMessageUs => 'Kirim pesan';

  @override
  String get sdkChatNotSentRetry => 'Tidak terkirim — Ketuk untuk coba lagi';

  @override
  String get sdkChatSend => 'Kirim';

  @override
  String get sdkChatSending => 'Mengirim…';

  @override
  String get sdkChatTeamLabel => 'Tim';

  @override
  String get sdkChatTitle => 'Pesan';

  @override
  String get sdkChatToday => 'Hari ini';

  @override
  String sdkChatTooLong(int max) {
    return 'Pesan ini terlalu panjang. Batasnya $max karakter.';
  }

  @override
  String get sdkChatYesterday => 'Kemarin';
}
