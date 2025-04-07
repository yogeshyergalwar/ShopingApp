import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:untitled4/data/cateory.dart';
import '../model/grocery_items.dart';
import 'new_list.dart';

class GroceryList extends StatefulWidget {
  GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  List<GroceryItem> _getRegistrationData = [];
  bool  _isloading=true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadfinal();

  }

  void _loadfinal() async {
    final url = Uri.https(
        'shopingapp-ed73e-default-rtdb.firebaseio.com', 'shoping-list.json');

    final res = await http.get(url);
    if(res.body=='null'){
      setState(() {
        _isloading=false;
        return;
      });
    }
    final Map<String,dynamic> _loadlist = json.decode(res.body);
    final List<GroceryItem> _loaditem = [];
    for (final item in _loadlist.entries) {
      final category = categories.entries
          .firstWhere(
              (catitem) => catitem.value.title == item.value['category'])
          .value;
      _loaditem.add(GroceryItem(
          id: item.key,
          name: item.value['name'],
          quantity: item.value['quantity'],
          category: category));

    }
    setState(() {
      _getRegistrationData = _loaditem;
      _isloading=false;
    });
    print(res.body);
  }

  void newpage() async {
    await Navigator.of(context).push<GroceryItem>(MaterialPageRoute(
      builder: (ctx) => NewItem(),
    ));
    _loadfinal();
  }

  void _onremove(GroceryItem item)async {
   final index= _getRegistrationData.indexOf(item);
    setState(() {
      _getRegistrationData.remove(item);
    });
    final url = Uri.https(
        'shopingapp-ed73e-default-rtdb.firebaseio.com', 'shoping-list/${item.id}.json');

   final res= await http.delete(url);
   if( res.statusCode>=400){
     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Remove Failed')));
     setState(() {
       _getRegistrationData.insert(index,item);
     });
   }
  }

  @override
  Widget build(BuildContext context) {
    Widget conten = Center(
      child: Text('No Data Added'),
    );
    if(_isloading){
      conten=Center(child: CircularProgressIndicator(),);
    }
    if (_getRegistrationData.isNotEmpty) {
      conten = ListView.builder(
        itemCount: _getRegistrationData.length,
        itemBuilder: (ctx, index) => Dismissible(
          onDismissed: (direction) => _onremove(_getRegistrationData[index]),

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
        body: conten);
  }
}
