import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shopping_list/data/categories.dart';
import 'package:http/http.dart' as http;
import 'package:shopping_list/data/dummy_items.dart';
import 'package:shopping_list/models/category.dart';
import 'package:shopping_list/models/grocery_items.dart';

class NewItem extends StatefulWidget {
  const NewItem({super.key});
  // final Category
  @override
  State<NewItem> createState() {
    return _NewItemState();
  }
}

class _NewItemState extends State<NewItem> {
  //use this GlobalKey to access methods inside the class
  final _formKey = GlobalKey<FormState>();

//variable for saving all the values from the form

  var _enteredName = '';
  var _enteredQuantity = 1;
  var _selectCategory = categories[Categories.fruit]!;

  //used to set up the loading state
  var _isSending = false;

  void _saveItem() async {
    //checks all validation within an element.
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isSending = true;
      });

      //use this code when working with databases.

      final url = Uri.https(
          'test2-59037-default-rtdb.europe-west1.firebasedatabase.app',
          'shopping-list.json');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          //wrapping our values in a map
        },
        body: json.encode({
          'name': _enteredName,
          'quantity': _enteredQuantity,
          'category': _selectCategory.title,
        }),
      );
      //decoded the data from database to extract the id
      final Map<String, dynamic> resData = json.decode(response.body);
      print(response.body);
      print(response.statusCode);
      //check if widget is not part of the screen anymore
      if (!context.mounted) {
        return;
      }
      Navigator.of(context).pop(GroceryItem(
        id: resData['name'],
        name: _enteredName,
        quantity: _enteredQuantity,
        category: _selectCategory,
      )); //up to here

      //takes you back to the previous screen to get the GroceryItem List Map object
      //which is   'final List<GroceryItem> _groceryItems' = [];
      /*  Navigator.of(context).pop(
        GroceryItem(
          id: DateTime.now.toString(),
          name: _enteredName,
          quantity: _enteredQuantity,
          category: _selectCategory,
        ),
      );*/
      //   print(_enteredName);
      //  print(_enteredQuantity);
      //  print(_selectCategory);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add a new item')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Form(
          //******this key now has access to objects as is crucial
          key: _formKey,
          child: Column(children: [
            TextFormField(
              maxLength: 50,
              decoration: const InputDecoration(
                label: Text('Name'),
              ),
              validator: (value) {
                //check if name is at least 2 characters
                if (value == null ||
                    value.isEmpty ||
                    value.trim().length <= 1 ||
                    value.trim().length > 50) {
                  return "Must be between 1 and 50 characters long";
                }
                return null;
              },
              onSaved: (value) {
                _enteredName = value!;
              },
            ),
            Row(
              //makes sure the fields in the row are lined up properly.
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    initialValue: _enteredQuantity.toString(),
                    validator: (value) {
                      if (value == null ||
                          value.isEmpty ||
                          //checks if its an actual number entered
                          int.tryParse(value) == null
                          //check user doesn't enter a negative number
                          ||
                          int.tryParse(value)! <= 0) {
                        return "Must be a valid positive number";
                      }
                      return null;
                    },
                    onSaved: (value) {
                      //parse throws error if it fails to convert from number to String
                      _enteredQuantity = int.parse(value!);
                    },
                    decoration: const InputDecoration(label: Text('Quantity')),
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                  child: DropdownButtonFormField(
                    //initialize value to 'vegetables' or what you choose from
                    //mapped list or enum
                    value: _selectCategory,
                    items: [
                      for (final category in categories.entries)
                        DropdownMenuItem
                            //want to have two items next to each other
                            // so put them in a row
                            (
                          //uses the map value from the data file of Categories
                          value: category.value,
                          child: Row(
                            children: [
                              Container(
                                width: 16,
                                height: 16,
                                color: category.value.color,
                              ),
                              const SizedBox(
                                width: 6,
                              ),
                              Text(category.value.title),
                            ],
                          ),
                        )
                    ],
                    //don't need onSave because we are already storing updated value

                    onChanged: (value) {
                      //changing the ui of screen so call setState
                      setState(() {
                        _selectCategory = value!;
                      });
                    },
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  //disable the reset button if
                  onPressed: _isSending
                      ? null
                      : () {
                          //clears the form.
                          _formKey.currentState!.reset();
                        },
                  child: const Text('Reset'),
                ),
                ElevatedButton(
                  //disable add item buttons if we are saving
                  onPressed: _isSending ? null : _saveItem,
                  //while we are saving showing the loading circle
                  child: _isSending
                      ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(),
                        )
                      //if not saving the fallback text
                      : const Text('Add item'),
                ),
              ],
            )
          ]),
        ),
      ),
    );
  }
}
