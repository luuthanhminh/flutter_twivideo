import 'package:flirtbees/utils/app_asset.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GenderButton extends StatelessWidget {
  const GenderButton(
      {Key key,
      this.onPressed,
      this.pressedColor,
      this.normalIcon,
      this.pressedIcon})
      : super(key: key);

  final VoidCallback onPressed;
  final Color pressedColor;
  final String normalIcon;
  final String pressedIcon;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GenderButtonProvider>(
      create: (_) => GenderButtonProvider(),
      child: Consumer<GenderButtonProvider>(
        builder: (BuildContext context, GenderButtonProvider provider, _) {
          return RaisedButton(
            onPressed: () {
              if (onPressed != null) {
                onPressed();
              }
            },
            onHighlightChanged: (bool value) {
              provider.updateState(value);
            },
            padding: const EdgeInsets.all(0),
            color: provider.isPressed
                ? pressedColor ?? Theme.of(context).buttonColor
                : Colors.white,
            elevation: 4,
            shape: const CircleBorder(),
            child: Image.asset(
              provider.isPressed
                  ? (pressedIcon ?? AppImages.icEmpty)
                  : (normalIcon ?? AppImages.icEmpty),
              width: 64,
              height: 64,
            ),
          );
        },
      ),
    );
  }
}

class GenderButtonProvider with ChangeNotifier {
  bool isPressed = false;

  // ignore: avoid_positional_boolean_parameters
  void updateState(bool newState) {
    isPressed = newState;
    notifyListeners();
  }
}
