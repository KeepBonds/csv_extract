import 'dart:math';
import 'package:flutter/material.dart';

class RandomColorGenerator {
  static Random _random = Random();

  // List of predefined colors to compare against.
  static List<Color> _existingColors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
    Colors.purple,
    Colors.orange,
    Colors.cyanAccent,
    Color(0xFFFFc0CB),
  ];

  static List<Color> generateRandomColors(int count) {
    List<Color> randomColors = [];

    while (randomColors.length < count) {
      Color randomColor;
      if(randomColors.length < _existingColors.length) {
        randomColor = _existingColors[randomColors.length];
        randomColors.add(randomColor);
      } else {
        randomColor = _generateRandomColor();
        if (!_hasSimilarColor(randomColors, randomColor) &&
            !_isBlackOrWhite(randomColor)) {
          randomColors.add(randomColor);
        }
      }
    }

    return randomColors;
  }

  static Color _generateRandomColor() {
    return Color.fromARGB(
      255, // Alpha (opacity) value, 255 for fully opaque
      _random.nextInt(256), // Red value
      _random.nextInt(256), // Green value
      _random.nextInt(256), // Blue value
    );
  }

  static bool _hasSimilarColor(List<Color> colors, Color newColor) {
    // Adjust this threshold to control the similarity tolerance.
    double threshold = 100.0;

    for (Color existingColor in colors) {
      double colorDistance = _calculateColorDistance(newColor, existingColor);
      if (colorDistance < threshold) {
        return true; // Color is too similar to an existing color.
      }
    }

    return false; // Color is not too similar to any existing color.
  }

  static bool _isBlackOrWhite(Color color) {
    // Define a threshold to determine if a color is close to black or white.
    int threshold = 180;

    // Check if the color is close to black (all channels close to 0) or white (all channels close to 255).
    return color.red < threshold &&
        color.green < threshold &&
        color.blue < threshold &&
        (255 - color.red) < threshold &&
        (255 - color.green) < threshold &&
        (255 - color.blue) < threshold;
  }

  static double _calculateColorDistance(Color color1, Color color2) {
    int rDiff = color1.red - color2.red;
    int gDiff = color1.green - color2.green;
    int bDiff = color1.blue - color2.blue;

    return sqrt(rDiff * rDiff + gDiff * gDiff + bDiff * bDiff);
  }
}