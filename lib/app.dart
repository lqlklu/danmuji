import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'content/content.dart';
import 'store/store.dart';
import 'welcome/welcome.dart';
import 'settings/settings_controller.dart';
import 'settings/settings_view.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key, required this.settingsController}) : super(key: key);

  final SettingsController settingsController;

  @override
  Widget build(BuildContext context) => Provider<AppStore>(
        create: (_) => AppStore(),
        child: AnimatedBuilder(
          animation: settingsController,
          builder: (context, child) => MaterialApp(
            //l10n
            onGenerateTitle: (context) =>
                AppLocalizations.of(context)!.appTitle,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', ''),
              Locale('zh', ''),
            ],
            //theme
            theme: ThemeData(
              primarySwatch: Colors.pink,
            ),
            darkTheme: ThemeData.dark(),
            themeMode: settingsController.themeMode,
            onGenerateRoute: (RouteSettings routeSettings) {
              return MaterialPageRoute(
                settings: routeSettings,
                builder: (BuildContext context) {
                  switch (routeSettings.name) {
                    case SettingsView.routeName:
                      return SettingsView(controller: settingsController);
                    case Content.routeName:
                      final store = Provider.of<AppStore>(context);
                      return Content();
                    case Welcome.routeName:
                      return const Welcome();
                    default:
                      return const Welcome();
                  }
                },
              );
            },
          ),
        ),
      );
}
