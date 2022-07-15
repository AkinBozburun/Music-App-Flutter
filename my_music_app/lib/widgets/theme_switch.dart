import 'package:flutter/material.dart';
import 'package:player/providers.dart';
import 'package:provider/provider.dart';

class ThemeSwitchButton extends StatelessWidget
{
  const ThemeSwitchButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    final themeProvider = Provider.of<ThemeProvider>(context);

    Color cP = Theme.of(context).colorScheme.primary;
    Color cS = Theme.of(context).colorScheme.secondary;

    return Switch.adaptive
    (
      value: themeProvider.isDark,
      onChanged: (value)
      {
        final provider = Provider.of<ThemeProvider>(context,listen: false);
        provider.themeSave(value,context);
      },
      activeColor: Theme.of(context).primaryColor,
      activeTrackColor: cP,
      inactiveTrackColor: cS,
    );
  }
}