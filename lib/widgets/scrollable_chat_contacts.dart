import 'package:chat_app/constant.dart';
import 'package:chat_app/models/user.dart';
import 'package:chat_app/provider/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScrollableChatContacts extends StatelessWidget {
  const ScrollableChatContacts({
    Key? key,
    required this.users,
  }) : super(key: key);
  final List<User> users;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    bool isDarkMode =
        Provider.of<SettingsProvider>(context, listen: false).isDark;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
      height: size.height * 0.12,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: users.length,
          itemBuilder: ((context, index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Column(
                  children: [
                    CircleAvatar(
                      minRadius: 30,
                      backgroundImage: NetworkImage(
                          users[index].imageURL ?? placeholderImage),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: SizedBox(
                          width: 50,
                          child: Text(
                              '${users[index].firstName} ${users[index].lastName}',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 12,
                                  color: isDarkMode ? lightTheme : null))),
                    )
                  ],
                ),
              ))),
    );
  }
}
