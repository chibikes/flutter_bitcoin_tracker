import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bitcoin_tracker/network.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}


class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  double bitcoinCurr = 0.0;
  double etheriumCurr = 0.0;
  NetworkHelper networkHelper = NetworkHelper();

  @override
  void initState()  {
    getExchangeRate();
    super.initState();
  }
  Future<void> getExchangeRate() async{
      dynamic exchangeRateData = await networkHelper.getBTCToCurrency(selectedCurrency);
      dynamic ethExchangRate = await networkHelper.getETHToCurrency(selectedCurrency);
      setState(() {
      bitcoinCurr = exchangeRateData['rate'];
      etheriumCurr = ethExchangRate['rate'];
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                child: Text(
                  '1 BTC = $bitcoinCurr $selectedCurrency',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                child: Text(
                  '1 ETH = $etheriumCurr $selectedCurrency',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: Card(
              color: Colors.lightBlueAccent,
              elevation: 5.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
                child: Text(
                  '1 BTC = $bitcoinCurr $selectedCurrency',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 20.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

          ),

          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: getPicker(),
          ),
        ],
      ),
    );
  }

  Widget androidPicker() {
    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropDownList,
      onChanged: (value) {
          selectedCurrency = value!;
          getExchangeRate();
      },
    );
  }

  Widget iosPicker() {
    return CupertinoPicker(
        itemExtent: 32.0,
        onSelectedItemChanged: (selectedItem) {
            selectedCurrency = currenciesList[selectedItem];
            getExchangeRate();
        },
        children: iosPickerItem);
  }
  getPicker() {
    if(Platform.isIOS) {
      return iosPicker();
    } else if (Platform.isAndroid) {
      return androidPicker();
    }
  }
}
