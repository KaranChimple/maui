import 'dart:io';

import 'package:flutter/material.dart';
import 'package:maui/components/number_dots.dart';

import 'package:maui/db/entity/unit.dart';
import 'package:maui/games/single_game.dart';
import 'package:maui/repos/unit_repo.dart';
import 'package:maui/state/app_state_container.dart';
import 'package:maui/state/app_state.dart';
import 'package:maui/state/button_state_container.dart';
import 'package:meta/meta.dart';
import 'dart:math';

class UnitButton extends StatefulWidget {
  final String text;
  final VoidCallback onPress;
  final UnitMode unitMode;

  final bool disabled;
  final bool highlighted;
  final bool primary;
  final bool showHelp;
  final String bgImage;
  final double maxWidth;
  final double maxHeight;
  final double fontSize;
  final bool forceUnitMode;
  final bool dotFlag;
  UnitButton(
      {Key key,
      @required this.text,
      this.onPress,
      this.disabled = false,
      this.showHelp = true,
      this.highlighted = false,
      this.primary = true,
      this.forceUnitMode = false,
      this.bgImage,
      this.maxHeight,
      this.maxWidth,
      this.fontSize,
      this.unitMode = UnitMode.text})
      : super(key: key);

  @override
  _UnitButtonState createState() {
    return new _UnitButtonState();
  }

  static void saveButtonSize(
      BuildContext context, int maxChars, double maxWidth, double maxHeight) {
    final container = ButtonStateContainer.of(context);
    final fontWidthFactor = maxChars == 1 ? 1.1 : 0.7;
    final fontSizeByWidth = maxWidth / (maxChars * fontWidthFactor);
    final fontSizeByHeight = maxHeight / 1.8;
    final buttonFontSize = min(fontSizeByHeight, fontSizeByWidth);
    final buttonRadius = min(maxWidth, maxHeight) / 8.0;

    final buttonWidth = (maxChars == 1)
        ? min(maxWidth, maxHeight)
        : buttonFontSize * maxChars * 0.7;
    final buttonHeight = (maxChars == 1)
        ? min(maxWidth, maxHeight)
        : min(maxHeight, maxWidth * 0.75);
    print(
        'width: ${buttonWidth} height: ${buttonHeight} maxWidth: ${maxWidth} maxHeight: ${maxHeight} maxChars: ${maxChars}');
    print(
        'fontsize: ${buttonFontSize} fontSizeByWidth: ${fontSizeByWidth} fontSizeByHeight ${fontSizeByHeight}');
    container.updateButtonConfig(
        fontSize: buttonFontSize,
        width: buttonWidth,
        height: buttonHeight,
        radius: buttonRadius);
    print(
        "widget testing comming here throwing null here.......${container.updateButtonConfig}");
  }
}

class _UnitButtonState extends State<UnitButton> {
  Unit _unit;
  bool _isLoading = true;
  UnitMode _unitMode;

  @override
  void initState() {
    super.initState();
    _unitMode = widget.unitMode;

    _getData();
  }

  @override
  void didUpdateWidget(UnitButton oldWidget) {
    if (widget.text != oldWidget.text) {
      _getData();
    }
  }

  void _getData() async {
    _isLoading = true;
    _unit = await new UnitRepo().getUnit(widget.text.toLowerCase());
    if (!widget.forceUnitMode &&
        ((_unitMode == UnitMode.audio && (_unit.sound?.length ?? 0) == 0) ||
            (_unitMode == UnitMode.image && (_unit.image?.length ?? 0) == 0))) {
      _unitMode = UnitMode.text;
    }
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return widget.showHelp
        ? new GestureDetector(
            onLongPress: () {
              AppStateContainer.of(context).playWord(widget.text.toLowerCase());
              if (_unit != null && _unitMode != UnitMode.audio) {
                AppStateContainer.of(context).display(context, widget.text);
              }
            },
            child: _buildButton(context))
        : _buildButton(context);
  }

  Widget _buildButton(BuildContext context) {
    // double affectHeight=widget.maxWidth ?? buttonConfig.width;
    final buttonConfig = ButtonStateContainer.of(context)?.buttonConfig;
    double affectwidth = widget.maxWidth ?? buttonConfig.width;
    double affectHeight = widget.maxHeight ?? buttonConfig.height;
    double widthOfButton = affectwidth - 10;
    double heightOfButton = affectHeight - 5;
    return Stack(children: [
      widget.text == ''
          ? Container()
          : Container(
              margin: EdgeInsets.only(top: 8.0, left: 5.0, right: 5.0),
              constraints: BoxConstraints.tightFor(
                  height: widget.maxHeight ?? heightOfButton,
                  width: widget.maxWidth ?? widthOfButton),
              // color: Colors.white,
              decoration: new BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.black,
                  borderRadius: BorderRadius.all(
                      Radius.circular(buttonConfig?.radius ?? 8.0))),
            ),
      Container(
          constraints: BoxConstraints.tightFor(
              height: widget.maxHeight ?? buttonConfig.height,
              width: widget.maxWidth ?? buttonConfig.width),
          decoration: new BoxDecoration(
              image: widget.bgImage != null
                  ? new DecorationImage(
                      image: new AssetImage(widget.bgImage),
                      fit: BoxFit.contain)
                  : null),
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                    Radius.circular(buttonConfig?.radius ?? 8.0))),
            elevation: widget.text == '' ? 0.0 : 5.0,
            child: Container(
              constraints: BoxConstraints.tightFor(
                  height: widget.maxHeight ?? buttonConfig.height,
                  width: widget.maxWidth ?? buttonConfig.width),
              decoration: new BoxDecoration(
                  image: widget.bgImage != null
                      ? new DecorationImage(
                          image: new AssetImage(widget.bgImage),
                          fit: BoxFit.contain)
                      : null),
              child: FlatButton(
                  color: widget.highlighted
                      ? Theme.of(context).primaryColor
                      : Colors.transparent,
                  splashColor: Theme.of(context).accentColor,
                  highlightColor: Theme.of(context).accentColor,
                  disabledColor: Color(0xFFDDDDDD),
                  onPressed: widget.disabled || widget.text == ''
                      ? null
                      : () {
                          AppStateContainer.of(context)
                              .play(widget.text.toLowerCase());
                          widget.onPress();
                        },
                  padding: EdgeInsets.all(0.0),
                  shape: new RoundedRectangleBorder(
                      side: widget.text != ''
                          ? new BorderSide(
                              color: widget.disabled
                                  ? Color(0xFFDDDDDD)
                                  : widget.primary
                                      ? Theme.of(context).primaryColor
                                      : Colors.white,
                              width: 4.0)
                          : BorderSide.none,
                      borderRadius: BorderRadius.all(
                          Radius.circular(buttonConfig?.radius ?? 8.0))),
                  child: Center(
                      child: _buildUnit(
                          widget.fontSize ?? buttonConfig.fontSize))),
            ),
          )),
    ]);
  }

  Widget _buildUnit(double fontSize) {
    if (_unitMode == UnitMode.audio) {
      return new Icon(Icons.volume_up);
    } else if (_unitMode == UnitMode.image) {
      return _isLoading
          ? new Container()
          : new Image.file(
              File(AppStateContainer.of(context).extStorageDir + _unit.image),
              fit: BoxFit.cover,
            );
    }
    int textNumber = int.tryParse(widget.text);
        ? Center(
            child: Text(widget.text,
                style: new TextStyle(
                    color: widget.highlighted || !widget.primary
                        ? Colors.white
                        : Theme.of(context).primaryColor,
                    fontSize: fontSize)))
        : Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
            Text(widget.text,
                style: new TextStyle(
                    color: widget.highlighted || !widget.primary
                        ? Colors.white
                        : Theme.of(context).primaryColor,
                    fontSize: fontSize / 2)),
            NumberDots(number: textNumber, fontSize: fontSize)
          ]);
  }

  @override
  void dispose() {
    super.dispose();
  }
}
