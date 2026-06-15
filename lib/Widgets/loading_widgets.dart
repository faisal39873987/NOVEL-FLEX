import 'package:flutter/material.dart';
import 'package:more_loading_gif/more_loading_gif.dart';
class CustomCard extends StatelessWidget {
  final MoreLoadingGif? gif;
  final String? text;
  const CustomCard({Key? key, this.gif, this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      height: height*0.15,
      width: width*0.3,

      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF19547b),Color(0xFF2193b0), Color(0xFF19547b),Color(0xFF19547b)



            ]),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          gif!,
          Text(text!,
              style: const TextStyle(
                  color:  Colors.white,
                  fontWeight: FontWeight.normal,
                  fontFamily: "Alexandria",
                  fontStyle: FontStyle.normal,
                  fontSize: 12.0),
              textAlign: TextAlign.right)
        ],
      ),
    );
  }
}