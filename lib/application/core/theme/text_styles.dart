import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const baseTestStyle = TextStyle(fontFamily: 'Poppins');

extension TextStyleX on TextStyle {
  TextStyle get w200 => copyWith(fontWeight: FontWeight.w200);
  TextStyle get w300 => copyWith(fontWeight: FontWeight.w300);
  TextStyle get w400 => copyWith(fontWeight: FontWeight.w400);
  TextStyle get w500 => copyWith(fontWeight: FontWeight.w500);
  TextStyle get w600 => copyWith(fontWeight: FontWeight.w600);
  TextStyle get w700 => copyWith(fontWeight: FontWeight.w700);
  TextStyle get w800 => copyWith(fontWeight: FontWeight.w800);
  TextStyle get bold => copyWith(fontWeight: FontWeight.bold);

  TextStyle get s08 => copyWith(fontSize: 8);
  TextStyle get s09 => copyWith(fontSize: 9);
  TextStyle get s10 => copyWith(fontSize: 10);
  TextStyle get s11 => copyWith(fontSize: 11);
  TextStyle get s12 => copyWith(fontSize: 12);
  TextStyle get s14 => copyWith(fontSize: 14);
  TextStyle get s15 => copyWith(fontSize: 15);
  TextStyle get s16 => copyWith(fontSize: 16);
  TextStyle get s18 => copyWith(fontSize: 18);
  TextStyle get s20 => copyWith(fontSize: 20);
  TextStyle get s22 => copyWith(fontSize: 22);
  TextStyle get s24 => copyWith(fontSize: 24);
  TextStyle get s26 => copyWith(fontSize: 26);
  TextStyle get s28 => copyWith(fontSize: 28);
  TextStyle get s31 => copyWith(fontSize: 31);

  TextStyle get underline => copyWith(
        decoration: TextDecoration.underline,
      );

  TextStyle get poppins => GoogleFonts.poppins().merge(this);

  TextStyle get primary => copyWith(color: Colors.black);
}
