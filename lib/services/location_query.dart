class TicketmasterMarket {
  final String code;
  final String nameEn;
  final String nameAr;

  const TicketmasterMarket(this.code, this.nameEn, this.nameAr);

  String label(bool isArabic) => isArabic ? nameAr : nameEn;
}

/// Countries Ticketmaster actually sells in. Used by the Home country dropdown.
const ticketmasterMarkets = [
  TicketmasterMarket('GB', 'United Kingdom', 'المملكة المتحدة'),
  TicketmasterMarket('US', 'United States', 'الولايات المتحدة'),
  TicketmasterMarket('CA', 'Canada', 'كندا'),
  TicketmasterMarket('IE', 'Ireland', 'أيرلندا'),
  TicketmasterMarket('AU', 'Australia', 'أستراليا'),
  TicketmasterMarket('NZ', 'New Zealand', 'نيوزيلندا'),
  TicketmasterMarket('DE', 'Germany', 'ألمانيا'),
  TicketmasterMarket('ES', 'Spain', 'إسبانيا'),
  TicketmasterMarket('NL', 'Netherlands', 'هولندا'),
  TicketmasterMarket('AE', 'United Arab Emirates', 'الإمارات'),
  TicketmasterMarket('MX', 'Mexico', 'المكسيك'),
  TicketmasterMarket('TR', 'Turkey', 'تركيا'),
];

/// Turns a location field into Ticketmaster `city` and/or `countryCode`.
class LocationQuery {
  final String? city;
  final String? countryCode;

  const LocationQuery({this.city, this.countryCode});

  /// Accepts a city (`London`), a country (`UK`), or both (`London, UK`).
  static LocationQuery parse(String raw) {
    final text = raw.trim();
    if (text.isEmpty) return const LocationQuery(city: 'London');

    if (text.contains(',')) {
      final parts = text.split(',');
      final left = parts.first.trim();
      final right = parts.sublist(1).join(',').trim();
      final rightCode = countryCodeFor(right);
      final leftCode = countryCodeFor(left);

      if (rightCode != null && left.isNotEmpty && leftCode == null) {
        return LocationQuery(city: left, countryCode: rightCode);
      }
      if (leftCode != null && right.isEmpty) {
        return LocationQuery(countryCode: leftCode);
      }
    }

    final code = countryCodeFor(text);
    if (code != null) return LocationQuery(countryCode: code);
    return LocationQuery(city: text);
  }

  static String? countryCodeFor(String raw) {
    final key = _normalize(raw);
    if (key.isEmpty) return null;
    return _countryCodes[key];
  }

  static String _normalize(String value) {
    return value
        .trim()
        .toLowerCase()
        .replaceAll('.', '')
        .replaceAll(RegExp(r'\s+'), ' ');
  }

  /// Ticketmaster market names and common aliases → ISO 3166-1 alpha-2.
  static const Map<String, String> _countryCodes = {
    'uk': 'GB',
    'gb': 'GB',
    'united kingdom': 'GB',
    'great britain': 'GB',
    'britain': 'GB',
    'england': 'GB',
    'scotland': 'GB',
    'wales': 'GB',
    'northern ireland': 'GB',
    'us': 'US',
    'usa': 'US',
    'united states': 'US',
    'united states of america': 'US',
    'america': 'US',
    'ca': 'CA',
    'canada': 'CA',
    'ie': 'IE',
    'ireland': 'IE',
    'republic of ireland': 'IE',
    'au': 'AU',
    'australia': 'AU',
    'nz': 'NZ',
    'new zealand': 'NZ',
    'de': 'DE',
    'germany': 'DE',
    'deutschland': 'DE',
    'es': 'ES',
    'spain': 'ES',
    'nl': 'NL',
    'netherlands': 'NL',
    'holland': 'NL',
    'mx': 'MX',
    'mexico': 'MX',
    'ae': 'AE',
    'uae': 'AE',
    'united arab emirates': 'AE',
    'fr': 'FR',
    'france': 'FR',
    'it': 'IT',
    'italy': 'IT',
    'at': 'AT',
    'austria': 'AT',
    'be': 'BE',
    'belgium': 'BE',
    'ch': 'CH',
    'switzerland': 'CH',
    'se': 'SE',
    'sweden': 'SE',
    'no': 'NO',
    'norway': 'NO',
    'dk': 'DK',
    'denmark': 'DK',
    'pl': 'PL',
    'poland': 'PL',
    'pt': 'PT',
    'portugal': 'PT',
    'tr': 'TR',
    'turkey': 'TR',
    'türkiye': 'TR',
    'turkiye': 'TR',
  };
}
