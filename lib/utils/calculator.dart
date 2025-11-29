import 'dart:math';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import '../models/interest_result.dart';

class CompoundInterestCalculator {
  /// Calculates compound interest based on principal, rate, and loan/payment dates
  /// 
  /// Parameters:
  /// - principal: Principal amount in currency units
  /// - rate: Annual interest rate as a percentage
  /// - loanDate: Loan distribution date in Nepali calendar (B.S.)
  /// - paymentDate: Payment date in Nepali calendar (B.S.)
  /// 
  /// Returns: InterestResult object containing all calculation results
  static InterestResult calculateCompoundInterest({
    required double principal,
    required double rate,
    required NepaliDateTime loanDate,
    required NepaliDateTime paymentDate,
  }) {
    // Convert Nepali dates (B.S.) to A.D. (Gregorian calendar)
    final loanAD = loanDate.toDateTime();
    final paymentAD = paymentDate.toDateTime();

    // Calculate total days between loan and payment dates
    final totalDays = paymentAD.difference(loanAD).inDays;

    // Convert days to years
    final totalYears = totalDays / 365.0;

    // Apply compound interest formula: A = P * (1 + r/100)^t
    final totalAmount = principal * pow((1 + rate / 100), totalYears);

    // Calculate interest earned
    final interest = totalAmount - principal;

    return InterestResult(
      totalAmount: totalAmount,
      interest: interest,
      totalDays: totalDays,
      totalYears: totalYears,
    );
  }
}
