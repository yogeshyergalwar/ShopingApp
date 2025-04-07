import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:untitled4/model/category.dart';

import '../data/cateory.dart';
import '../model/grocery_items.dart';
import 'package:http/http.dart' as http;

class NewItem extends StatefulWidget {
  const NewItem({super.key});

  @override
  State<NewItem> createState() {
    return _NewItemState();
  }
}

class _NewItemState extends State<NewItem> {
  bool _isSending=false;
  @override
  Widget build(BuildContext context) {
    final _FormKey = GlobalKey<FormState>();
    var enterName = '';
    int? enterQuantity = 1;
    var _selectedDrop = categories[Categories.vegetables];
    void _saveData() {
      if (_FormKey.currentState!.validate()) {
        _FormKey.currentState!.save();
        setState(() {
          _isSending=true;
        });
        final url = Uri.https('shopingapp-ed73e-default-rtdb.firebaseio.com',
            'shoping-list.json');
        http.post(url,
            headers: {
              'Content-Type': 'application/json',
            },
            body: json.encode({
              'name': enterName.toString(),
              'quantity': enterQuantity!,
              'category': _selectedDrop!.title,
            }));


      Navigator.of(context).pop();
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add a new item'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
            key: _FormKey,
            child: Column(children: [
              TextFormField(
                maxLength: 50,
                decoration: const InputDecoration(
                  label: Text('Name'),
                ),
                validator: (value) {
                  if (value == null ||
                      value.isEmpty ||
                      value.trim().length <= 1 ||
                      value.trim().length > 50) {
                    return 'Must be between 1 and 50 characters.';
                  }
                  return null;
                },
                onSaved: (value) {
                  enterName = value!;
                },
              ), // instead of TextField()
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        label: Text('Quantity'),
                      ),
                      initialValue: enterQuantity.toString(),
                      validator: (value) {
                        if (value == null ||
                            value.isEmpty ||
                            int.tryParse(value)! <= 0 ||
                            int.tryParse(value)! == null) {
                          return 'Must be positive number.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        enterQuantity = int.tryParse(value!);
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: DropdownButtonFormField(
                      value: _selectedDrop,
                      items: [
                        for (final category in categories.entries)
                          DropdownMenuItem(
                            value: category.value,
                            child: Row(
                              children: [
                                Container(
                                  width: 16,
                                  height: 16,
                                  color: category.value.color,
                                ),
                                const SizedBox(width: 6),
                                Text(category.value.title),
                              ],
                            ),
                          ),
                      ],
                      onChanged: (value) {
                        _selectedDrop = value;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed:_isSending? null: () {
                      _FormKey.currentState!.reset();
                    },
                    child: _isSending?  const Center(child: CircularProgressIndicator(),
                  ): Text('Reset'),),
                  ElevatedButton(
                    onPressed:_isSending? null: () {
                      _saveData();
                    },
                    child: _isSending?  const Center(child: CircularProgressIndicator(),
                    ): Text('Add Item'),
                  )
                ],
              ),
            ])),
      ),
    );
  }
}
