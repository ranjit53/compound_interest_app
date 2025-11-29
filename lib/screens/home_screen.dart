import 'package:flutter/material.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import '../models/interest_result.dart';
import '../utils/calculator.dart';
import '../widgets/input_field.dart';
import '../widgets/result_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final _principalController = TextEditingController();
  final _rateController = TextEditingController();
  
  NepaliDateTime? _loanDate;
  NepaliDateTime? _paymentDate;
  
  InterestResult? _result;

  @override
  void dispose() {
    _principalController.dispose();
    _rateController.dispose();
    super.dispose();
  }

  /// Validates principal amount
  String? _validatePrincipal(String? value) {
    if (value == null || value.isEmpty) {
      return 'कृपया मूलधन राखनुहोस्';
    }
    if (double.tryParse(value) == null) {
      return 'कृपया वैध संख्या राखनुहोस्';
    }
    if (double.parse(value) <= 0) {
      return 'मूलधन ० भन्दा बढी हुनुपर्छ';
    }
    return null;
  }

  /// Validates interest rate
  String? _validateRate(String? value) {
    if (value == null || value.isEmpty) {
      return 'कृपया ब्याजदर राखनुहोस्';
    }
    if (double.tryParse(value) == null) {
      return 'कृपया वैध संख्या राखनुहोस्';
    }
    if (double.parse(value) < 0) {
      return 'ब्याजदर नकारात्मक हुन सक्दैन';
    }
    return null;
  }

  /// Opens Nepali date picker for loan date
  Future<void> _selectLoanDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      final nepaliDate = pickedDate.toNepaliDateTime();
      setState(() {
        _loanDate = nepaliDate;
      });
    }
  }

  /// Opens Nepali date picker for payment date
  Future<void> _selectPaymentDate() async {
    final initialDate = _loanDate != null
        ? _loanDate!.toDateTime()
        : DateTime.now();
    
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: initialDate,
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      final nepaliDate = pickedDate.toNepaliDateTime();
      setState(() {
        _paymentDate = nepaliDate;
      });
    }
  }

  /// Formats NepaliDateTime to readable string (YYYY/MM/DD)
  String _formatNepaliDate(NepaliDateTime? date) {
    if (date == null) return 'मिति छनोट गर्नुहोस्';
    return '${date.year}/${date.month.toString().padLeft(2, '0')}/${date.day.toString().padLeft(2, '0')}';
  }

  /// Validates all inputs and calculates compound interest
  void _calculateInterest() {
    // Validate form fields
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('कृपया सबै फिल्ड सही तरिकाले भरनुहोस्'),
          backgroundColor: Color(0xFFCC0000),
        ),
      );
      return;
    }

    // Validate dates are selected
    if (_loanDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('कृपया रकम लिएको मिति छनोट गर्नुहोस्'),
          backgroundColor: Color(0xFFCC0000),
        ),
      );
      return;
    }

    if (_paymentDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('कृपया रकम बुझाउने मिति छनोट गर्नुहोस्'),
          backgroundColor: Color(0xFFCC0000),
        ),
      );
      return;
    }

    // Validate that payment date is after loan date
    if (_paymentDate!.isBefore(_loanDate!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('रकम बुझाउने मिति रकम लिएको मिति भन्दा पछि हुनुपर्छ'),
          backgroundColor: Color(0xFFCC0000),
        ),
      );
      return;
    }

    // Parse principal and rate
    final principal = double.parse(_principalController.text);
    final rate = double.parse(_rateController.text);

    // Calculate compound interest
    final result = CompoundInterestCalculator.calculateCompoundInterest(
      principal: principal,
      rate: rate,
      loanDate: _loanDate!,
      paymentDate: _paymentDate!,
    );

    setState(() {
      _result = result;
    });

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('गणना सफलतापूर्वक पूरा भयो'),
        backgroundColor: Color(0xFF009900),
      ),
    );
  }

  /// Resets all form fields and results
  void _resetForm() {
    _formKey.currentState!.reset();
    _principalController.clear();
    _rateController.clear();
    setState(() {
      _loanDate = null;
      _paymentDate = null;
      _result = null;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('फर्म रिसेट गरिएको छ'),
        backgroundColor: Color(0xFF0066CC),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset(
            'assets/images/logo.png',
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => const Icon(Icons.account_balance),
          ),
        ),
        title: const Text(
          'चक्रीय ब्याज निकाल्नुहोस्',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF0066CC),
        elevation: 4,
        centerTitle: true,
      ),
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.cover,
            ),
          ),

          // Foreground content with slight white overlay for readability
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.88),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(12.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
              // Principal Amount Input
              InputField(
                label: 'मूलधन (Principal Amount)',
                hintText: 'उदाहरण: 10000',
                controller: _principalController,
                keyboardType: TextInputType.number,
                validator: _validatePrincipal,
              ),
              const SizedBox(height: 16),

              // Interest Rate Input
              InputField(
                label: 'ब्याजदर % प्रति वर्ष (Interest Rate per year)',
                hintText: 'उदाहरण: 12.5',
                controller: _rateController,
                keyboardType: TextInputType.number,
                validator: _validateRate,
              ),
              const SizedBox(height: 16),

              // Loan Distribution Date Picker
              const Text(
                'रकम लिएको मिति (Loan Distribution Date – B.S.)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: _selectLoanDate,
                icon: const Icon(Icons.calendar_today),
                label: Text(_formatNepaliDate(_loanDate)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0066CC),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Payment Date Picker
              const Text(
                'रकम बुझाउने मिति (Payment Date – B.S.)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: _selectPaymentDate,
                icon: const Icon(Icons.calendar_today),
                label: Text(_formatNepaliDate(_paymentDate)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0066CC),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Calculate and Reset Buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _calculateInterest,
                      icon: const Icon(Icons.calculate),
                      label: const Text('हिसाब गर्नुहोस्'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF009900),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _resetForm,
                      icon: const Icon(Icons.refresh),
                      label: const Text('रिसेट गर्नुहोस्'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF0066CC),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                        side: const BorderSide(
                          color: Color(0xFF0066CC),
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Display Result Card if calculation is done
              if (_result != null)
                ResultCard(result: _result!)
              else
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0F0F0),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'गणना गर्नुहोस् बटन दबाएर परिणाम यहाँ देखिनेछ',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF999999),
                      ),
                    ),
                  ),
                ),

              // Footer
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Column(
                  children: const [
                    const Divider(),
                    const SizedBox(height: 8),
                    Text('Developed By Ranjit Kumar Mahato', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text('If Any Inquiry', style: TextStyle(fontSize: 12)),
                    const SizedBox(height: 2),
                    Text('WhatsApp Num. : +977 9844588219', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),

            ],
                  ), // Column
                ), // Form
              ), // Container
            ), // SingleChildScrollView
          ], // Stack children
        ), // Stack
      );
  }
}
