import 'package:flutter/material.dart';
import 'package:tradingview_app/core/constants/color/color_constant.dart';
import 'package:tradingview_app/core/extension/context_extension.dart';
import 'package:tradingview_app/product/init/locale/project_keys.dart';

class GlobalAverageDropdownButton extends StatefulWidget {
  const GlobalAverageDropdownButton({
    super.key,
  });

  @override
  State<GlobalAverageDropdownButton> createState() => _GlobalAverageDropdownButtonState();
}

class _GlobalAverageDropdownButtonState extends State<GlobalAverageDropdownButton> {
  String _selected = ProjectKeys.globalAverage;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ProjectColors.marinique,
        borderRadius: context.mediumCircular,
      ),
      child: Padding(
        padding: context.halfVerticalxSmallPad,
        child: DropdownButtonHideUnderline(
          child: DropdownButton(
            isDense: true,
            padding: EdgeInsets.zero,
            value: _selected,
            iconEnabledColor: ProjectColors.white,
            borderRadius: context.mediumCircular,
            style: context.poonMediumTheme,
            items: const [
              DropdownMenuItem(
                value: ProjectKeys.globalAverage,
                child: Text(ProjectKeys.globalAverage),
              ),
              DropdownMenuItem(
                value: ProjectKeys.appName,
                child: Text(ProjectKeys.appName),
              )
            ],
            onChanged: (value) {
              if (value is String) {
                setState(() {
                  _selected = value;
                });
              }
            },
          ),
        ),
      ),
    );
  }
}
