import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LanguageNotifier extends Notifier<Locale> {
  @override
  Locale build() {
    return const Locale('uz');
  }

  void setLocale(Locale locale) {
    if (!['uz', 'en', 'ru', 'tg'].contains(locale.languageCode)) return;
    state = locale;
  }
}

final languageProvider = NotifierProvider<LanguageNotifier, Locale>(() {
  return LanguageNotifier();
});
