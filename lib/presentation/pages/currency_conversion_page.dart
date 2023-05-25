import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../data/models/currency_conversion.dart';
import '../../data/repositories/currency_repository.dart';
import '../widgets/dropdowntextfield.dart';

class CurrencyConversionPage extends StatefulWidget {
  const CurrencyConversionPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CurrencyConversionPageState createState() => _CurrencyConversionPageState();
}

class _CurrencyConversionPageState extends State<CurrencyConversionPage> {
  final CurrencyRepository currencyRepository = CurrencyRepository();

  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  String baseCurrency = 'USD'; // Default base currency
  String targetCurrency = 'EGP'; // Default target currency
  bool isStartDateSelected = false;
  bool isEndDateSelected = false;

  List<CurrencyConversion> currencyConversions = [];
  int pageNumber = 1;

  @override
  void initState() {
    super.initState();
    fetchCurrencyConversions();
  }

  List<CurrencyConversion> allCurrencyConversions = [];
  bool isLoading = false;

  Future<void> fetchCurrencyConversions({int limit = 10}) async {
    try {
      if (!isStartDateSelected || !isEndDateSelected) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please Enter Start and End Dates')),
        );
        return;
      }

      setState(() {
        isLoading = true; // Start loading indicator
      });

      final String startDate = startDateController.text;
      final String endDate = endDateController.text;

      if (allCurrencyConversions.isEmpty) {
        allCurrencyConversions = await currencyRepository.fetchCurrencyConversions(
          baseCurrency,
          targetCurrency,
          startDate,
          endDate,
          pageNumber,
        );

        setState(() {
          currencyConversions = allCurrencyConversions.take(limit).toList();
          isLoading = false; // Stop loading indicator
        });
      } else {
        setState(() {
          currencyConversions.addAll(
            allCurrencyConversions.skip(currencyConversions.length).take(limit).toList(),
          );
          isLoading = false; // Stop loading indicator
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false; // Stop loading indicator
      });
    }
  }

  Future<void> selectStartDate(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (selectedDate != null) {
      setState(() {
        startDateController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
        isStartDateSelected = true;
      });
    }
  }

  Future<void> selectEndDate(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (selectedDate != null) {
      setState(() {
        endDateController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
        isEndDateSelected = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Currency Conversion'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Start Date
            TextFormField(
              controller: startDateController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Start Date',
                hintText: 'Enter Start Date',
                suffixIcon: Icon(Icons.calendar_today),
              ),
              onTap: () {
                selectStartDate(context);
              },
            ),
            //End Date
            TextFormField(
              controller: endDateController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'End Date',
                hintText: 'Enter End Date',
                suffixIcon: Icon(Icons.calendar_today),
              ),
              onTap: () {
                selectEndDate(context);
              },
            ),
            const SizedBox(height: 20),
            // Base Currency
            DropdownTextField<String>(
              value: baseCurrency,
              decoration: const InputDecoration(labelText: 'Base Currency'),
              items: ['USD', 'EUR', 'CZK' , 'EGP']
                  .map((currency) => DropdownMenuItem<String>(
                value: currency,
                child: Text(currency),
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  baseCurrency = value!;
                });
              },
            ),
            // Target Currency
            DropdownTextField<String>(
              value: targetCurrency,
              decoration: const InputDecoration(labelText: 'Target Currency'),
              items: ['USD', 'EUR', 'CZK' , 'EGP']
                  .map((currency) => DropdownMenuItem<String>(
                value: currency,
                child: Text(currency),
              ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  targetCurrency = value!;
                });
              },
            ),
            const SizedBox(height: 20),
            // Convert Button
            SizedBox(
              height: 50,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : fetchCurrencyConversions,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Convert',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    if (isLoading)
                      const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            // List of Result
            Expanded(
              child: ListView.builder(
                itemCount: currencyConversions.length + 1,
                itemBuilder: (context, index) {
                  if (index == currencyConversions.length) {
                    return ListTile(
                      title: ElevatedButton(
                        onPressed: fetchCurrencyConversions,
                        child: const Text('Load More'),
                      ),
                    );
                  } else {
                    final currencyConversion = currencyConversions[index];
                    return ListTile(
                      title: Text(currencyConversion.date),
                      subtitle: Text(
                        '${currencyConversion.baseCurrency} to ${currencyConversion.targetCurrency}: ${currencyConversion.exchangeRate}',
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
