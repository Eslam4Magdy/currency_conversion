import '../../data/models/currency_conversion.dart';

abstract class CurrencyRepository {
  Future<List<CurrencyConversion>> fetchCurrencyConversions(
      String baseCurrency,
      String targetCurrency,
      String startDate,
      String endDate,
      int pageNumber,
      );
}
