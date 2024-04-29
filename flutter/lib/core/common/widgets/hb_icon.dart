import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';

import 'package:habib_app/core/res/hb_icons.dart';

class HBIcon extends StatelessWidget {

  final HBIcons icon;
  final double? size;
  final Color color;
  
  const HBIcon({
    super.key,
    required this.icon,
    required this.color,
    this.size
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      icon.path,
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn)
    );
  }
}