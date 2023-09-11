import 'package:shopping_list/models/category.dart';

class GroceryItem {
  const GroceryItem(
      {required this.id,
      required this.name,
      required this.quantity,
      required this.category});
//:id = uuid.v4();

  final String name;
  final Category category;
  final String id;
  final int quantity;
}
