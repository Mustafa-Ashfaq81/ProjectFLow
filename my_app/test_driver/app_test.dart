import 'package:flutter_driver/driver_extension.dart';
import 'package:my_app/main.dart'
    as app; // Adjust the import to your app's entry point

void main() {
  // This line enables the extension
  enableFlutterDriverExtension();
  // Call the `main()` function of your app or run your app widget directly
  app.main();
}
