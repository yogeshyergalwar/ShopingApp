import 'package:flutter/material.dart';

import '../data/dummy_data.dart';
import '../model/grocery_items.dart';
import 'new_list.dart';

class GroceryList extends StatefulWidget {
  GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  final List<GroceryItem> _getRegistrationData = [];



  void newpage() async {
    final newList =
        await Navigator.of(context).push<GroceryItem>(MaterialPageRoute(
      builder: (ctx) => NewItem(),
    ));

    if (newList == null) {
      return null;
    }
    setState(() {
      _getRegistrationData.add(newList);
    });
  }
void _onremove(GroceryItem item){
    _getRegistrationData.remove(item);

}
  @override
  Widget build(BuildContext context) {
    Widget conten = Center(
      child: Text('No Data Added'),
    );
    if(_getRegistrationData.isNotEmpty){
      conten=  ListView.builder(
        itemCount: _getRegistrationData.length,
        itemBuilder: (ctx, index) => Dismissible(
          onDismissed: (direction) =>_onremove(_getRegistrationData[index]) ,
       ///   background : Theme.of(context).colorScheme.secondary,
          key: ValueKey(_getRegistrationData[index].id),
          child: ListTile(
            title: Text(_getRegistrationData[index].name),
            leading: Container(
                width: 24,
                height: 24,
                color: _getRegistrationData[index].category.color),
            trailing: Text(
              _getRegistrationData[index].quantity.toString(),
            ),
          ),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Groceries'),
        actions: [
          IconButton(
              onPressed: () {
                newpage();
              },
              icon: Icon(Icons.add))
        ],
      ),
      body:conten
    );
  }
}
