// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:waytofresh/core/utils/size_utils.dart';
// import 'package:waytofresh/routes/app_routes.dart';
// import 'package:waytofresh/theme/theme_helper.dart';

// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   // 🚨 CRITICAL: Device orientation lock - DO NOT REMOVE
//   SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((
//     value,
//   ) {
//     runApp(MyApp());
//   });
// }

// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return Sizer(
//       builder: (context, orientation, deviceType) {
//         return GetMaterialApp(
//           debugShowCheckedModeBanner: false,
//           theme: theme,
//           locale: Locale('en', ''),
//           fallbackLocale: Locale('en', ''),
//           title: 'blinkit_grocery',
//           initialRoute: AppRoutes.initialRoute,
//           getPages: AppRoutes.pages,
//           // 🚨 CRITICAL: NEVER REMOVE OR MODIFY
//           builder: (context, child) {
//             return MediaQuery(
//               data: MediaQuery.of(
//                 context,
//               ).copyWith(textScaler: TextScaler.linear(1.0)),
//               child: child!,
//             );
//           },
//           // 🚨 END CRITICAL SECTION
//         );
//       },
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:waytofresh/core/utils/size_utils.dart';
import 'package:waytofresh/routes/app_routes.dart';
import 'package:waytofresh/theme/theme_helper.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // 🚨 CRITICAL: Lock orientation to portrait
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((
    _,
  ) {
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return OrientationBuilder(
          builder: (context, orientation) {
            // Initialize SizeUtils for responsive sizing
            SizeUtils.setScreenSize(constraints, orientation);

            return GetMaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'blinkit_grocery',
              theme: theme,
              locale: const Locale('en', ''),
              fallbackLocale: const Locale('en', ''),
              initialRoute: AppRoutes.initialRoute,
              getPages: AppRoutes.pages,

              // 👇 Ensures consistent text scaling across devices
              builder: (context, child) {
                return MediaQuery(
                  data: MediaQuery.of(
                    context,
                  ).copyWith(textScaler: const TextScaler.linear(1.0)),
                  child: child!,
                );
              },
            );
          },
        );
      },
    );
  }
}
