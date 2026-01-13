import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../models/tag_model.dart';

class TypeIcon extends StatelessWidget {
  final TagType type;
  final bool isSelected;
  final double size;

  const TypeIcon({
    super.key,
    required this.type,
    this.isSelected = false,
    this.size = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      type.iconPath,
      width: size,
      height: size,
      colorFilter: ColorFilter.mode(
        isSelected ? Colors.white : type.color,
        BlendMode.srcIn,
      ),
      placeholderBuilder: (_) => Icon(
        Icons.circle,
        color: isSelected ? Colors.white : type.color,
        size: size,
      ),
    );
  }
}
