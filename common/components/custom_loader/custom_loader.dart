import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CustomLoader extends StatelessWidget {
  final bool isFullScreen;
  final bool isPagination;
  final double strokeWidth;

  const CustomLoader({
    super.key,
    this.isFullScreen = true,
    this.isPagination = false,
    this.strokeWidth = 1,
  });

  @override
  Widget build(BuildContext context) {
    return isFullScreen
        ? Center(
            child: SpinKitFadingFour(
              color: Theme.of(context).primaryColor,
              size: 50.0,
            ),
          )
        : isPagination
        ? Center(
            child: SpinKitWave(
              color: Theme.of(context).primaryColor,
              size: 20.0,
            ),
            //Padding(
            //  padding: const EdgeInsets.all(10),
            //  child: LoadingIndicator(strokeWidth: strokeWidth),
            //),
          )
        : Center(
            child: SpinKitThreeBounce(
              color: Theme.of(context).primaryColor,
              size: 20.0,
            ),
          );
  }
}
