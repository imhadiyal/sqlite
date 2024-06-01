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
    User user = User.copy();
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
              return AlertDialog(
                title: const Text("Add Student"),
                actions: [
                  TextField(
                    onChanged: (name) {
                      user.name = name;
                    },
                  ),
                  TextField(
                    onChanged: (email) {
                      user.email = email;
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
                    subtitle: Text(mutable.allData[index].email),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Update data"),
                                  content: Column(
                                    children: [
                                      TextField(
                                        onChanged: (val) {
                                          user.name = val;
                                        },
                                      ),
                                      TextButton.icon(
                                        onPressed: () {
                                          unmutable.updateData(user: user).then(
                                            (value) {
                                              logger.i(
                                                  'Button pressed & ${user.name} updated !!');
                                              Navigator.of(context).pop();
                                            },
                                          ).onError(
                                            (error, stackTrace) {
                                              logger.e(
                                                error.toString(),
                                              );
                                            },
                                          );
                                        },
                                        label: const Text("Update"),
                                        icon: const Icon(Icons.update),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          icon: const Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () {
                            mutable.deleteData(user: user).then(
                              (value) {
                                logger.i(
                                    'Button pressed & ${user.name} deleted !!');
                              },
                            ).onError(
                              (error, stackTrace) {
                                logger.e(error.toString());
                              },
                            );
                          },
                          icon: const Icon(Icons.delete),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}
