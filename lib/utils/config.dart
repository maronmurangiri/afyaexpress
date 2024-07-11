import 'package:afyaexpress/screens/index.dart';
import 'package:flutter/material.dart';
class Config{
 static MediaQueryData ? mediaQueryData;
 static double ? screenWidth;
 static double? screenHeight;

 //Width and height initialization
 void init(BuildContext context){
   mediaQueryData = MediaQuery.of(context);
   screenWidth = mediaQueryData!.size.width;
   screenHeight = mediaQueryData!.size.height;
 }
 static get widthSize{
   return screenWidth;
 }
 static get heightSize{
   return screenHeight;
 }

 //spacing height
  static const spaceSmall = SizedBox(height: 25,);
 static const spaceMedium = SizedBox(height: 12.5,);
 static const spaceBig = SizedBox(height: 20,);

 ////text form field border
 static const outlinedBorder = OutlineInputBorder(
   borderRadius: BorderRadius.all(Radius.circular(8)),

 );
 static const focusBorder = OutlineInputBorder(
   borderRadius: BorderRadius.all(Radius.circular(8)),
   borderSide: BorderSide(
     color: IndexPage.primaryMuted,
   )
 );
 static const errorBorder = OutlineInputBorder(
 borderRadius: BorderRadius.all(Radius.circular(8)),
 borderSide: BorderSide(
 color: IndexPage.primaryDanger,
 ));
}
