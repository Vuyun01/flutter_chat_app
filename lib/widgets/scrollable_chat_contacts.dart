
import 'package:flutter/material.dart';

class ScrollableChatContacts extends StatelessWidget {
  const ScrollableChatContacts({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      height: size.height * 0.12,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 6,
          itemBuilder: ((context, index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: FittedBox(
                  child: Column(
                    children: [
                      const CircleAvatar(
                        minRadius: 50,
                        backgroundImage: NetworkImage(
                            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTzfsTdRjF6giyFsO-d-Jw9beVB4cruN84U8n04eS3vZBHlgh2EFWe5KiTox-qt89I5-Io&usqp=CAU'),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      SizedBox(
                          width: 60,
                          child: Text('User nameasd asd as asda sdas',
                              // softWrap: true,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  ?.copyWith(fontSize: 18)))
                    ],
                  ),
                ),
              ))),
    );
  }
}
