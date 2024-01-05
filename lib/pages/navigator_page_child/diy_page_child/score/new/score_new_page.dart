import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flying_kxz/pages/navigator_page_child/diy_page_child/score/new/import_score_new_page.dart';
import 'package:flying_kxz/pages/navigator_page_child/diy_page_child/score/new/view/import_button.dart';
import 'package:flying_kxz/pages/navigator_page_child/diy_page_child/score/new/view/score_card.dart';
import 'package:flying_kxz/pages/navigator_page_child/diy_page_child/score/new/view/score_filter_console.dart';
import 'package:flying_kxz/pages/navigator_page_child/diy_page_child/score/new/view/score_help_dialog.dart';
import 'package:flying_kxz/pages/navigator_page_child/diy_page_child/score/new/view/score_profile.dart';
import 'package:flying_kxz/pages/navigator_page_child/diy_page_child/score/new/view/ui/score_container.dart';
import 'package:provider/provider.dart';

import '../../../../../ui/ui.dart';
import '../../../../../util/logger/log.dart';
import '../../../../../util/security/security.dart';
import 'model/score_provider.dart';

void toScoreNewPage(BuildContext context) {
  Navigator.of(context)
      .push(CupertinoPageRoute(builder: (context) => ScoreNewPage()));
}

class ScoreNewPage extends StatefulWidget {
  const ScoreNewPage({Key key});

  @override
  State<ScoreNewPage> createState() => _ScoreNewPageState();
}

class _ScoreNewPageState extends State<ScoreNewPage> {
  ThemeProvider themeProvider;
  ScoreProvider scoreProvider;
  final GlobalKey topSizeKey = GlobalKey();

  // TODO: 记得补全
  void _toSetPage() {
    print("toSetPage");
  }

  void showFilter() => scoreProvider.toggleShowFilterView();

  void _showHelp() => FlyDialogDIYShow(context, content: ScoreHelpDialog());

  _import() async {
    List<Map<String, dynamic>> result = await Navigator.push(context,
        CupertinoPageRoute(builder: (context) => ImportScoreNewPage()));
    if (result == null || result.isEmpty) return;
    scoreProvider.setAndCalScoreList(result);
    Logger.log("Score", "提取,成功",
        {"info": SecurityUtil.base64Encode(result.toString())});
  }

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    return ChangeNotifierProvider(
      create: (_) => ScoreProvider(),
      builder: (context, child) {
        scoreProvider = Provider.of<ScoreProvider>(context);
        return Scaffold(
          appBar: buildAppBar(context),
          body: Padding(
            padding:
                EdgeInsets.fromLTRB(spaceCardMarginRL, 0, spaceCardMarginRL, 0),
            child: Column(
              children: [
                // 顶部区域
                buildTopArea(context),
                SizedBox(
                  height: spaceCardPaddingTB,
                ),
                ScoreFilterConsole(),
                // 下面
                Expanded(
                  child: ListView.builder(
                      itemCount: scoreProvider.scoreListLength,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.fromLTRB(0, spaceCardPaddingTB, 0, 0),
                          child: ScoreCard(
                            scoreItem: scoreProvider.getScoreItem(index),
                          ),
                        );
                      }),
                ),
                ScoreImportButton(context: context, onTap: () => _import())
              ],
            ),
          ),
        );
      },
    );
  }

  Widget buildAppBar(BuildContext context) {
    return FlyAppBar(context, '成绩（需内网或VPN）', actions: [
      _buildActionIconButton(Icons.settings, onPressed: () => _toSetPage()),
      _buildActionIconButton(Icons.help_outline, onPressed: () => _showHelp())
    ]);
  }

  Widget buildTopArea(BuildContext context) => ScoreProfile(
    jiaquan: scoreProvider.jiaquanTotal.toStringAsFixed(2),
    jidian: scoreProvider.jidianTotal.toStringAsFixed(2),
  );

  Widget _buildActionIconButton(IconData iconData,
      {Key key, VoidCallback onPressed}) {
    return IconButton(
        key: key,
        icon: Icon(
          iconData,
          color: Theme.of(context).primaryColor,
        ),
        onPressed: onPressed);
  }
}
