import 'package:flutter/material.dart';

class AddCategoryScreen extends StatelessWidget {
  final List<String> categories;

  const AddCategoryScreen(this.categories, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text('Add Category'),
      ),
      body: AddCategoryForm(categories: categories),
    );
  }
}

class AddCategoryForm extends StatefulWidget {
  final List<String> categories;

  const AddCategoryForm({super.key, required this.categories});

  @override
  _AddCategoryFormState createState() => _AddCategoryFormState();
}

class _AddCategoryFormState extends State<AddCategoryForm> {
  final TextEditingController _categoryController = TextEditingController();

  void _addCategory() {
    String newCategory = _categoryController.text.trim();

    if (newCategory.isNotEmpty &&
        !newCategory.contains(RegExp(r'^\s*$')) &&
        !widget.categories.contains(newCategory)) {
      Navigator.pop(context, newCategory);
    } else {
      showDialog(context: context, builder: (BuildContext context) => AlertDialog(
        backgroundColor: Colors.grey[200],
        title: const Text('Error in Category Name!',style: TextStyle(color: Colors.black),),
        content: const Text('The Category Name Cannot be Empty and Must be Unique!',style: TextStyle(color: Colors.black),),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();},
            style: TextButton.styleFrom(backgroundColor: Colors.teal),
            child: const Center(
              child: Text('ok',
                  style:TextStyle(color: Colors.white)),
            ),
          ),
        ],
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _categoryController,
            decoration: const InputDecoration(labelText: 'Category Name'),
          ),
          const SizedBox(height: 20),
          Center(
            child: ElevatedButton(
              onPressed: _addCategory,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              child: const Text('Add Category',style: TextStyle(color: Colors.white),),
            ),
          ),
        ],
      ),
    );
  }
}
