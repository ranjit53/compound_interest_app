import 'package:flutter/material.dart';
import '../models/interest_result.dart';

class ResultCard extends StatelessWidget {
  final InterestResult result;

  const ResultCard({
    Key? key,
    required this.result,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'गणना गरिएको परिणाम',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0066CC),
              ),
            ),
            const SizedBox(height: 16),
            _buildResultRow(
              'जम्मा तिर्नुपर्ने रकम',
              '₹ ${result.totalAmount.toStringAsFixed(2)}',
            ),
            const SizedBox(height: 12),
            _buildResultRow(
              'कुल ब्याज',
              '₹ ${result.interest.toStringAsFixed(2)}',
            ),
            const SizedBox(height: 12),
            _buildResultRow(
              'कुल दिन',
              '${result.totalDays} दिन',
            ),
            const SizedBox(height: 12),
            _buildResultRow(
              'कुल वर्ष',
              '${result.totalYears.toStringAsFixed(2)} वर्ष',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF666666),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF333333),
          ),
        ),
      ],
    );
  }
}
