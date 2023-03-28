import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton(
      {Key? key, required this.text, required this.icon, required this.onPress, this.color = Colors.teal})
      : super(key: key);

  final IconData icon;
  final String text;
  final Function() onPress;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: size.width * 0.04),
      child: TextButton(
          style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(
                  horizontal: size.width * 0.06, vertical: size.width * 0.05),
              backgroundColor: Colors.grey.shade200,
              shape: RoundedRectangleBorder(
                  side:
                      BorderSide(color: color, width: 2),
                  borderRadius: BorderRadius.circular(15))),
          onPressed: onPress,
          child: Row(
            children: [
              Icon(
                icon,
                size: 25,
                color: Theme.of(context).colorScheme.primary,
              ),
              SizedBox(
                width: size.width * 0.05,
              ),
              Expanded(
                child: Text(
                  text,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.black45,
              )
            ],
          )),
    );
  }
}
