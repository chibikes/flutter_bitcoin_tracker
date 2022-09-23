import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'config.dart';

String apiKey = secretKey;
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
  Future getTimeSeriesData(String baseCurrency, String currency) async {
    var now = DateTime.now();
    var nowT = DateTime(now.year, now.month, now.day, now.hour, now.minute, 0).toUtc().toIso8601String();
    var earlier = DateTime.now().subtract(const Duration(hours: 5));
    var earlierT = DateTime(earlier.year, earlier.month, earlier.day, earlier.hour, earlier.minute, 0).toUtc().toIso8601String();
    var url = Uri.parse('https://rest.coinapi.io/v1/exchangerate/$baseCurrency/$currency/history?period_id=1MIN&time_start=$earlierT&time_end=$nowT&apikey=$apiKey');
    http.Response response = await http.get(url);
    return jsonDecode(response.body);
  }
}