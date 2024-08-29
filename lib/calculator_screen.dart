import 'package:flutter/material.dart';
import 'package:ios_calculator/button_value.dart';

// Stateful widget for the calculator screen
class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

// Global variables to hold the first number, operator, and second number
String number1 = ''; // Stores the first number
String operand = ''; // Stores the operator (e.g., +, -, *, /)
String number2 = ''; // Stores the second number

class _CalculatorScreenState extends State<CalculatorScreen> {
  @override
  Widget build(BuildContext context) {
    final screenSized = MediaQuery.of(context).size; // Get the screen size
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // Output display area
              Expanded(
                child: SingleChildScrollView(
                  reverse: true, // Scroll to the bottom automatically
                  child: GestureDetector(
                    onDoubleTap: deleteTheCharc,
                    child: Container(
                      alignment: Alignment
                          .bottomRight, // Align output to the bottom-right
                      padding: const EdgeInsets.all(20),
                      child: Text(
                        '$number1$operand$number2'
                                .isEmpty // Display '0' if no input
                            ? '0'
                            : '$number1$operand$number2',
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.end, // Align text to the end
                      ),
                    ),
                  ),
                ),
              ),
              // Button layout using Wrap
              Wrap(
                children: Btn.buttonValues
                    .map(
                      (value) => SizedBox(
                        width: value == Btn.zero // Handle zero button size
                            ? screenSized.width / 2
                            : screenSized.width / 4,
                        height: screenSized.width / 5,
                        child: buildbutton(
                            value), // Create a button for each value
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void deleteTheCharc() {
    setState(() {
      if (number2.isNotEmpty) {
        number2 = number2.substring(0, number2.length - 1);
      } else if (operand.isNotEmpty) {
        operand = '';
      } else if (number1.isNotEmpty) {
        number1 = number1.substring(0, number1.length - 1);
      }
    });
  }

  // Function to handle button tap events
  void onBtnTap(String value) {
    if (value == Btn.clr) {
      clearAll(); // Clear all values if "C" is pressed
      return;
    }

    if (value == Btn.plusOrMinus) {
      toggleSign(); // Toggle sign if "+/-" is pressed
      return;
    }

    if (value == Btn.percent) {
      convertToPercent(); // Convert to percentage if "%" is pressed
      return;
    }

    if (value == Btn.calculate) {
      calculate(); // Perform calculation if "=" is pressed
      return;
    }

    positioningValues(value); // Handle other button presses
  }

  // Function to perform the calculation
  void calculate() {
    // Ensure all required values are available
    if (number1.isEmpty || operand.isEmpty || number2.isEmpty) return;

    final double num1 = double.parse(number1); // Parse first number
    final double num2 = double.parse(number2); // Parse second number

    dynamic result;

    String displayError = "can't divide by 0"; // Prevent division by zero

    // Perform the appropriate operation based on the operator
    switch (operand) {
      case Btn.add:
        result = num1 + num2;
        break;
      case Btn.subtract:
        result = num1 - num2;
        break;
      case Btn.multiply:
        result = num1 * num2;
        break;
      case Btn.divide:
        if (number2 == '0') {
          result = displayError; // Prevent division by zero
        } else {
          result = num1 / num2;
        }
        break;
    }

    // Update the display with the result
    setState(() {
      number1 = '$result';
      // Remove trailing ".0" if present
      if (number1.endsWith('.0')) {
        number1 = number1.substring(0, number1.length - 2);
      }
      operand = '';
      number2 = '';
    });
  }

  // Function to convert the current value to a percentage
  void convertToPercent() {
    if (number1.isNotEmpty && number2.isNotEmpty) {
      calculate(); // Calculate first if both numbers are present
    }
    if (operand.isEmpty) {
      if (number1.isNotEmpty) {
        final number = double.parse(number1);
        setState(() {
          number1 = '${number / 100}'; // Convert first number to percentage
        });
      }
    } else {
      if (number2.isNotEmpty) {
        final number = double.parse(number2);
        setState(() {
          number2 = '${number / 100}'; // Convert second number to percentage
        });
      }
    }
  }

  // Function to toggle the sign of the current value
  void toggleSign() {
    setState(() {
      if (operand.isEmpty && number1.isNotEmpty) {
        // Toggle sign of the first number
        number1 = number1.startsWith('-') ? number1.substring(1) : '-$number1';
      } else if (number2.isNotEmpty) {
        // Toggle sign of the second number
        number2 = number2.startsWith('-') ? number2.substring(1) : '-$number2';
      }
    });
  }

  // Function to clear all inputs
  void clearAll() {
    setState(() {
      number1 = '';
      operand = '';
      number2 = '';
    });
  }

  // Function to handle number and operator positioning
  void positioningValues(String value) {
    // If the value is an operator (not a number or dot)
    if (value != Btn.dot && int.tryParse(value) == null) {
      if (operand.isNotEmpty && number2.isNotEmpty) {
        calculate(); // Calculate if there's already an operation pending
        operand = value; // Set new operator
      } else {
        operand = value; // Set operator
      }
    } else {
      if (operand.isEmpty) {
        if (value == Btn.dot && number1.contains(Btn.dot)) {
          return; // Prevent multiple dots
        }
        number1 += value; // Append value to the first number
      } else {
        if (value == Btn.dot && number2.contains(Btn.dot)) {
          return; // Prevent multiple dots
        }
        number2 += value; // Append value to the second number
      }
    }

    setState(() {}); // Update UI
  }

  // Function to build a button with the given value
  Widget buildbutton(String value) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Material(
        color: [Btn.clr, Btn.plusOrMinus, Btn.percent].contains(value)
            ? Colors.grey
            : [Btn.divide, Btn.multiply, Btn.subtract, Btn.add, Btn.calculate]
                    .contains(value)
                ? Colors.orange
                : const Color.fromARGB(255, 49, 44, 44), // Set button color
        clipBehavior: Clip.hardEdge,
        shape: value == Btn.zero
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(100),
                borderSide: const BorderSide(color: Colors.black),
              ) // Shape for zero button
            : const CircleBorder(
                side: BorderSide(color: Colors.black),
              ), // Shape for other buttons
        child: InkWell(
          onTap: () => onBtnTap(value), // Handle tap event
          child: Center(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 30,
                color: [Btn.clr, Btn.plusOrMinus, Btn.percent].contains(value)
                    ? Colors.black
                    : Colors.white, // Set text color
              ),
            ),
          ),
        ),
      ),
    );
  }
}
