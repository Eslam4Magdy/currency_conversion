class CurrencyConversion {
  final String date;
  final String baseCurrency;
  final String targetCurrency;
  final double exchangeRate;

  CurrencyConversion({
    required this.date,
    required this.baseCurrency,
    required this.targetCurrency,
    required this.exchangeRate,
  });
}
