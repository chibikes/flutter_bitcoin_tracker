import 'dart:convert';
import 'package:http/http.dart' as http;

String apiKey = '';
class NetworkHelper {
  Future getBTCToCurrency(String currency) async{
    //TODO: handle errors
   var url = Uri.parse('https://rest.coinapi.io/v1/exchangerate/BTC/$currency?apikey=$apiKey');

    http.Response response = await http.get(url);
    print('************* $response.statusCode');
    return jsonDecode(response.body);
  }

  Future getETHToCurrency(String currency) async{
    var url = Uri.parse('https://rest.coinapi.io/v1/exchangerate/ETH/$currency?apikey=$apiKey');
    http.Response response = await http.get(url);
    return jsonDecode(response.body);
  }
}