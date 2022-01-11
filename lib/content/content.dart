import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:danmuji/danmu_list/danmu_list.dart';
import 'package:danmuji/super_chat_list/super_chat_list.dart';
import 'package:danmuji/settings/settings_view.dart';

class Content extends StatelessWidget {
  static const routeName = "/content";

  const Content({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(t.appTitle),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
            icon: const Icon(Icons.settings),
          ),
        ],
      ),
      primary: true,
      body: Row(
        children: const [
          DanmuList(),
          SuperChatList(),
        ],
      ),
    );
  }
}
