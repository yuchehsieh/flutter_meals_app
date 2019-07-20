import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:meals_app/models/meal.dart';
import 'package:meals_app/widgets/category_item.dart';

import '../dummy_data.dart';

class CategoriesScreen extends StatefulWidget {
  final List<Meal> availableMeal;

  CategoriesScreen(this.availableMeal);

  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  DateTime _selectedDate;

  // Future _showCupertinoAlertDialog({BuildContext context, Widget child}) async {
  //   final dynamic result = await showCupertinoModalPopup<String>(
  //     context: context,
  //     builder: (BuildContext context) => child,
  //   );
  // }

  void _showCupertinoActionSheet(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoActionSheet(
          title: Text('Some Actions'),
          cancelButton: CupertinoActionSheetAction(
            child: Text('Cancel!!'),
            onPressed: () {
              Navigator.pop(context, 'cancel');
            },
          ),
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: Text('One - Normal'),
              onPressed: () {
                Navigator.pop(context, 1);
              },
            ),
            CupertinoActionSheetAction(
              child: Text('Two - DefaultAction: true'),
              onPressed: () {
                Navigator.pop(context, 2);
              },
              isDefaultAction: true,
            ),
            CupertinoActionSheetAction(
              child: Text('Three - DestructiveAction: true'),
              onPressed: () {
                Navigator.pop(context, 3);
              },
              isDestructiveAction: true,
            )
          ],
        );
      },
    );
  }

  void _showCupertinoAlertDialog(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text('Do you like her ?'),
          content: Text('Face your heart'),
          actions: <Widget>[
            CupertinoDialogAction(
              isDestructiveAction: false,
              onPressed: () {
                Navigator.pop(context, 0);
              },
              child: Text('Yes'),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () {
                Navigator.pop(context, 1);
              },
              child: Text('No'),
            )
          ],
        );
      },
    );
  }

  void _showCupertinoDatePicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return Container(
          height: 300,
          child: CupertinoDatePicker(
            onDateTimeChanged: (DateTime value) {
              setState(() {
                _selectedDate = value;
              });
            },
            // maximumDate: DateTime.now().add(
            //   Duration(days: 10),
            // ),
            // maximumYear: 2,
            // minimumYear: 2,
            mode: CupertinoDatePickerMode.date,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(
          _selectedDate == null
              ? 'DeliMeal'
              : DateFormat.yMMMd().format(_selectedDate),
        ),
        leading: CupertinoButton(
          child: Icon(CupertinoIcons.collections_solid),
          onPressed: () => _showCupertinoDatePicker(context),
        ),
      ),
      child: SafeArea(
        child: GridView(
          padding: const EdgeInsets.all(25),
          children: DUMMY_CATEGORIES.map((category) {
            return CategoryItem(
                id: category.id,
                title: category.title,
                color: category.color,
                availableMeal: widget.availableMeal);
          }).toList(),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 3 / 2,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
          ),
        ),
      ),
    );
  }
}
