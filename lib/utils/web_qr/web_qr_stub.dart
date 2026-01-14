import 'package:image_picker/image_picker.dart';

Future<String?> scanBarcodeFromImage(XFile image) async {
  // On mobile/desktop, we rely on mobile_scanner's analyzeImage.
  // This stub is only hit if kIsWeb check fails or by mistake.
  return null;
}
