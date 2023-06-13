import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyAlertBox extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSave;
  final VoidCallback onCancel;
  final String hintText;

  const MyAlertBox({
    super.key,
    required this.controller,
    required this.onSave,
    required this.onCancel,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        "Change your habit's name",
        style: GoogleFonts.montserrat(color: Colors.white, fontSize: 14),
      ),
      content: TextField(
        controller: controller,
        style: GoogleFonts.montserrat(color: Colors.white),
        decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: hintText,
          hintStyle:
              GoogleFonts.montserrat(color: Colors.grey[500], fontSize: 14),
        ),
      ),
      backgroundColor: Colors.grey[800],
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: [
        MaterialButton(
          color: Colors.black,
          onPressed: onSave,
          child: Text(
            "Save",
            style: GoogleFonts.montserrat(color: Colors.white, fontSize: 14),
          ),
        ),
        MaterialButton(
          color: Colors.black,
          onPressed: onCancel,
          child: Text("Cancel",
              style: GoogleFonts.montserrat(color: Colors.white, fontSize: 14)),
        ),
      ],
    );
  }
}
