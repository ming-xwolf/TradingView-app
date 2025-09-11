import 'package:flutter/material.dart';
import 'package:tradingview_app/core/component/iconbutton/appbar_back_icon.dart';
import 'package:tradingview_app/core/component/iconbutton/appbar_star_icon.dart';
import 'package:tradingview_app/core/component/iconbutton/apppbar_notification_icon.dart';
import 'package:tradingview_app/core/component/text/label_small_text.dart';
import 'package:tradingview_app/core/component/text/title_medium_text.dart';
import 'package:tradingview_app/product/init/locale/project_keys.dart';

class TradingAppBar extends StatelessWidget implements PreferredSizeWidget {
  const TradingAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: const AppBarBackIconButton(),
      title: Column(
        children: [
          const TitleMediumText(text: '投资日记'),
          const LabelSmallText(text: ProjectKeys.globalAverage),
        ],
      ),
      actions: const [
        AppBarNotificationIconButton(),
        AppBarStarIconButton(),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
