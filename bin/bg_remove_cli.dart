import 'dart:io';
import 'package:image/image.dart';

void main(List<String> args) {
  if (args.isEmpty) {
    print('Please provide the image path.');
    return;
  }

  // Load the image from a file
  final imagePath = args[0];
  final file = File(imagePath);
  final image = decodeImage(file.readAsBytesSync());

  if (image == null) {
    print('Failed to decode the image.');
    return;
  }

  // Process the image to make white pixels transparent
  for (int y = 0; y < image.height; y++) {
    for (int x = 0; x < image.width; x++) {
      final pixel = image.getPixel(x, y);
      final r = pixel.r;
      final g = pixel.g;
      final b = pixel.b;

      // Define the threshold for "white" (can be adjusted for sensitivity)
      if (r > 240 && g > 240 && b > 240) {
        // Set the pixel to transparent (RGBA: 0x00FFFFFF)
        // for making each pixel transparent with existing pixel
        image.setPixelRgba(x, y, r, g, b, 0);
        // for making each pixel transparent with black pixel
        // image.setPixelRgba(x, y, 0, 0, 0, 0);
      }
    }
  }

  // Save the modified image as a PNG (to preserve transparency)
  final outputPath = 'output_image.png';
  File(outputPath).writeAsBytesSync(encodePng(image));
  print('Processed image saved to $outputPath');
}
