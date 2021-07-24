import 'dart:io';

enum CountryKey {
  USA,
  UK,
  Germany,
  France,
  Japan,
  Canada,
  China,
  Italy,
  Spain,
  India,
  Brazil,
  Mexico,
  Australia,
}

/// https://pub.dev/documentation/locales/latest/locales/Locale-class.html
const Map<String, CountryKey> countryLocale = {
  'US': CountryKey.USA,
  'GB': CountryKey.UK,
  'DE': CountryKey.Germany,
  'FR': CountryKey.France,
  'JP': CountryKey.Japan,
  'CA': CountryKey.Canada,
  'CN': CountryKey.China,
  'IT': CountryKey.Italy,
  'ES': CountryKey.Spain,
  'IN': CountryKey.India,
  'BR': CountryKey.Brazil,
  'MX': CountryKey.Mexico,
  'AU': CountryKey.Australia,
};

/// https://en.wikipedia.org/wiki/Amazon_(company)
const Map<CountryKey, String> domains = {
  CountryKey.USA: 'amazon.com',
  CountryKey.UK: 'amazon.co.uk',
  CountryKey.Germany: 'amazon.de',
  CountryKey.France: 'amazon.fr',
  CountryKey.Japan: 'amazon.co.jp',
  CountryKey.Canada: 'amazon.ca',
  CountryKey.China: 'amazon.cn',
  CountryKey.Italy: 'amazon.it',
  CountryKey.Spain: 'amazon.es',
  CountryKey.India: 'amazon.in',
  CountryKey.Brazil: 'amazon.com.br',
  CountryKey.Mexico: 'amazon.com.mx',
  CountryKey.Australia: 'amazon.com.au',
};

const Map<CountryKey, String> codes = {
  CountryKey.USA: '01',
  CountryKey.UK: '02',
  CountryKey.Germany: '03',
  CountryKey.France: '08',
  CountryKey.Japan: '09',
  CountryKey.Canada: '15',
  CountryKey.China: '28',
  CountryKey.Italy: '29',
  CountryKey.Spain: '30',
  CountryKey.India: '31',
  CountryKey.Brazil: '32',
  CountryKey.Mexico: '33',
  CountryKey.Australia: '35',
};

class AmazonImageSetting {
  String _trackingId = 'flutter_amazon_image-22';
  String _defaultCountry = 'US';

  get trackingId => _trackingId;
  get defaultCountry => _defaultCountry;

  static final AmazonImageSetting _instance = AmazonImageSetting._internal();
  factory AmazonImageSetting() {
    return _instance;
  }
  AmazonImageSetting._internal() {
    var localName = Platform.localeName;
    if (3 < localName.length){
      _defaultCountry = localName.substring(3);
    }
  }

  void setTrackingId(String trackingId) {
    _trackingId = trackingId;
  }
}
