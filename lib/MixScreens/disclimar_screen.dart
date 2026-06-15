import 'package:flutter/material.dart';

import '../Utils/Constants.dart';
import '../localization/Language/languages.dart';
class DisclimarScreen extends StatelessWidget {
  const DisclimarScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color(0xffebf5f9),
      appBar: AppBar(
        backgroundColor: const Color(0xffebf5f9),
        elevation: 0.0,
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black54,
            )),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:  EdgeInsets.only(top:height*0.02,left: height*0.03,right:height*0.03 ),
          child: Center(
            child: Text(Languages.of(context)!.disclaimer,style: const TextStyle(
              fontSize: 23.0,
              fontFamily: Constants.fontfamily
            ),),
          ),
        ),
      ),
    );
  }
}
