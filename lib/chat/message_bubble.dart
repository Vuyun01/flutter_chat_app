import 'package:chat_app/models/message.dart';
import 'package:chat_app/screens/show_image_message.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageBubble extends StatefulWidget {
  const MessageBubble(
      {super.key, required this.message, this.isCurrentUser = true});
  final Message message;
  final bool isCurrentUser;

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  bool _isShowTime = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        mainAxisAlignment: widget.isCurrentUser
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!widget.isCurrentUser)
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: CircleAvatar(
                backgroundImage: NetworkImage(widget.message.userImageURL),
              ),
            ),
          widget.message.type == 'image'
              ? GestureDetector(
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => ShowImageMessage(
                            imageURL: widget.message.text,
                            time: widget.message.createdAt,
                          ))),
                  child: SizedBox(
                    width: 200,
                    height: 250,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        widget.message.text,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                )
              : GestureDetector(
                  onTap: () {
                    setState(() {
                      _isShowTime = !_isShowTime;
                    });
                  },
                  child: Column(
                    crossAxisAlignment: !widget.isCurrentUser
                        ? CrossAxisAlignment.start
                        : CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        // margin: const EdgeInsets.symmetric(vertical: 5),
                        decoration: BoxDecoration(
                            color: widget.isCurrentUser
                                ? Theme.of(context).colorScheme.primary
                                : Colors.grey,
                            borderRadius: BorderRadius.circular(15)),
                        child: Text(
                          widget.message.text,
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(color: Colors.white),
                        ),
                      ),
                      if (_isShowTime)
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: Text(
                            '${DateFormat.yMMMd().format(widget.message.createdAt)} at ${DateFormat.jms().format(widget.message.createdAt)}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText2!
                                .copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary
                                        .withOpacity(0.6),
                                    fontSize: 12,
                                    fontStyle: FontStyle.italic),
                          ),
                        )
                    ],
                  ),
                ),
          if (widget.isCurrentUser)
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: CircleAvatar(
                backgroundImage: NetworkImage(widget.message.userImageURL),
              ),
            ),
        ],
      ),
    );
  }
}
