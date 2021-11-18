import 'package:flutter/material.dart';

const List<String> currenciesList = [
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
List<DropdownMenuItem<String>> dropDownList = List.generate(
    currenciesList.length,
    (index) => DropdownMenuItem(
          child: Text(currenciesList[index]),
          value: currenciesList[index],
        ),
);
List<Widget> iosPickerItem = List.generate(currenciesList.length, (index) => Text(currenciesList[index]));

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

class CoinData {}
