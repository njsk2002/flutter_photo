

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef OnEmoticonTap = void Function(int id);
class Footer extends StatelessWidget{
  final OnEmoticonTap onEmoticonTap;

  const Footer({
    Key? key,
    required this.onEmoticonTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white.withOpacity(0.9),
      height: 150,
      child: SingleChildScrollView( // 가로고 스크롤 가능하게 스티커구현
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(
              7, (index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: GestureDetector(
              onTap: (){
                onEmoticonTap(index + 1); // 스티커 손택할때 실행할 함수
              },
              child: Image.asset(
                'asset/img/emoticon_${index+1}.png',
                height: 100,
              ),
            )
          )),
        ),
      ),
    );
  }

}