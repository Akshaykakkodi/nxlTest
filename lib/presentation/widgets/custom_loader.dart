import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CustomLoader extends StatelessWidget {
  const CustomLoader({super.key, this.size = 40, this.color});
  final double? size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SpinKitCircle(
      size: size ?? 40,
      color: color ?? Colors.blue,
    );
  }
}
