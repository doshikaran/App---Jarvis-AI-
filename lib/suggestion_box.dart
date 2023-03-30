import 'package:flutter/material.dart';
import 'package:jarvis/colors.dart';

class SuggestionBox extends StatelessWidget {
  final Color color;
  final String headerText;
  final String desc;

  const SuggestionBox(
      {super.key,
      required this.color,
      required this.headerText,
      required this.desc});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 35, vertical: 10),
      decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.all(Radius.circular(15))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Column(children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              headerText,
              style: const TextStyle(
                  fontFamily: "Cera Pro",
                  color: Pallete.mainFontColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            desc,
            style: const TextStyle(
                fontFamily: "Cera Pro",
                color: Pallete.mainFontColor,
                fontSize: 15),
          )
        ]),
      ),
    );
  }
}
