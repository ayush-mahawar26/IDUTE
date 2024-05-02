import 'package:flutter/material.dart';
import 'package:idute_app/components/widgets/custom_cont_text.dart';

import '../constants/size_config.dart';

class StepProgressView extends StatelessWidget {
  final double _width;

  final List<String> _titles;
  final int _curStep;
  final Color _activeColor;
  final Color _inactiveColor = const Color(0xffE6EEF3);
  final double lineWidth = 3.0;

  const StepProgressView(
      {Key? key,
      required int curStep,
      required List<String> titles,
      required double width,
      required Color color})
      : _titles = titles,
        _curStep = curStep,
        _width = width,
        _activeColor = color,
        assert(width > 0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        width: _width,
        height: 117,
        child: Row(
          children: <Widget>[
            Column(
              children: _iconViews(),
            ),
            buildSizeWidth(width: 9),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _titleViews(),
            ),
          ],
        ));
  }

  List<Widget> _iconViews() {
    var list = <Widget>[];
    _titles.asMap().forEach((i, icon) {
      var circleColor =
          (i == 0 || _curStep > i + 1) ? _activeColor : _inactiveColor;
      var lineColor = _curStep > i + 1 ? _activeColor : _inactiveColor;
      var iconColor =
          (i == 0 || _curStep > i + 1) ? Colors.white : _inactiveColor;

      list.add(
        i == _curStep - 1
            ? Container(
                width: 15,
                height: 15,
                decoration: const ShapeDecoration(
                  color: Color(0xFF007A5A),
                  shape: OvalBorder(),
                ),
                child: Icon(
                  Icons.circle,
                  color: iconColor,
                  size: 13,
                ),
              )
            : Container(
                width: 15,
                height: 15,
                decoration: ShapeDecoration(
                  color: circleColor,
                  shape: const OvalBorder(),
                ),
                child: Icon(
                  Icons.circle_outlined,
                  color: iconColor,
                  size: 13,
                ),
              ),
      );

      //line between icons
      if (i != _titles.length - 1) {
        list.add(
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(0.5),
              child: Container(
                width: 1,
                height: 18,
                color: lineColor,
              ),
            ),
          ),
        );
      }
    });

    return list;
  }

  List<Widget> _titleViews() {
    var list = <Widget>[];
    _titles.asMap().forEach((i, text) {
      list.add(
        buildContainerText(
          text: text,
          height: 18,
          width: 94,
          radSize: 10,
          borderWidth: 1.1,
          borderColor: i == _curStep - 1 ? _activeColor : Colors.transparent,
          txtSize: 9,
          txtColor: Colors.black,
          contColor:
              (i == 0 || _curStep > i + 1) ? _activeColor : _inactiveColor,
        ),
      );
    });
    return list;
  }
}
