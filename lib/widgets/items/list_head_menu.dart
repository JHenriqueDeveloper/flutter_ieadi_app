import 'package:flutter/material.dart';

class ListHeadMenu extends StatelessWidget {
  final Color background;
  final TextStyle fontStyle;
  final String text;
  final Widget child;

  ListHeadMenu({
    this.background,
    this.fontStyle,
    this.text,
    this.child,
  });

  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      margin: const EdgeInsets.only(
        bottom: 16,
      ),
      decoration: BoxDecoration(
          color: this.background != null
              ? this.background
              : Theme.of(context).primaryColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          )),
      child: this.child != null 
      ? this.child
      : Text(
        this.text != null ? this.text : '',
        style: this.fontStyle != null
            ? this.fontStyle
            : Theme.of(context).textTheme.subtitle2,
      ),
    );
  }
}
