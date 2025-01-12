import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart'; // Import the fluttertoast package

class ConfirmationDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  final String successMessage;

  const ConfirmationDialog({
    Key? key,
    required this.title,
    required this.content,
    required this.onConfirm,
    required this.onCancel,
    required this.successMessage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        // Cancel button
        TextButton(
          onPressed: () {
            onCancel(); // Call the cancel action
            Navigator.of(context).pop(); // Close the dialog
          },
          child: const Text("Otkaži"),
        ),
        // Confirm button
        TextButton(
          onPressed: () {
            onConfirm(); // Call the confirm action
            Navigator.of(context).pop(); // Close the dialog

            // Show toast message after confirmation

            Fluttertoast.showToast(
              msg: successMessage,
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.CENTER,
              timeInSecForIosWeb: 3,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0,
            );
          },
          child: const Text("Potvrdi"),
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.black,
            backgroundColor:
                Colors.white, // Boja teksta i ikone pri interakciji
            side: const BorderSide(
              color: Colors.blueGrey, // Boja okvira
              width: 2, // Debljina okvira
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8), // Zaobljeni uglovi
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0, // Horizontalno unutrašnje rastojanje
              vertical: 12.0, // Vertikalno unutrašnje rastojanje
            ),
            elevation: 2, // Lagano izdizanje dugmeta
          ),
        ),
      ],
    );
  }
}
