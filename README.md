# चक्रीय ब्याज गणक (Compound Interest Calculator)

A Flutter mobile application that calculates compound interest using Nepali (B.S.) calendar dates.

## Features

✓ **Nepali Date Picker** - Select loan distribution and payment dates in Nepali (B.S.) calendar
✓ **Automatic A.D. Conversion** - Converts Nepali dates to A.D. (Gregorian calendar) automatically
✓ **Compound Interest Calculation** - Uses the formula: A = P × (1 + r/100)^t
✓ **Clean UI** - Nepali language labels and intuitive user interface
✓ **Input Validation** - Comprehensive validation for all input fields

## Project Structure

```
compound_interest_app/
├── lib/
│   ├── main.dart                 # App entry point
│   ├── screens/
│   │   └── home_screen.dart      # Main calculator screen
│   ├── widgets/
│   │   ├── input_field.dart      # Custom text input widget
│   │   └── result_card.dart      # Results display card
│   ├── utils/
│   │   └── calculator.dart       # Compound interest calculation logic
│   └── models/
│       └── interest_result.dart  # Data model for calculation results
├── assets/
│   └── fonts/                    # Nepali fonts (if needed)
├── pubspec.yaml                  # Dependencies and project configuration
└── README.md
```

## Dependencies

- `flutter`: Flutter SDK
- `nepali_date_picker: ^5.3.0` - Nepali date picker widget
- `nepali_utils: ^3.0.8` - Nepali date/time utilities
- `intl: ^0.19.0` - Internationalization support
- `cupertino_icons: ^1.0.2` - iOS-style icons

## User Input

The app takes the following inputs:

1. **मूलधन (Principal Amount)** - The initial loan amount
2. **ब्याजदर % प्रति वर्ष (Interest Rate per year)** - Annual interest rate as percentage
3. **रकम लिएको मिति (Loan Distribution Date)** - Date in Nepali B.S. calendar
4. **रकम बुझाउने मिति (Payment Date)** - Date in Nepali B.S. calendar

## Calculation Logic

### Date Conversion
- Nepali B.S. dates are converted to A.D. (Gregorian calendar)
- Uses `toDateTime()` method from `nepali_utils` package

### Time Calculation
- Calculates total days between loan and payment dates
- Converts days to years: `years = totalDays / 365`

### Compound Interest Formula
```
A = P × (1 + r/100)^t
Interest = A - P
```

Where:
- A = Final amount (total amount to be paid)
- P = Principal (initial loan amount)
- r = Annual interest rate (%)
- t = Time period in years

## Validation

The app validates:
- ✓ All fields are not empty
- ✓ Principal and Rate are valid numbers
- ✓ Principal and Rate are positive values
- ✓ Both dates are selected
- ✓ Payment date is after loan date

## UI Components

### Home Screen
- **AppBar**: Title "चक्रीय ब्याज निकाल्नुहोस्" (Calculate Compound Interest)
- **Input Fields**: For principal and interest rate
- **Date Pickers**: Two Nepali date picker buttons
- **Buttons**: "गणना गर्नुहोस्" (Calculate) and "रिसेट गर्नुहोस्" (Reset)
- **Result Card**: Displays calculation results in Nepali

### Result Card Displays
- जम्मा तिर्नुपर्ने रकम (Total Amount to be Paid)
- कुल ब्याज (Total Interest Earned)
- कुल दिन (Total Days)
- कुल वर्ष (Total Years)

## Building the App

### Development Build
```bash
flutter run
```

### Release APK
```bash
flutter build apk --release
```

The APK will be available at:
```
build/app/outputs/flutter-apk/app-release.apk
```

## Example Usage

1. Enter Principal: `10,000`
2. Enter Interest Rate: `12.5`
3. Select Loan Date: `2079/01/01` (B.S.)
4. Select Payment Date: `2081/12/30` (B.S.)
5. Click "गणना गर्नुहोस्" (Calculate)
6. View results in the Result Card

## Technical Details

- **Language**: Dart with Flutter framework
- **Target**: Android & iOS
- **Minimum SDK**: Android 5.0 (API 21)
- **Architecture**: Modular with separated concerns (screens, widgets, utils, models)

## Error Handling

The app shows SnackBar notifications for:
- Invalid input fields
- Missing date selections
- Invalid date ranges
- Successful calculations

## Future Enhancements

- Add support for saving calculation history
- Implement different compounding frequencies (monthly, quarterly, etc.)
- Add chart visualization for compound interest growth
- Support for multiple currencies
- Dark theme support
- Offline functionality

## License

This project is open source and available for educational purposes.
