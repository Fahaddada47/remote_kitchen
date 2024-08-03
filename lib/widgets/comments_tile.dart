import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../data/model/news_model.dart';

class CommentsTile extends StatefulWidget {
  final Story comment;
  final int depth;

  const CommentsTile({required this.comment, required this.depth});

  @override
  _CommentsTileState createState() => _CommentsTileState();
}

class _CommentsTileState extends State<CommentsTile> {
  bool showReplies = false;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final padding = screenWidth * 0.03;
    final avatarRadius = screenWidth * 0.04;
    final fontSize = screenWidth * 0.04;

    return Obx(() {
      return Container(
        padding:
            EdgeInsets.symmetric(vertical: padding, horizontal: padding * 1.5),
        margin: EdgeInsets.symmetric(vertical: padding / 2),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: Border(
            left: BorderSide(
              color: Colors.grey[400]!,
              width: 3 + widget.depth.toDouble(),
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: avatarRadius,
                  backgroundColor: Colors.grey[300],
                  child: Text(
                    widget.comment.by.isNotEmpty
                        ? widget.comment.by[0].toUpperCase()
                        : 'A',
                    style: TextStyle(
                        color: Colors.white, fontSize: fontSize * 0.5),
                  ),
                ),
                SizedBox(width: padding * 0.5),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.comment.by,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: fontSize,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: padding / 2),
                      Text(
                        DateFormat.yMMMd().add_jm().format(
                            DateTime.fromMillisecondsSinceEpoch(
                                widget.comment.time * 1000)),
                        style: TextStyle(
                            color: Colors.grey, fontSize: fontSize * 0.8),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: padding / 2),
            Text(
              widget.comment.text,
              style: TextStyle(fontSize: fontSize),
            ),
            SizedBox(height: padding / 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.thumb_up_alt_outlined,
                        size: fontSize * 0.8, color: Colors.grey),
                    SizedBox(width: padding * 0.5),
                    Text(
                      '${widget.comment.descendants}',
                      style: TextStyle(
                          color: Colors.grey, fontSize: fontSize * 0.8),
                    ),
                  ],
                ),
                InkWell(
                  onTap: () {
                    // handle reply action
                  },
                  child: Text(
                    'Reply',
                    style:
                        TextStyle(color: Colors.blue, fontSize: fontSize * 0.8),
                  ),
                ),
              ],
            ),
            if (widget.comment.comments.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(top: padding),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      showReplies = !showReplies;
                    });
                  },
                  child: Text(
                    showReplies
                        ? 'Hide replies'
                        : 'View more replies (${widget.comment.comments.length})',
                    style:
                        TextStyle(color: Colors.blue, fontSize: fontSize * 0.8),
                  ),
                ),
              ),
            if (showReplies)
              Padding(
                padding: EdgeInsets.only(left: padding),
                child: Column(
                  children: widget.comment.comments
                      .map((reply) =>
                          CommentsTile(comment: reply, depth: widget.depth + 1))
                      .toList(),
                ),
              ),
          ],
        ),
      );
    });
  }
}
