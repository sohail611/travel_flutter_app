import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_arfa_task_5_sohail_anwar/db/dbhelper.dart';
import 'package:flutter_arfa_task_5_sohail_anwar/screens/expence/exp.dart';
import 'package:flutter_arfa_task_5_sohail_anwar/screens/home_screen.dart';
import 'package:flutter_arfa_task_5_sohail_anwar/screens/main_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddExpenseScreen extends StatefulWidget {
  const AddExpenseScreen({super.key});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  bool isExpense = true;
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _descController = TextEditingController();
  final _amountController = TextEditingController();
  String? _selectedCategory;
  List<String> _imagePaths = [];

  final picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imagePaths.add(pickedFile.path);
      });
    }
  }

  void _saveExpense() async {
    if (_formKey.currentState!.validate()) {
      final expense = {
        "date": _dateController.text,
        "category": _selectedCategory ?? "other",
        "type": isExpense ? "expense" : "income",
        "description": _descController.text,
        "amount": double.tryParse(_amountController.text) ?? 0.0,
        "image": jsonEncode(_imagePaths),
      };

      await DatabaseHelper().insertExpense(expense);

      Fluttertoast.showToast(
        msg: "Expense saved!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const ReceiptScreen())
      );
      // Navigator.pop(context, true); // Close screen after saving
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Add New Expense", style: TextStyle(fontSize: 20)),
        // leading: const BackButton(color: Colors.white),
        actions: const [
          // Padding(
          //   padding: EdgeInsets.all(12),
          //   child: Icon(Icons.settings),
          // ),
        ],
        backgroundColor: const Color(0xffFEBA01),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              ToggleButtons(
                borderRadius: BorderRadius.circular(8),
                isSelected: [isExpense, !isExpense],
                onPressed: (index) {
                  setState(() {
                    isExpense = index == 0;
                  });
                },
                fillColor: const Color(0xffFEBA01),
                selectedColor: Colors.white,
                color: Colors.black,
                children: const [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Text("Expense"),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30),
                    child: Text("Income"),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _dateController,
                decoration: const InputDecoration(
                  hintText: "dd/MM/yyyy",
                  suffixIcon: Icon(Icons.calendar_month),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.datetime,
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return "Enter date";
                  } else {
                    try {
                      DateFormat("dd/MM/yyyy").parseStrict(val);
                      return null;
                    } catch (e) {
                      return "Enter a valid date (dd/MM/yyyy)";
                    }
                  }
                },
                onTap: () async {
                  FocusScope.of(context).requestFocus(FocusNode()); // Prevent keyboard
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    _dateController.text =
                        DateFormat("dd/MM/yyyy").format(pickedDate);
                  }
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(border: OutlineInputBorder()),
                hint: const Text("Select Category"),
                value: _selectedCategory,
                items: const [
                  DropdownMenuItem(value: "bill", child: Text("Bill & Utility")),
                  DropdownMenuItem(value: "food", child: Text("Food")),
                  DropdownMenuItem(value: "travel", child: Text("Travel")),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                validator: (val) =>
                val == null ? "Please select a category" : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descController,
                decoration: const InputDecoration(
                  hintText: "Description (Optional)",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: "Total",
                  border: OutlineInputBorder(),
                ),
                validator: (val) =>
                val == null || val.isEmpty ? "Enter amount" : null,
              ),
              const SizedBox(height: 16),
              const Text("Expense receipt images"),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  ..._imagePaths.map(
                        (path) => Stack(
                      children: [
                        Image.file(
                          File(path),
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          right: 0,
                          top: 0,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _imagePaths.remove(path);
                              });
                            },
                            child: const CircleAvatar(
                              radius: 12,
                              backgroundColor: Colors.red,
                              child: Icon(Icons.close,
                                  size: 16, color: Colors.white),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black26),
                      ),
                      child: const Icon(Icons.add, color: Colors.deepPurple),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) =>  NavBar())),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffEBA01),
                      ),
                      child: const Text(
                        "Cancel",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _saveExpense,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xffFEBA01),
                      ),
                      child: const Text(
                        "Save",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
