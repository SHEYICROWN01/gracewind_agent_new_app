
import 'package:flutter/material.dart';

class ColorConstant {
  static Color black9007f = fromHex('#7f000000');

  static Color gray30087 = fromHex('#87e0e0e0');

  static Color gray30075 = fromHex('#75e0e0e0');

  static Color black900A2 = fromHex('#a2000000');

  static Color orange901 = fromHex('#0163F5');

  static Color orange900 = fromHex('#0163F5');

  static Color orange700 = fromHex('#0163F5');

  static Color black9003f = fromHex('#3f000000');

  static Color black90087 = fromHex('#87000000');

  static Color bluegray800 = fromHex('#37474f');

  static Color greenA700 = fromHex('#06b822');

  static Color black90099 = fromHex('#99000000');

  static Color black900 = fromHex('#000000');

  static Color bluegray400 = fromHex('#888888');

  static Color primaryColor = fromHex('#10175B');

  static Color whiteA700 = fromHex('#ffffff');

  static Color redA700 = fromHex('#ff0606');

  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}
