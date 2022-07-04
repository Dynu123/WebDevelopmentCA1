import 'package:flutter/material.dart';

class ScreenAddTransaction extends StatelessWidget {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final _typeController = TextEditingController();
  final _dateController = TextEditingController();
  final _noteController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  ScreenAddTransaction({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text("Add new transactions"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: SizedBox(
          width: 400,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    hintText: "Enter title",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Field cannot be empty";
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _amountController,
                  decoration: const InputDecoration(
                    hintText: "Enter amount",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Field cannot be empty";
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _typeController,
                  decoration: const InputDecoration(
                    hintText: "Select transaction type",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Field cannot be empty";
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _dateController,
                  decoration: const InputDecoration(
                    hintText: "Enter date(optional)",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _noteController,
                  decoration: const InputDecoration(
                    hintText: "Enter note (optional)",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: ElevatedButton(
                      onPressed: () {
                        //action
                        if (_formKey.currentState!.validate()) {
                          //go to listing page
                        } else {
                          print("no data");
                        }
                      },
                      child: const Text("Add"),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
