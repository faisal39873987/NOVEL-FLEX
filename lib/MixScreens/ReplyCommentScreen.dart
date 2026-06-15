import 'package:flutter/material.dart';

import '../Utils/Constants.dart';
import '../localization/Language/languages.dart';

class ReplyComment extends StatefulWidget {
  String? bookId;
  String bookName;
  String bookImag;
  String commentID;

  ReplyComment({super.key, 
    required this.bookId,
    required this.bookName,
    required this.bookImag,
    required this.commentID,
  });

  @override
  State<ReplyComment> createState() => _ReplyCommentState();
}

class _ReplyCommentState extends State<ReplyComment> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xffebf5f9),
      appBar: AppBar(
        toolbarHeight: height * 0.07,
        backgroundColor: const Color(0xffebf5f9),
        elevation: 0.0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 25,
            color: Colors.black,
          ),
        ),
        title: Text(
          widget.bookName,
          style: const TextStyle(color: Colors.black54),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          Languages.of(context)?.nodata ?? 'No data',
          style: const TextStyle(
            fontFamily: Constants.fontfamily,
            color: Colors.black54,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
