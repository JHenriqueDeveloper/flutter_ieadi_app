import 'package:flutter/material.dart';
import 'package:flutter_ieadi_app/config/config.dart';
import 'package:provider/provider.dart';

import 'package:flutter_ieadi_app/style/style.dart';

class NavListItem extends StatelessWidget {
  final String title;
  final IconData icon;
  final int page;

  NavListItem({
    this.title,
    this.icon,
    this.page,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: LightStyle.paleta['CinzaClaro'],
            width: 1,
          ),
        ),
      ),
      child: ListTile(
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodyText1,
        ),
        //leading: Icon(icon),
        trailing: Icon(icon),
        onTap: () => context.read<CustomRouter>().setPage(page),
      ),
    );
  }
}
