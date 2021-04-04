import 'dart:convert';

import 'package:badges/badges.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flying_kxz/FlyingUiKit/toast.dart';
import 'package:flying_kxz/pages/navigator_page.dart';
import 'package:provider/provider.dart';

import 'Text/text.dart';
import 'Theme/theme.dart';
import 'container.dart';

void noticeGetInfo()async{
  if(!NoticeCardState.loading){
    NoticeCardState.loading = true;
    try{
      Dio dio = new Dio();
      Response res;
      res = await dio.get("https://www.lvyingzhao.cn/info");
      debugPrint(res.toString());
      Map<String,dynamic> map = jsonDecode(res.toString());
      if(map['status']==200){
        NoticeCardState.info = map['data'];
        FlyNavigatorPageState.badgeShowList[3] = true;
      }
    }catch(e){
      debugPrint(e.toString());
    }
    NoticeCardState.loading = false;
  }
}
class NoticeCard extends StatefulWidget {
  @override
  NoticeCardState createState() => NoticeCardState();
}

class NoticeCardState extends State<NoticeCard> {
  ThemeProvider themeProvider;
  static String info = '';
  static bool loading = false;
  void _getNoticeInfo()async{
    if(info==''&&!loading){
      loading = true;
      try{
        Dio dio = new Dio();
        Response res;
        res = await dio.get("https://www.lvyingzhao.cn/info");
        debugPrint(res.toString());
        Map<String,dynamic> map = jsonDecode(res.toString());
        if(map['status']==200){
          setState(() {
            info = map['data'];
          });
        }
      }catch(e){
        debugPrint(e.toString());
      }
      loading = false;
    }
  }
  @override
  void initState() {
    super.initState();
    _getNoticeInfo();
  }

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    return info==''?Container():Padding(
      padding: EdgeInsets.fromLTRB(spaceCardMarginRL, 0, spaceCardMarginRL, 0),
      child: FlyContainer(
          child: Padding(
            padding: EdgeInsets.fromLTRB(spaceCardPaddingRL, fontSizeMain40 * 1.3,
                spaceCardPaddingRL, fontSizeMain40 * 1.3),
            child:Row(
              children: <Widget>[
                Badge(
                  showBadge: true,
                  child: Icon(
                    Icons.info_outline,
                    size: sizeIconMain50,
                    color: themeProvider.colorNavText,
                  ),
                ),
                SizedBox(
                  width: spaceCardPaddingTB * 3,
                ),
                Expanded(
                  child:   FlyText.main40(
                    info,
                    color: themeProvider.colorNavText,maxLine: 100,fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          )),
    );
  }
}