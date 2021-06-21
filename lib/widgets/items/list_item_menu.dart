import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_ieadi_app/config/config.dart';
import 'package:provider/provider.dart';

import 'package:flutter_ieadi_app/style/style.dart';

class ListItemMenu extends StatelessWidget {
  final String title;
  final String text;
  final IconData icon;
  final int page;
  final Function onTap;
  final bool badge;

  ListItemMenu({
    this.title,
    this.text,
    this.icon,
    this.page,
    this.onTap,
    @required this.badge,
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
        title: Row(
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Badge(
                showBadge: this.badge,
                elevation: 0,
                padding: const EdgeInsets.all(3),
              ),
            ),
          ],
        ),
        //leading: Icon(icon),
        trailing: text != null
            ? Container(
                width: 200,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Flexible(
                      child: Container(
                        child: Text(
                          text,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                    ),
                    Icon(
                      FeatherIcons.chevronRight,
                      color: Colors.grey[400],
                    ),
                  ],
                ),
              )
            : Icon(icon),
        onTap: this.onTap != null
            ? this.onTap
            : () => context.read<CustomRouter>().setPage(page),
      ),
    );
  }
}

/*
ListItemMenu({
    String title,
    //IconData icon,
    String text,
    Function onTap,
  }) =>
      Container(
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: paleta['CinzaClaro'],
              width: 1,
            ),
          ),
        ),
        child: ListTile(
          title: Text(
            title,
            style: textP,
          ),
          //leading: Icon(icon),
          //trailing: Icon(icon),
          trailing: //Text(text),

              Container(
            width: 250,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(text),
                Icon(
                  FeatherIcons.chevronRight,
                  color: Colors.grey[400],
                ),
              ],
            ),
          ),

          onTap: onTap,
        ),
      );
*/
