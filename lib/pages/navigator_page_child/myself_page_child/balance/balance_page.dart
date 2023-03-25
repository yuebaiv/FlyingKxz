import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flying_kxz/util/logger/log.dart';
import 'package:flying_kxz/pages/navigator_page_child/myself_page_child/balance/utils/provider.dart';
import 'package:flying_kxz/ui/ui.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

//跳转到当前页面
void toBalancePage(BuildContext context) {
  Navigator.push(
      context, CupertinoPageRoute(builder: (context) => BalancePage()));
  Logger.sendInfo('Balance', '进入',{});
}

class BalancePage extends StatefulWidget {
  @override
  _BalancePageState createState() => _BalancePageState();
}

class _BalancePageState extends State<BalancePage> {
  ThemeProvider themeProvider;
  BalanceProvider balanceProvider;
  bool loading = true;

  // 充值
  void _charge() {
    FlyDialogDIYShow(context,
        content: Wrap(
          runSpacing: spaceCardPaddingTB,
          children: [
            FlyText.title45(
              '请在充值页面点击"卡片充值"。\n充值需要内网或VPN！',
              maxLine: 10,
            ),
            Image.asset("images/balanceRechargeHelp.png"),
            _buildButton("知道啦，前往充值页面↗", onTap: () {
              launchUrl(Uri.parse("http://ykt.cumt.edu.cn/Phone/Index"));
            }),
          ],
        ));
  }

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    balanceProvider = Provider.of<BalanceProvider>(context);
    return Scaffold(
      appBar: FlyAppBar(
        context,
        "校园卡",
      ),
      body: Container(
        width: double.infinity,
        child: SingleChildScrollView(
          physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          child: Padding(
            padding: EdgeInsets.fromLTRB(spaceCardMarginRL, spaceCardMarginTB,
                spaceCardMarginRL, spaceCardMarginTB),
            child: Wrap(
              runSpacing: spaceCardPaddingTB,
              children: [
                _buildHeadCard(context),
                _buildBalanceDetail(context),
                Center(
                  child: Column(
                    children: [
                      FlyText.miniTip30("更新时间："+balanceProvider.getBalanceHisDate),
                      FlyText.miniTip30('"我的"页面初始化时自动获取'),

                    ],
                  ),
                ),
                SizedBox(height: 300,)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBalanceDetail(BuildContext context) {
    return _container(
        child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FlyText.main40("校园卡流水",
                color: Theme.of(context).primaryColor.withOpacity(0.5)),
          ],
        ),
        SizedBox(
          height: spaceCardPaddingTB * 2,
        ),
        balanceProvider.detailInfo != null
            ? Wrap(
                runSpacing: spaceCardPaddingTB * 1.5,
                children: balanceProvider.detailInfo.data.map((item) {
                  return _buildDetailItem(
                      item.location, item.time, item.costMoney, item.balance);
                }).toList(),
              )
            : loadingAnimationIOS(),
      ],
    ));
  }

  Row _buildDetailItem(
      String title, String time, String change, String balance) {
    //处理小数点
    balance = (double.parse(balance) / 100).toStringAsFixed(2);
    change = (double.parse(change) / 100).toStringAsFixed(2);
    //修改余额改变的正负号 并添加色彩
    double changeInt = double.parse(change);
    Color colorItem; //卡片色彩 正为绿 负为橙
    if (changeInt > 0) {
      change = "+" + change;
      colorItem = Color(0xff00c5a8);
    } else {
      colorItem = Colors.deepOrange;
    }
    //19283->192.83
    return Row(
      children: [
        Container(
          height: fontSizeMain40 * 3,
          width: 5,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(100),
            color: colorItem,
          ),
        ),
        SizedBox(
          width: spaceCardPaddingRL / 1.5,
        ),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FlyText.title45(title),
                  SizedBox(
                    height: spaceCardPaddingTB / 2,
                  ),
                  FlyText.mini30(
                    time,
                    color: Theme.of(context).primaryColor.withOpacity(0.5),
                  )
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  FlyText.title50(
                    change,
                    fontWeight: FontWeight.bold,
                  ),
                  SizedBox(
                    height: spaceCardPaddingTB / 2,
                  ),
                  FlyText.mini30(
                    "余额 " + balance,
                    color: Theme.of(context).primaryColor.withOpacity(0.5),
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _container({@required Widget child}) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadiusValue),
          color: Theme.of(context).cardColor),
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(spaceCardPaddingRL, spaceCardPaddingTB * 1.6,
          spaceCardPaddingRL, spaceCardPaddingTB * 1.6),
      child: child,
    );
  }

  InkWell _buildButton(String title,
      {bool primer = true, GestureTapCallback onTap}) {
    Color borderColor = primer ? Colors.transparent : themeProvider.colorMain;
    Color textColor = primer ? Colors.white : themeProvider.colorMain;
    Color backgroundColor =
        primer ? themeProvider.colorMain : Colors.transparent;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(spaceCardMarginRL),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadiusValue),
            border: Border.all(color: borderColor),
            color: backgroundColor),
        child: Center(
          child: FlyText.title45(
            title,
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildHeadCard(BuildContext context) {
    return _container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          balanceProvider.balance,
          style: TextStyle(
              fontSize: ScreenUtil().setSp(90), fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: spaceCardPaddingTB / 2,
        ),
        FlyText.mini30(
          "卡号：" + balanceProvider.cardNum,
          color: Theme.of(context).primaryColor.withOpacity(0.5),
        ),
        SizedBox(
          height: spaceCardPaddingTB * 1.5,
        ),
        _buildRechargeButton()
      ],
    ));
  }

  InkWell _buildRechargeButton() {
    return InkWell(
      onTap: () => _charge(),
      child: Container(
        padding: EdgeInsets.all(spaceCardMarginRL),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(borderRadiusValue),
            color: themeProvider.colorMain),
        child: Center(
          child: FlyText.title45(
            "充 值",
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
