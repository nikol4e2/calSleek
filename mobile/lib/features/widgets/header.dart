import 'package:flutter/material.dart';

import '../../AppColors.dart';

Widget header(){

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RichText(text: const TextSpan(
            style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),
            children: [
              TextSpan(text: "cal", style: TextStyle(color: AppColors.primaryRed)),
              TextSpan(text: "sleek", style: TextStyle(color: Colors.white)),
            ]

          )),
          const CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage("https://i.pravatar.cc/100"),
          )
        ],
    ),

  );

}