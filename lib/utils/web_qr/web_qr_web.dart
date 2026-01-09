import 'dart:js_interop';
import 'package:image_picker/image_picker.dart';

@JS('scanBarcodeFromImageUrl')
external JSPromise<JSString?> _scanBarcodeFromImageUrl(JSString imageUrl);

Future<String?> scanBarcodeFromImage(XFile image) async {
  try {
    // image.path on web (with image_picker) is a Blob URL (e.g. blob:http://...)
    final result = await _scanBarcodeFromImageUrl(image.path.toJS).toDart;
    return result?.toDart;
  } catch (e) {
    return null;
  }
}
