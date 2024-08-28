import 'package:flutter/material.dart';
import 'package:ios_calculator/button_value.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

String number1 = ''; // for dot and zero to 9 values
String operand = ''; // for operators
String number2 = ''; //for dot and zero to 9

class _CalculatorScreenState extends State<CalculatorScreen> {
  @override
  Widget build(BuildContext context) {
    final screenSized = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            //output
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Container(
                  alignment: Alignment.bottomRight,
                  padding: EdgeInsets.all(20),
                  child: Text(
                    '$number1$operand$number2'.isEmpty
                        ? '0'
                        : '$number1$operand$number2',
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
            ),
            //button
            Wrap(
              children: Btn.buttonValues
                  .map(
                    (value) => SizedBox(
                      width: value == Btn.zero
                          ? screenSized.width / 2
                          : screenSized.width / 4,
                      height: screenSized.width / 5,
                      child: buildbutton(value),
                    ),
                  )
                  .toList(),
            )
          ],
        ),
      ),
    );
  }

  void onBtnTap(String value) {
    //Check if the value is not a number
    if (value != Btn.dot && int.tryParse(value) == null) {
      //Checks if the values needed for calculation to take place
      // is intact
      if (operand.isNotEmpty && number2.isNotEmpty) {
        //calculatate before assigning the value to operand
        //TODO
      }

      operand += value;
    }

    //ensures that where there is not dot or operand,
    //user can continously add more values to number1
    //however, if an operand is added, user can no
    //longer add value to number1

    else if (number1.isEmpty || operand.isEmpty) {
      //Ensures that dot is only added to a value once
      if (value == Btn.dot && number1.contains(Btn.dot)) return;

      //allows user to assign '0.' to number1 just by pressing '.' button
      if (value == Btn.dot && (number1.isEmpty || number1.contains(Btn.dot))) {
        value = '0.';
      }

      //now that we are done with various conditions of number1,
      //we can now assign value to it

      number1 += value;
    }

    //now we handle number2

    else if (number2.isEmpty || operand.isNotEmpty) {
      //Ensures that dot is only added to a value once
      if (value == Btn.dot && number2.contains(Btn.dot)) return;

      //allows user to assign '0.' to number1 just by pressing '.' button
      if (value == Btn.dot && (number2.isEmpty || number2.contains(Btn.dot))) {
        value = '0.';
      }

      //now that we are done with various conditions of number1,
      //we can now assign value to it

      number2 += value;
    }

    setState(() {});
  }

  Widget buildbutton(value) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Material(
        color: [Btn.clr, Btn.plusOrMinus, Btn.percent].contains(value)
            ? Colors.grey
            : [Btn.divide, Btn.multiply, Btn.subtract, Btn.add, Btn.calculate]
                    .contains(value)
                ? Colors.orange
                : const Color.fromARGB(255, 49, 44, 44),
        clipBehavior: Clip.hardEdge,
        shape: value == Btn.zero
            ? OutlineInputBorder(
                borderRadius: BorderRadius.circular(100),
                borderSide: BorderSide(color: Colors.black),
              )
            : CircleBorder(
                side: BorderSide(color: Colors.black),
              ),
        child: InkWell(
          onTap: () => onBtnTap(value),
          child: Center(
            child: Text(
              value,
              style: TextStyle(
                  fontSize: 30,
                  color: [Btn.clr, Btn.plusOrMinus, Btn.percent].contains(value)
                      ? Colors.black
                      : Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
