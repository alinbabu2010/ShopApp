import 'package:flutter/material.dart';

class DrawerItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String route;

  const DrawerItem(
    this.icon,
    this.title,
    this.route, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(),
        ListTile(
          leading: Icon(icon),
          title: Text(title),
          onTap: () {
            final currentRoute = ModalRoute.of(context)?.settings.name;
            if (currentRoute == route) {
              Navigator.pop(context);
            } else {
              Navigator.of(context).pushReplacementNamed(route);
            }
          },
        ),
      ],
    );
  }
}
