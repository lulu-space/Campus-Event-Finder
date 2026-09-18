import 'package:flutter/material.dart';

import '../services/local_storage_service.dart';

/// Simple bilingual support: English ('en') and Arabic ('ar').
class LanguageProvider extends ChangeNotifier {
  String _lang = 'en';

  String get lang => _lang;
  bool get isArabic => _lang == 'ar';
  Locale get locale => Locale(_lang);
  TextDirection get textDirection =>
      _lang == 'ar' ? TextDirection.rtl : TextDirection.ltr;

  Future<void> load() async {
    _lang = await LocalStorageService.loadLanguage();
    notifyListeners();
  }

  Future<void> toggle() async {
    _lang = _lang == 'en' ? 'ar' : 'en';
    await LocalStorageService.saveLanguage(_lang);
    notifyListeners();
  }

  /// Returns the translated string for [key].
  String t(String key) => _strings[_lang]?[key] ?? _strings['en']![key] ?? key;

  static const Map<String, Map<String, String>> _strings = {
    'en': {
      'app_title': 'Campus Event Finder',
      'tagline': 'Find your next campus event',
      'home': 'Home',
      'my_events': 'My Events',
      'favorites': 'Favorites',
      'profile': 'Profile',
      'search_hint': 'Search events…',
      'city_hint': 'City or country (e.g. London or UK)',
      'loading_details': 'Loading details…',
      'all': 'All',
      'featured': 'Featured',
      'upcoming': 'Upcoming Events',
      'no_events': 'No events found.',
      'no_favorites': 'No favorites yet.\nTap ♡ on any event.',
      'no_registered': 'You have not registered for any events yet.',
      'register': 'Register',
      'registered': 'Registered ✓',
      'register_title': 'Register for Event',
      'name': 'Full Name',
      'email': 'University Email',
      'student_id': 'Student ID',
      'submit': 'Confirm Registration',
      'cancel': 'Cancel',
      'success': 'You are registered!',
      'already_registered': 'Already registered for this event.',
      'get_tickets': 'Get Tickets',
      'dark_mode': 'Dark Mode',
      'language': 'Language',
      'arabic': 'العربية',
      'english': 'English',
      'venue': 'Venue',
      'date': 'Date',
      'time': 'Time',
      'category': 'Category',
      'name_required': 'Please enter your name.',
      'email_required': 'Please enter a valid university email.',
      'id_required': 'Please enter your student ID.',
      'retry': 'Retry',
      'error_network': 'Could not connect. Check your internet connection.',
      'loading': 'Loading events…',
      'city': 'City',
    },
    'ar': {
      'app_title': 'مكتشف الفعاليات الجامعية',
      'tagline': 'اعثر على فعاليتك الجامعية القادمة',
      'home': 'الرئيسية',
      'my_events': 'فعالياتي',
      'favorites': 'المفضلة',
      'profile': 'الملف الشخصي',
      'search_hint': 'ابحث عن فعاليات…',
      'city_hint': 'المدينة أو الدولة (مثال: London أو UK)',
      'loading_details': 'جارٍ تحميل التفاصيل…',
      'all': 'الكل',
      'featured': 'مميز',
      'upcoming': 'الفعاليات القادمة',
      'no_events': 'لا توجد فعاليات.',
      'no_favorites': 'لا مفضلات بعد.\nاضغط ♡ على أي فعالية.',
      'no_registered': 'لم تسجل في أي فعالية بعد.',
      'register': 'سجّل',
      'registered': 'مسجّل ✓',
      'register_title': 'التسجيل في الفعالية',
      'name': 'الاسم الكامل',
      'email': 'البريد الجامعي',
      'student_id': 'الرقم الجامعي',
      'submit': 'تأكيد التسجيل',
      'cancel': 'إلغاء',
      'success': 'تم التسجيل بنجاح!',
      'already_registered': 'أنت مسجّل مسبقاً في هذه الفعالية.',
      'get_tickets': 'احجز تذاكر',
      'dark_mode': 'الوضع الداكن',
      'language': 'اللغة',
      'arabic': 'العربية',
      'english': 'English',
      'venue': 'المكان',
      'date': 'التاريخ',
      'time': 'الوقت',
      'category': 'الفئة',
      'name_required': 'الرجاء إدخال اسمك.',
      'email_required': 'الرجاء إدخال بريد جامعي صالح.',
      'id_required': 'الرجاء إدخال رقمك الجامعي.',
      'retry': 'إعادة المحاولة',
      'error_network': 'تعذّر الاتصال. تحقق من اتصالك بالإنترنت.',
      'loading': 'جارٍ التحميل…',
      'city': 'المدينة',
    },
  };
}
