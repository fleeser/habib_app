import 'package:flutter/material.dart';

import 'package:gap/gap.dart';
import 'package:habib_app/core/res/theme/spacing/hb_spacing.dart';

class HBGap extends StatelessWidget {

  final double size;

  const HBGap({
    super.key,
    required this.size
  });

  const HBGap.zero({
    super.key
  })  : size = 0.0;

  const HBGap.xxxs({
    super.key
  })  : size = HBSpacing.xxxs;

  const HBGap.xxs({
    super.key
  })  : size = HBSpacing.xxs;

  const HBGap.xs({
    super.key
  })  : size = HBSpacing.xs;

  const HBGap.sm({
    super.key
  })  : size = HBSpacing.sm;

  const HBGap.md({
    super.key
  })  : size = HBSpacing.md;

  const HBGap.lg({
    super.key
  })  : size = HBSpacing.lg;

  const HBGap.xl({
    super.key
  })  : size = HBSpacing.xl;

  const HBGap.xxl({
    super.key
  })  : size = HBSpacing.xxl;

  const HBGap.xxxl({
    super.key
  })  : size = HBSpacing.xxxl;

  const HBGap.xxxxl({
    super.key
  })  : size = HBSpacing.xxxxl;

  @override
  Widget build(BuildContext context) {
    return Gap(size);
  }
}