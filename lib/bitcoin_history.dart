import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class BitcoinHistory extends StatelessWidget {
  const BitcoinHistory({Key? key, required this.currencyData, required this.height, required this.width, }) : super(key: key);
  final List<CurrencyData> currencyData;
  final double height;
  final double width;
  // final TrackballBehavior trackballBehavior;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SfCartesianChart(
          // trackballBehavior: trackballBehavior,
          primaryXAxis: DateTimeAxis(name: 'Days', labelStyle: const TextStyle(color: Colors.blueGrey)),
          primaryYAxis: NumericAxis(labelStyle: const TextStyle(color: Colors.blueGrey)),
          title: ChartTitle(text: 'Market Summary > BTC/USD'),
          series: <LineSeries<CurrencyData, DateTime>> [
            LineSeries(dataSource: currencyData, xValueMapper: (CurrencyData curr, _) => curr.dateTime, yValueMapper: (CurrencyData curr, _) => curr.amount)
          ],
        ),
      ),
    );
  }

}
class CurrencyData {
  final DateTime dateTime;
  final double amount;

  CurrencyData(this.dateTime, this.amount);
}