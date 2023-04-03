import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../constant.dart';

class CustomPopupMenuButton extends StatelessWidget {
  const CustomPopupMenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
              // shape: RoundedRectangleBorder(
              //     //shape for its children
              //     side: BorderSide(color: isDark ? darkTheme : lightTheme)),
              icon: const Icon(Icons.more_vert_outlined),
              onSelected: ((value) async{
                if (value == PopupMenuOption.logout) {
                  // await _logout();
                } else {
                  // await Navigator.of(context)
                  //     .pushNamed(ProfileScreen.routeName)
                  //     .then((_) {
                  //   setState(() {});
                  // });
                }
              }),
              itemBuilder: ((context) => [
                    PopupMenuItem(
                        value: PopupMenuOption.profile,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text('Profile'),
                            Icon(
                              Icons.person,
                              color: Colors.black,
                            )
                          ],
                        )),
                    PopupMenuItem(
                        value: PopupMenuOption.logout,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text('Log Out'),
                            Icon(
                              Icons.logout,
                              color: Colors.black,
                            )
                          ],
                        )),
                  ]));
  }
}