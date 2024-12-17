
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EmoticonSticker extends StatefulWidget {
  final VoidCallback onTransform;
  final String imgPath; //이미지경로
  final bool isSelected;

  const EmoticonSticker({
    required this.onTransform,
    required this.imgPath,
    required this.isSelected,
    Key? key,
}): super(key: key);

  @override
  State<EmoticonSticker> createState() => _EmoticonStickerState();

}//class

class _EmoticonStickerState extends State<EmoticonSticker>{
  
  double scale = 1; // 확대/축소 비율
  double hTransform = 0; // 가로의 움직임
  double vTransform = 0; // 세로의 움직임
  double actualScale = 1; // 위젯의 초기 크기 기준 확대/축소 배율

  @override
  Widget build(BuildContext context) {
    return Transform( // child 위젯을 변형할 수 있는 위젯
        transform: Matrix4.identity()
          ..translate(hTransform, vTransform)//상/하 움직임 정의
          ..scale(scale,scale), // 확대/축소 정의

          child: Container(
            decoration: widget.isSelected
              ? BoxDecoration( //isSelected가 True이면
              borderRadius: BorderRadius.circular(4.0), // 모서리 둥글게
              border: Border.all( // 테두리 파란색
                color: Colors.blue,
                width: 1.0,
              ),
            )
              : BoxDecoration(
               // 테두리는 투명이나, 너비는 1로 설정해서 스티터가 선택,취소 될때 깜빡이는 현상 제거
                border: Border.all(
                  width: 1.0,
                  color: Colors.transparent,
                ),
            ),

          child : GestureDetector(
            onTap: () { //스티커를 눌렀을때 실행할 함수
              widget.onTransform(); //스티커의 상태가 변할때마다 실행
            },
            onScaleUpdate: (ScaleUpdateDetails details){
              //스티커의 확대 비율이 변경되었을때 실행할 함수
              widget.onTransform();
              setState(() {
                scale = details.scale * actualScale;
                //최근 확대 비율 기반으로 실제 확대 비율 계산
                vTransform += details.focalPointDelta.dy; //세로이동거리 계산
                hTransform += details.focalPointDelta.dx; // 가로이동거리 계산
              });
            },
            onScaleEnd: (ScaleEndDetails details){
              actualScale = scale; //확대 비율 저장
            },
              //스티커의 확대 비율 변경이 완료되었을때 실행
              child: Image.asset(
                widget.imgPath,//
              ),
            )
        ),
        );
  }

}