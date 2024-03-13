import 'package:flutter/material.dart';
import 'package:lgcontollerapp/ssh/ssh.dart';

class AlertWidget extends StatelessWidget {
  final SSH ssh = SSH();
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        _showWarningDialog(context);
      },
      child: Text('Click me'),
    );
  }

  void _showWarningDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Warning'),
          content: const Text('Are you sure you want to Reboot?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                // Perform the action when user confirms
                Navigator.of(context).pop(); // Close the dialog
                // Add your logic here for the action
                await ssh.onReboot();
              },
              child: const Text('Proceed'),
            ),
          ],
        );
      },
    );
  }
}
