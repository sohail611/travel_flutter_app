import 'package:flutter/material.dart';

import '../../db/dbhelper.dart';

class EditReceiptScreen extends StatefulWidget {
  final Map<String, dynamic> receipt;

  const EditReceiptScreen({super.key, required this.receipt});

  @override
  State<EditReceiptScreen> createState() => _EditReceiptScreenState();
}

class _EditReceiptScreenState extends State<EditReceiptScreen> {
  late TextEditingController _categoryController;
  late TextEditingController _descriptionController;
  late TextEditingController _amountController;
  late TextEditingController _dateController;

  @override
  void initState() {
    super.initState();
    _categoryController = TextEditingController(text: widget.receipt['category']);
    _descriptionController = TextEditingController(text: widget.receipt['description']);
    _amountController = TextEditingController(text: widget.receipt['amount'].toString());
    _dateController = TextEditingController(text: widget.receipt['date']);
  }

  @override
  void dispose() {
    _categoryController.dispose();
    _descriptionController.dispose();
    _amountController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void _saveChanges() async {
    final db = DatabaseHelper();
    await db.updateExpense(widget.receipt['id'], {
      'category': _categoryController.text,
      'description': _descriptionController.text,
      'amount': double.tryParse(_amountController.text) ?? 0,
      'date': _dateController.text,
      'type': widget.receipt['type'],  // You can also make this editable
      'image': widget.receipt['image'], // Or update if needed
    });

    Navigator.pop(context, true);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Receipt"),
        backgroundColor: const Color(0xffFEBA01),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: _categoryController,
              decoration: const InputDecoration(labelText: "Category"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: "Description"),
              maxLines: 3,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(labelText: "Amount"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _dateController,
              decoration: const InputDecoration(labelText: "Date"),
              readOnly: true,
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.tryParse(widget.receipt['date']) ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  _dateController.text = picked.toIso8601String().split('T').first;
                }
              },
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _saveChanges,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffFEBA01),
              ),
              child: const Text("Save", style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
