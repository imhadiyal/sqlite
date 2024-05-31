import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:sqlite/controller/data_controller.dart';

import '../modals/user_modal.dart';

class Homepage extends StatelessWidget {
  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {
    Logger logger = Logger();
    DbController mutable = Provider.of<DbController>(context);
    DbController unmutable = Provider.of<DbController>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text("SQL"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          logger.i('Add Button Pressed');
          showDialog(
            context: context,
            builder: (BuildContext context) {
              logger.i('Dialog Opened');
              User user = User('name', mutable.allData.length + 1);
              return AlertDialog(
                title: const Text("Add Student"),
                actions: [
                  TextField(
                    onChanged: (name) {
                      user.name = name;
                    },
                  ),
                  TextButton.icon(
                    onPressed: () {
                      unmutable.insertData(user: user).then(
                        (value) {
                          logger.i('Button pressed & ${user.name} added !!');
                          Navigator.of(context).pop();
                        },
                      ).onError(
                        (error, stackTrace) {
                          logger.e('ButtonPressed & Error: $error');
                          Navigator.of(context).pop();
                        },
                      );
                    },
                    label: const Text("Add"),
                    icon: const Icon(Icons.add),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
      body: Center(
        child: (mutable.allData.isEmpty)
            ? const CircularProgressIndicator()
            : ListView.builder(
                itemCount: mutable.allData.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(mutable.allData[index].name),
                  );
                },
              ),
      ),
    );
  }
}
