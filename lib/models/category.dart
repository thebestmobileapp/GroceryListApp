import 'package:flutter/material.dart';

//import 'package:intl/intl.dart';
enum Categories {
  vegetable,
  carbs,
  dairy,
  sweets,
  hygeine,
  fruit,
  meat,
  spices,
  convenience,
  other,
  vegetables
}

//this is not a widget just a model to hold the data
/* categoryIcons = {
  Category.food: Icons.lunch_dining,
  Category.leisure: Icons.movie,
  Category.travel: Icons.flight_takeoff,
  Category.work: Icons.work
};*/
//this generates a unique string id and initializes the id.

class Category {
  Category(this.title, this.color);
//:id = uuid.v4();

  final String title;
  final Color color;
}
