import 'package:app4/screens/edit_product_screen.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';
import 'package:flutter/material.dart';
//am rezolvat
class UserProductItem extends StatelessWidget {
  String title, imageUrl, id;
  UserProductItem(this.title, this.imageUrl, this.id);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: SizedBox(
        width: 101,
        child: Row(children: [
          IconButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamed(EditProductScreen.routeName, arguments: id);
            },
            icon: const Icon(Icons.edit),
            color: Theme.of(context).primaryColor,
          ),
          IconButton(
            onPressed: () {
              Provider.of<Products>(context, listen: false).deleteProduct(id);
            },
            icon: const Icon(Icons.delete),
            color: Colors.red,
          ),
        ]),
      ),
    );
  }
}
