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
  final bytes = file.readAsBytesSync();
  final image = decodeImage(bytes);

  if (image == null) {
    print('Failed to decode the image.');
    return;
  }

  // Convert image to RGBA format if it isn't already
  final rgba = image.convert(numChannels: 4);

  int processedPixel = 0;
  int unProcessedPixel = 0;

  // Process the image to make white pixels transparent
  for (int y = 0; y < rgba.height; y++) {
    for (int x = 0; x < rgba.width; x++) {
      final pixel = rgba.getPixel(x, y);
      final r = pixel.r;
      final g = pixel.g;
      final b = pixel.b;

      // Define the threshold for "white" (can be adjusted for sensitivity)
      if (r > 200 && g > 200 && b > 200) {
        // Set alpha to 0 for white pixels
        rgba.setPixelRgba(x, y, r, g, b, 0);
        processedPixel++;
      } else {
        // Make sure non-white pixels are fully opaque
        rgba.setPixelRgba(x, y, r, g, b, 255);
        unProcessedPixel++;
      }
    }
  }

  // Save the modified image as a PNG (to preserve transparency)
  final outputPath = 'output_image.png';
  File(outputPath).writeAsBytesSync(encodePng(rgba));
  print('Processed image saved to $outputPath');
  print('Processed pixels: $processedPixel');
  print('Unprocessed pixels: $unProcessedPixel');
}
