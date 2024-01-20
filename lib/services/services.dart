import 'package:get/get.dart';
import 'package:pleco_to_anki/services/converter_service.dart';

import 'anki_service.dart';

export 'anki_service.dart';

Future<void> initServices() async {
  await Get.putAsync(() => AnkiService().init());
  Get.put(ConverterService());
}
