import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:meals_app/dummy_data.dart';

class MealDetailScreen extends StatelessWidget {
  static const routeName = '/meal-detail';

  final String mealId;
  final Function toggleFavoriteMeal;
  final Function isFavoriteMeal;

  MealDetailScreen({
    @required this.mealId,
    this.toggleFavoriteMeal,
    this.isFavoriteMeal,
  });

  Widget buildSectionTitle(
    String titleText,
    BuildContext context,
    double height,
  ) {
    return Container(
      height: height,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        titleText,
        style: Theme.of(context).textTheme.title,
      ),
    );
  }

  Widget buildContainer(
    double height,
    Widget child,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.grey,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      height: height,
      width: 300,
      child: child,
    );
  }

  void showAlertBeforeRemoveItem(BuildContext context) async {
    final String result = await showCupertinoModalPopup(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text('Are you sure to Delete'),
          content: Text('It won\'t recover, make sure to do this'),
          actions: <Widget>[
            CupertinoDialogAction(
              isDestructiveAction: false,
              isDefaultAction: true,
              onPressed: () {
                Navigator.of(context).pop('no');
              },
              child: Text('Let me think!'),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              onPressed: () {
                Navigator.of(context).pop('yes');
              },
              child: Text('Delete'),
            )
          ],
        );
      },
    );
    if (result == 'yes') {
      Navigator.of(context).pop(mealId);
    }
  }

  @override
  Widget build(BuildContext context) {
    // final String mealId = ModalRoute.of(context).settings.arguments;
    final selectedMeal = DUMMY_MEALS.firstWhere((meal) {
      return meal.id == mealId;
    });

    final PreferredSizeWidget appBar = CupertinoNavigationBar(
      middle: Text('Meal Detail - $mealId'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          CupertinoButton(
            child: Icon(
              CupertinoIcons.delete,
              size: 26,
            ),
            onPressed: () {
              showAlertBeforeRemoveItem(context);
            },
          ),
          CupertinoButton(
            child: Icon(
              isFavoriteMeal(mealId)
                  ? CupertinoIcons.heart_solid
                  : CupertinoIcons.heart,
              size: 26,
            ),
            onPressed: () {
              toggleFavoriteMeal(mealId);
            },
          ),
        ],
      ),
    );

    final mediaQuery = MediaQuery.of(context);
    final double viewHeight = (mediaQuery.size.height -
        appBar.preferredSize.height -
        mediaQuery.padding.top);

    return CupertinoPageScaffold(
      navigationBar: appBar,
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                child: Image.network(
                  selectedMeal.imageUrl,
                  fit: BoxFit.cover, // important!
                ),
                height: viewHeight * 0.35,
                width: double.infinity,
              ),
              buildSectionTitle(
                'Ingredients',
                context,
                viewHeight * 0.03,
              ),
              buildContainer(
                viewHeight * 0.18,
                ListView.builder(
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: CupertinoTheme.of(context).primaryColor,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 15,
                        ),
                        child: Text(selectedMeal.ingredients[index]),
                      ),
                    );
                  },
                  itemCount: selectedMeal.ingredients.length,
                ),
              ),
              buildSectionTitle(
                'Steps',
                context,
                viewHeight * 0.03,
              ),
              buildContainer(
                viewHeight * 0.18,
                ListView.builder(
                  itemBuilder: (context, index) {
                    return Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(width: 1),
                              ),
                              child: Center(
                                child: Text('# ${index + 1}'),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 5,
                                ),
                                child: Text(
                                  selectedMeal.steps[index],
                                  softWrap: true,
                                  // style: TextStyle(fontSize: 12),
                                ),
                              ),
                            )
                          ],
                        ),
                        Divider(),
                      ],
                    );
                  },
                  itemCount: selectedMeal.steps.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
