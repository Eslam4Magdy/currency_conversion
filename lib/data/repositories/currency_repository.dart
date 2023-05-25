import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/currency_conversion.dart';

class CurrencyRepository {
  final String apiUrl = 'https://api.exchangerate.host';

  Future<List<CurrencyConversion>> fetchCurrencyConversions(
      String baseCurrency,
      String targetCurrency,
      String startDate,
      String endDate,
      int pageNumber,
      ) async {
    final url =
        '$apiUrl/timeseries?start_date=$startDate&end_date=$endDate&base=$baseCurrency&symbols=$targetCurrency&page=$pageNumber';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final Map<String, dynamic> rates = data['rates'];

      return rates.entries.map((entry) {
        final String date = entry.key;
        final double exchangeRate = entry.value[targetCurrency];
        return CurrencyConversion(
          date: date,
          baseCurrency: baseCurrency,
          targetCurrency: targetCurrency,
          exchangeRate: exchangeRate,
        );
      }).toList();
    } else {
      throw Exception('Failed to fetch currency conversions');
    }
  }
}
