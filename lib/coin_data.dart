import 'package:http/http.dart' as http;
import 'dart:convert';

const List<String> currenciesList = [
  'UGX',
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

class CoinData {
  Future<dynamic> getCoinRate({String crpto, String currency}) async {
    http.Response response = await http.get(
        'https://apiv2.bitcoinaverage.com/indices/global/ticker/$crpto$currency');
    if (response.statusCode == 200) {
      var coinData =
          await jsonDecode(response.body); //returns decoded weather json data
      return coinData;
    } else {
      print(response.statusCode);
    }
  }
}
