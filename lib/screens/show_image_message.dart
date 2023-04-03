import 'package:chat_app/constant.dart';
import 'package:chat_app/provider/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ShowImageMessage extends StatelessWidget {
  const ShowImageMessage(
      {super.key, required this.imageURL, required this.time});
  final String imageURL;
  final DateTime time;
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<SettingsProvider>(context).isDark;
    return Scaffold(
      backgroundColor: isDarkMode ? darkTheme : null,
      appBar: AppBar(
        backgroundColor:
            isDarkMode ? Theme.of(context).colorScheme.tertiary : null,
        centerTitle: true,
        titleTextStyle: Theme.of(context)
            .textTheme
            .bodyText1!
            .copyWith(color: Colors.white, fontStyle: FontStyle.italic),
        title: Text('${DateFormat.yMMMd().format(time)} at ${DateFormat.jms().format(time)} '),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.close)),
      ),
      body: Center(
        child: Image.network(
          imageURL,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
