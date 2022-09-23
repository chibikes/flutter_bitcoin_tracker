import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bitcoin_tracker/bitcoin_history.dart';
import 'package:flutter_bitcoin_tracker/network.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  const PriceScreen({Key? key}) : super(key: key);

  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'USD';
  double bitcoinCurr = 0.0;
  double etheriumCurr = 0.0;
  List<CurrencyData> currencyData = [];
  NetworkHelper networkHelper = NetworkHelper();

  TrackballBehavior? _trackballBehavior;

  @override
  void initState() {
    _trackballBehavior = TrackballBehavior(
      lineColor: Colors.black54,
        enable: true,
        activationMode: ActivationMode.singleTap,
        tooltipSettings: const InteractiveTooltip(format: 'point.x : point.y'));
    getExchangeRate();
    getTimeSeriesData('BTC', selectedCurrency);
    super.initState();
  }

  Future<void> getExchangeRate() async {
    dynamic exchangeRateData =
        await networkHelper.getBTCToCurrency(selectedCurrency);
    dynamic ethExchangRate =
        await networkHelper.getETHToCurrency(selectedCurrency);
    setState(() {
      bitcoinCurr = exchangeRateData['rate'];
      etheriumCurr = ethExchangRate['rate'];
    });
  }

  @override
  Widget build(BuildContext context) {
    var data = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
            child: SizedBox(
              width: 0.80 * data.width,
              height: 0.10 * data.height,
              child: Card(
                color: Colors.black87,
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 28.0),
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
          ),

          // SizedBox(height: data.height * 0.40, width: data.height * 0.70,child: BitcoinHistory(currencyData: currencyData, height: data.height * 0.40, width: data.width * 0.70,)),
          SizedBox(
            height: data.height * 0.50,
            width: data.height * 0.70,
            child: SfCartesianChart(
              trackballBehavior: _trackballBehavior,
              primaryXAxis: DateTimeAxis(
                  title: AxisTitle(text: 'Time in UTC', textStyle: const TextStyle(color: Colors.black)),
                  name: 'Days',
                  labelStyle: const TextStyle(color: Colors.blueGrey)),
              primaryYAxis: NumericAxis(
                  title: AxisTitle(text: selectedCurrency, textStyle: const TextStyle(color: Colors.black)),
                  labelStyle: const TextStyle(color: Colors.blueGrey)),
              title: ChartTitle(text: 'Market Summary > BTC/$selectedCurrency', textStyle: const TextStyle(color: Colors.black)),
              series: <LineSeries<CurrencyData, DateTime>>[
                LineSeries(
                    dataSource: currencyData,
                    xValueMapper: (CurrencyData curr, _) => curr.dateTime,
                    yValueMapper: (CurrencyData curr, _) => curr.amount)
              ],
            ),
          ),

          // Padding(
          //   padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
          //   child: Card(
          //     color: Colors.lightBlueAccent,
          //     elevation: 5.0,
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(10.0),
          //     ),
          //     child: Padding(
          //       padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          //       child: Text(
          //         '1 ETH = $etheriumCurr $selectedCurrency',
          //         textAlign: TextAlign.center,
          //         style: const TextStyle(
          //           fontSize: 20.0,
          //           color: Colors.white,
          //         ),
          //       ),
          //     ),
          //   ),
          //
          // ),
          //
          // Padding(
          //   padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
          //   child: Card(
          //     color: Colors.lightBlueAccent,
          //     elevation: 5.0,
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(10.0),
          //     ),
          //     child: Padding(
          //       padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          //       child: Text(
          //         '1 BTC = $bitcoinCurr $selectedCurrency',
          //         textAlign: TextAlign.center,
          //         style: const TextStyle(
          //           fontSize: 20.0,
          //           color: Colors.white,
          //         ),
          //       ),
          //     ),
          //   ),
          //
          // ),

          Container(
            height: data.height * 0.10,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(bottom: 30.0),
            color: Colors.black54,
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
        getTimeSeriesData('BTC', selectedCurrency);
      },
    );
  }

  Widget iosPicker() {
    return CupertinoPicker(
        itemExtent: 32.0,
        onSelectedItemChanged: (selectedItem) {
          selectedCurrency = currenciesList[selectedItem];
          getExchangeRate();
          getTimeSeriesData('BTC', selectedCurrency);
        },
        children: iosPickerItem);
  }

  getPicker() {
    if (Platform.isIOS) {
      return iosPicker();
    } else if (Platform.isAndroid) {
      return androidPicker();
    }
  }

  Future<List<CurrencyData>> getTimeSeriesData(
      String baseCurrency, String currency) async {
    List<dynamic> timeSeries =
        await networkHelper.getTimeSeriesData(baseCurrency, currency);
    List<CurrencyData> currData = [];
    for (var e in timeSeries) {
      currData.add(
          CurrencyData(DateTime.parse(e['time_period_start']), e['rate_open']));
    }
    // var currData = timeSeries.map((e) => CurrencyData(e['time_period_start'], e['rate_open']));
    setState(() {
      currencyData = currData;
    });
    return currData;
  }
}
