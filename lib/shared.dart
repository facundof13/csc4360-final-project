// Horizontal Spacing
import 'package:flutter/material.dart';

// colors
const Color primaryColor = Color(0xff40C5CC);
const Color mediumGreyColor = Color(0xff868686);
const Color fontPrimaryColor = Color(0xff484848);
const Color gradientDarkColor = Color(0xff6EE4E1);
const Color gradientLightColor = Color(0xff69E0DF);

const Color primaryDarkColor = Color(0xff049EB1);
const Color primaryLightColor = Color(0xff6EE4E1);
// Text Style

// Font Sizing
const double bodyTextSize = 16;

const Widget horizontalSpaceTiny = SizedBox(width: 5.0);
const Widget horizontalSpaceSmall = SizedBox(width: 10.0);
const Widget horizontalSpaceRegular = SizedBox(width: 18.0);
const Widget horizontalSpaceMedium = SizedBox(width: 25.0);
const Widget horizontalSpaceLarge = SizedBox(width: 50.0);

// Vertical Spacing
const Widget verticalSpaceTiny = SizedBox(height: 5.0);
const Widget verticalSpaceSmall = SizedBox(height: 10.0);
const Widget verticalSpaceRegular = SizedBox(height: 18.0);
const Widget verticalSpaceMedium = SizedBox(height: 25);
const Widget verticalSpaceLarge = SizedBox(height: 50.0);
const Widget verticalSpaceMassive = SizedBox(height: 120.0);

// Screen Size Helpers
double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;
double screenHeight(BuildContext context) => MediaQuery.of(context).size.height;

/// Returns the pixel amount for the percentage of the screen height. [percentage] should
/// be between 0 and 1 where 0 is 0% and 100 is 100% of the screens height
double screenHeightPercentage(BuildContext context, {double percentage = 1}) =>
    screenHeight(context) * percentage;

/// Returns the pixel amount for the percentage of the screen width. [percentage] should
/// be between 0 and 1 where 0 is 0% and 100 is 100% of the screens width
double screenWidthPercentage(BuildContext context, {double percentage = 1}) =>
    screenWidth(context) * percentage;

void snackBar(BuildContext context, String text) =>
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
