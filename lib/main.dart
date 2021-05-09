import 'dart:math';
import 'package:extended_math/extended_math.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'game_theme.dart';

import 'slots.dart';

Random random = new Random();
void main() => runApp(const MyApp());

/// This is the main application widget.
class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

  static const String _title = 'Slot Machine';

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    int wheelCount = 9;
    int defaultCellCount = 10;
    List<int> cellCounts =
        List<int>.generate(wheelCount, (i) => defaultCellCount);
    List<FixedExtentScrollController> drumControllers =
        List<FixedExtentScrollController>.generate(
            wheelCount, (index) => new FixedExtentScrollController());
    List<double> wheelAxisOffsets = getAxisOffsets(wheelCount);
    List<DrumWheel> drums = List<DrumWheel>.generate(
        wheelCount,
        (index) => DrumWheel(
              controller: drumControllers[index],
              offAxisFraction: wheelAxisOffsets[index],
              cellCount: cellCounts[index],
              itemExtend: widget,
            ));
    return MaterialApp(
        title: MyApp._title,
        theme: buildTheme(),
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Slot Machine Alpha'),
          ),
          body: LayoutBuilder(
            builder: (ctx, constrains) {
              return Container(
                  //width: constrains.maxWidth,
                  //height: constrains.maxHeight,
                  child: Container(
                width: 800,
                height: 300,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: Container(
                    color: Colors.white.withAlpha(50),
                    child: FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 80.0),
                        child: Row(
                          children: drums,
                        ),
                      ),
                    ),
                  ),
                ),
              ));
            },
          ),
          bottomNavigationBar: BottomAppBar(
            shape: const CircularNotchedRectangle(),
            child: Container(height: 60.0),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              print("Spin");
              setState(() {
                spinDrums(drums);
              });
            },
            tooltip: 'Spin Wheel',
            child: const Icon(Icons.add),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
        ));
  }

  ThemeData buildTheme() {
    return ThemeData(
      // Define the default brightness and colors.
      brightness: Brightness.dark,
      primaryColor: GameTheme.primary,
      accentColor: GameTheme.accent,
      backgroundColor: GameTheme.backgroundBlack,
      fontFamily: 'Roboto',
      textTheme: TextTheme(
        headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
        headline6: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
      ),
    );
  }

  void spinDrums(List<DrumWheel> drums) {
    for (int i = 0; i < drums.length; i++) {
      double baseDelay = 5;
      double speedModifier = 5.0;

      int currentPos = drums[i].controller.selectedItem;
      int cellCount = drums[i].cellCount;
      int randomInt = random.nextInt(cellCount);
      int wheelOffset = ((i + 1) * (cellCount / 2)).toInt();
      int newPos = cellCount + currentPos + randomInt + wheelOffset;
      double randomDelay = random.nextDouble() * baseDelay / 2;
      double wheelDelay = (i.toDouble() + 1) * 3;
      double delay = (baseDelay + wheelDelay + randomDelay) * 1000;

      delay = delay / speedModifier;
      drums[i].controller.animateToItem(-1 * newPos,
          duration: Duration(milliseconds: delay.toInt()),
          curve: Curves.easeOutSine);
    }
  }

  List<double> getAxisOffsets(int count) {
    double range = 3;
    double start = 0 - (range / 2);
    double step = range / (count - 1);
    List<double> vals = List<double>.generate(count, (i) {
      return start + (step * i.toDouble());
    });
    return vals;
  }
}
