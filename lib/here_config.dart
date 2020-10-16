class HEREConfig {
  static const String appId = 'FNrw0TzjwNxN07m1Vrd9';
  static const String appCode = '7E0iTkl3ohq2-N_jaSdoEA';

  static const String normalMapUrl = 'https://{s}.base.maps.api.here.com/maptile/2.1/maptile/newest/normal.day/{z}/{x}/{y}/256/png8?app_id=$appId&app_code=$appCode';
  static const String satelliteMapUrl = 'https://{s}.aerial.maps.api.here.com/maptile/2.1/maptile/newest/satellite.day/{z}/{x}/{y}/256/png8?app_id=$appId&app_code=$appCode';
  static const String hybridMapUrl = 'https://{s}.aerial.maps.api.here.com/maptile/2.1/maptile/newest/hybrid.day/{z}/{x}/{y}/256/png8?app_id=$appId&app_code=$appCode';

  static const String staticMapUrl = 'https://image.maps.api.here.com/mia/1.6/route?app_id=$appId&app_code=$appCode&f=4';

  static const String weatherUrl = 'https://weather.api.here.com/weather/1.0/report.json';
}