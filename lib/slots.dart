import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

Random random = new Random();
enum AniProps { hueRoller }

class WheelCell extends StatefulWidget {
  final Size size;
  final Text label;
  final int value;
  const WheelCell({Key key, this.label, @required this.value, this.size});
  @override
  _WheelCellState createState() => _WheelCellState(
        label: label,
        value: value,
      );
  void testValue() {
    print(value);
  }
}

class _WheelCellState extends State<WheelCell> {
  int value;
  Text label;
  _WheelCellState({Key key, this.label, this.value});
  @override
  Widget build(BuildContext context) {
    double hueBase = 30.0 * value.toDouble();
    Size size = widget.size == null ? Size(200, 200) : widget.size;
    double hueBg = hueBase % 360.0;
    double hueText = (hueBase + 30.0) % 360.0;
    Color colorBg = HSVColor.fromAHSV(1.0, hueBg, 1.0, 1.0).toColor();
    Color colorText = HSVColor.fromAHSV(1.0, hueText, 1.0, 1.0).toColor();

    return Container(
      width: size.width,
      height: size.height,
      child: Card(
          color: colorBg,
          /*shape: BeveledRectangleBorder(
              borderRadius: BorderRadius.circular(size.width / 8)),*/
          child: FittedBox(
              fit: BoxFit.contain,
              child: Padding(padding: EdgeInsets.all(6), child: label))),
    );
  }
}

class DrumWheels extends StatefulWidget {
  final int drumCount;
  final List<int> cellCounts;

  const DrumWheels(
      {Key key, @required this.drumCount, @required this.cellCounts})
      : super(key: key);

  @override
  _DrumWheelsState createState() => _DrumWheelsState();
}

class _DrumWheelsState extends State<DrumWheels> {
  @override
  Widget build(BuildContext context) {
    List<FixedExtentScrollController> drumControllers = [];
    for (int drumId = 0; drumId < this.widget.drumCount - 1; drumId++) {
      addController(drumControllers).add(new FixedExtentScrollController());
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('Click Here to Spin Wheel'),
          leading: IconButton(
            icon: const Icon(Icons.rotate_right),
            onPressed: () {
              spinWheels(drumControllers);
            },
          ),
        ),
        body: buildWheels(drumControllers));
  }

  List<FixedExtentScrollController> addController(
          List<FixedExtentScrollController> drumControllers) =>
      drumControllers;

  void spinWheels(List<ScrollController> drumControllers) {
    setState(() {
      for (int i = 0; i < drumControllers.length; i++) {}
    });
  }

  Widget buildWheels(List<ScrollController> drumControllers) {
    List<Widget> wheels = [];
    List<double> offAxisFractions = [-1.0, 0.0, 1.0];
    for (int i = 0; i < drumControllers.length - 1; i++) {
      wheels.add(DrumWheel(
        cellCount: 20,
        offAxisFraction: offAxisFractions[i],
        controller: drumControllers[i],
      ));
    }
    return Container(
        color: Colors.black,
        child: Center(
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center, children: wheels),
        ));
  }

  Curve randomCurve() {
    List<Curve> possibleCurves = [
      Curves.easeOutBack,
      Curves.ease,
      Curves.bounceOut
    ];
    int randomCurveId = random.nextInt(possibleCurves.length - 1);
    return possibleCurves[randomCurveId];
  }
}

class DrumWheel extends StatefulWidget {
  final int cellCount;
  final double offAxisFraction;
  final FixedExtentScrollController controller;
  final double wheelWidth;
  final double wheelHeight;
  final double itemExtend;
  final double visibleItems;

  final double wheelWidthDefault = 200;
  final double wheelHeightDefault = 600;
  final double visibleItemsDefault = 7;
  final double offAxisFractionDefault = 0.0;
  final double itemExtendDefault = 100;

  DrumWheel(
      {Key key,
      @required this.controller,
      @required this.cellCount,
      this.wheelWidth,
      this.itemExtend,
      this.wheelHeight,
      this.visibleItems,
      this.offAxisFraction})
      : super(key: key);
  @override
  _DrumWheelState createState() => _DrumWheelState();
}

class _DrumWheelState extends State<DrumWheel> {
  @override
  Widget build(BuildContext context) {
    double wheelHeight = widget.wheelHeight == null
        ? widget.wheelHeightDefault
        : widget.wheelHeight;
    double visibleItems = widget.visibleItems == null
        ? widget.visibleItemsDefault
        : widget.visibleItems;
    double itemExtend = widget.itemExtend == null
        ? widget.itemExtendDefault
        : widget.itemExtend;
    double offAxisFraction = widget.offAxisFraction == null
        ? widget.offAxisFractionDefault
        : widget.offAxisFraction;
    double wheelWidth = widget.wheelWidth == null
        ? widget.wheelWidthDefault
        : widget.wheelWidth;

    List<WheelCell> wheelCells =
        List<WheelCell>.generate(widget.cellCount, (i) {
      double hueBase = (i + 1) / widget.cellCount * 360.0;
      double hueCell = hueBase;
      double hueStep = 90.0;
      double hueText = (hueBase + hueStep) % 360.0;
      return WheelCell(
          key: Key('cell$i'),
          label: Text("$i"),
          value: i,
          size: Size(wheelWidth, itemExtend));
    });
    return Container(
        width: wheelWidth,
        child: new ConstrainedBox(
          constraints: BoxConstraints(
              // Set height to one line, otherwise the whole vertical space is occupied.
              maxHeight: wheelHeight),
          child: new ListWheelScrollView.useDelegate(
            key: Key('drum'),
            controller: widget.controller,
            itemExtent: itemExtend,
            offAxisFraction: offAxisFraction,
            diameterRatio: 5.0,
            useMagnifier: false,
            magnification: 1.2,
            physics: FixedExtentScrollPhysics(), //CustomScrollPhysics(),
            childDelegate: ListWheelChildLoopingListDelegate(
              children: wheelCells,
            ),
          ),
        ));
  }

  
}

class 
