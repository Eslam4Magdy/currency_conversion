import 'package:flutter/material.dart';

class DropdownTextField<T> extends StatelessWidget {
  final T value;
  final InputDecoration decoration;
  final List<DropdownMenuItem<T>> items;
  final void Function(T?)? onChanged;
  final Key? key;

  const DropdownTextField({
    this.key,
    required this.value,
    required this.decoration,
    required this.items,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      key: key,
      value: value,
      decoration: decoration,
      items: items,
      onChanged: onChanged,
    );
  }
}
