
import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';
import 'dart:typed_data';


import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_photo/component/emoticon_sticker.dart';
import 'package:flutter_photo/component/sticker_model.dart';
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';


import '../component/footer.dart';
import '../component/main_app_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key,}) :super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();


}//class
class _HomeScreenState extends State<HomeScreen>{
  XFile? image;
  Set<StickerModel> stickers = {};//화면에 추가된 스티커를 저장할 변수
  String? selectedId; // 현재 선택된 스티커의 id
  GlobalKey imgKey = GlobalKey();//이미지로 전환할 위젯에 입력해줄 키값


  @override
  Widget build(BuildContext context) {
      return Scaffold(
        body: Stack( // 스크린에 Body, AppBar, Footer 순서로 쌓을 준비
          fit: StackFit.expand, // 자식 위젯들 최대 크기로 펼치기
          children: [
            //MainAppBar를 좌/우/ 위 끝에 정렬
            renderBody(), // #### 맨아래
            Positioned( // ### 두번째 아래
              top: 0,
              left: 0,
              right: 0,
              child: MainAppBar(
                onPickImage: onPickImage,
                onSaveImage: onSaveImage,
                onDeleteItem: onDeleteItem,
              ),
            ),
            //image가 선택되면 Footer 위치하기
            if(image != null)
              Positioned( // ### 첫번째아래
                bottom: 0,
                left: 0,
                right: 0,
                child: Footer(
                  onEmoticonTap: onEmoticonTap,
                ),
              ),

          ],
        ),
      );
  }

  //build() 함수 아래에 작성
  Widget renderBody(){
    if (image !=null){
      //Stack 크기의 최대 크기만큼 차지하기
      return RepaintBoundary(
          //위젯 이미지로 저장하는데 사용
          key: imgKey,
         child:Positioned.fill(
          //위젯 확대 및 좌우이동을 가능하게 하는 위젯
          child: InteractiveViewer(
            child : Stack(
              fit: StackFit.expand, //크기 최대로 늘러주기
              children: [
                Image.file(
                  File(image!.path),
                  fit: BoxFit.cover, // 이미지 최대한 이미지 공간 차지하기
                ),
                ...stickers.map(
                    (sticker) => Center( // 최초 스티커 선택시 중앙에 배치
                      child: EmoticonSticker(
                          key:ObjectKey(sticker.id),
                          onTransform: (){
                            onTransform(sticker.id);
                            // 스티커의 ID값 함수의 매개변수로 전달
                          },
                          imgPath: sticker.imgPath,
                          isSelected: selectedId == sticker.id
                      ),
                    ),
                ),

          ],
         ),
      ),
         ),
      );

    }
    else{
      // 이미지 선택이 안 된 경우, 이미지 선택 버튼 표시
      return Center(
        child: TextButton(
            style: TextButton.styleFrom(
                foregroundColor: Colors.grey,
            ),
            onPressed: onPickImage,
            child: Text('이미지 선택하기'),
        ),
      );
    }
  }

  void onTransform(String id) {
    //스티커가 변형될때마다 변형중인 스티커를 현재 선택한 스티커로 지정
    setState(() {
      selectedId = id;
    });

  }
  void onEmoticonTap(int index) async{
     setState(() {
       stickers ={
         ...stickers,
         StickerModel(
             id: Uuid().v4(), //스티커 고유 id
             imgPath: 'asset/img/emoticon_$index.png',
         ),
       };
     });
  }

  void onPickImage() async{
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    // 갤러리에서 이미지 선택하기

    setState(() {
      this.image = image; // 선택한 이미지 저장하기
    });

  }
  void onSaveImage() async{ // 이미지 저장 기능을 구현할 함수
    RenderRepaintBoundary boundary = imgKey.currentContext!
        .findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage(); // 바운더리를 이미지로 변경
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    //byte data 형태로 형태 변경
    Uint8List pngBytes = byteData!.buffer.asUint8List();
    //Uint8List 형태로 변경
    await ImageGallerySaverPlus.saveImage(pngBytes, quality: 100);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text('저장되었습니다.!'),
      )
    );

  }
  void onDeleteItem() async{
    setState(() {
      stickers = stickers.where((sticker) => sticker.id !=selectedId).toSet();
      //현재 선택되어 있는 스티커 삭제 후 Set로 변환
    });

  }


}//CLASS