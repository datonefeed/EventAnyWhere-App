import 'package:flutter/material.dart';
import 'filter_content.dart';

class FilterBottomSheet extends StatelessWidget {
  const FilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: FilterContent(),
    );
  }
}
