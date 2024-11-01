// delete_dialog.dart

import 'package:flutter/material.dart';

void showDeleteDialog(BuildContext context, Function deleteFunction) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Delete Todo"),
        content: Text("Are you sure you want to delete this todo?"),
        actions: <Widget>[
          TextButton(
            child: Text("Cancel"),
            onPressed: () {
              Navigator.of(context).pop(); // Dismiss the dialog
            },
          ),
          TextButton(
            child: Text("Delete"),
            onPressed: () {
              deleteFunction(); // Execute the delete function
              Navigator.of(context).pop(); // Dismiss the dialog
            },
          ),
        ],
      );
    },
  );
}