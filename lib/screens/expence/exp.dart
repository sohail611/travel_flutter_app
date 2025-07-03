import 'dart:convert';
import 'dart:io';
import 'package:flutter_arfa_task_5_sohail_anwar/screens/expence/video.dart';
import 'package:path/path.dart';
import 'package:flutter_arfa_task_5_sohail_anwar/db/dbhelper.dart';
import 'package:flutter/material.dart';
import 'EditReceiptScreen.dart';
// import 'edit_receipt_screen.dart'; // Add your EditReceiptScreen import here

class ReceiptScreen extends StatefulWidget {
  const ReceiptScreen({super.key});

  @override
  State<ReceiptScreen> createState() => _ReceiptScreenState();
}

class _ReceiptScreenState extends State<ReceiptScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _receipts = [];
  Map<String, dynamic>? _selectedReceipt;

  @override
  void initState() {
    super.initState();
    _loadReceipts();
  }

  void _loadReceipts() async {
    final db = DatabaseHelper();
    final receipts = await db.getAllExpenses();
    setState(() {
      _receipts = receipts;
    });
  }

  void _editReceipt(Map<String, dynamic> receipt) async {
    // Uncomment after adding EditReceiptScreen
    final result = await Navigator.push(
      this.context,
      MaterialPageRoute(
        builder: (context) => EditReceiptScreen(receipt: receipt),
      ),
    );

    if (result == true) {
      _loadReceipts();
    }
  }

  void _deleteReceipt(int id) async {
    final shouldDelete = await showDialog<bool>(
      context: this.context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Deletion"),
        content: const Text("Are you sure you want to delete this receipt?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (shouldDelete == true) {
      final db = DatabaseHelper();
      await db.deleteAllExpenses(id);
      _loadReceipts();
    }
  }

  void _searchReceipts(String query) {
    final db = DatabaseHelper();
    db.getAllExpenses().then((receipts) {
      setState(() {
        _receipts = receipts
            .where((receipt) => receipt["description"]
            .toLowerCase()
            .contains(query.toLowerCase()))
            .toList();
      });
    });
  }

  void _showReceiptDialog(Map<String, dynamic> receipt) {
    showDialog(
      context: this.context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Container(
            constraints: const BoxConstraints(maxHeight: 500),
            padding: const EdgeInsets.all(26),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("Receipt Details", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                Text("Date: ${receipt['date']}"),
                Text("Category: ${receipt['category']}"),
                Text("Type: ${receipt['type']}"),
                Text("Amount: \$${receipt['amount']}"),
                const SizedBox(height: 10),
                Text("Description:\n${receipt['description']}"),
                const SizedBox(height: 10),
                if (receipt["image"] != null && receipt["image"].isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Attached Images:"),
                      const SizedBox(height: 10),
                      ...List<String>.from(jsonDecode(receipt["image"])).map(
                            (imgPath) => Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: Image.file(
                            File(imgPath),
                            height: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Close"),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Receipt", style: TextStyle(fontSize: 20)),
        // leading: const BackButton(color: Colors.white),
        actions: const [
          // Padding(
          //   padding: EdgeInsets.all(16),
          //   child: Icon(Icons.settings),
          // ),
        ],
        backgroundColor: const Color(0xffFEBA01),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: TextField(
                controller: _searchController,
                onChanged: _searchReceipts,
                decoration: InputDecoration(
                  hintText: "Search...",
                  suffixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _receipts.length,
                itemBuilder: (context, index) {
                  final receipt = _receipts[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      onTap: () => _showReceiptDialog(receipt),
                      leading: const Icon(Icons.receipt_long, color: Color(0xffFEBA01)),
                      title: Text(receipt["category"]),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(receipt["date"], style: const TextStyle(fontWeight: FontWeight.bold)),
                          Text(receipt["description"] ?? "No description"),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.greenAccent),
                            onPressed: () => _editReceipt(receipt),
                          ),
                          IconButton(
                            onPressed: () => _deleteReceipt(receipt["id"]),
                            icon: const Icon(Icons.delete, color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Expanded(
                      child:ElevatedButton(
                        style:  ElevatedButton.styleFrom(backgroundColor: const Color(0xffFEBA01)),
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) =>  AddExpenseScreen())),
                        child: Text("Add New Expence"
                          ,style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
                        ),
                      ),
                  ),
                  // Expanded(
                  //   child: ElevatedButton(
                  //     style: ElevatedButton.styleFrom(backgroundColor: const Color(0xffFEBA01)),
                  //     onPressed: () {},
                  //     child: const Text(
                  //       "EDIT",
                  //       style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  //     ),
                  //   ),
                  // ),
                  // const SizedBox(width: 10),
                  // Expanded(
                  //   child: ElevatedButton(
                  //     style: ElevatedButton.styleFrom(backgroundColor: const Color(0xffFEBA01)),
                  //     onPressed: () {},
                  //     child: const Text(
                  //       "DELETE",
                  //       style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
