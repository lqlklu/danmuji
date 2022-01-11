import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:danmuji/store/store.dart';
import 'package:danmuji/content/content.dart';
import 'package:danmuji/settings/settings_view.dart';

class Welcome extends StatelessWidget {
  static const routeName = "/";

  const Welcome({Key? key}) : super(key: key);

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
      body: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [_RoomIdForm()],
      ),
    );
  }
}

class _RoomIdForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _RoomIdFormState();
  }
}

class _RoomIdFormState extends State<_RoomIdForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final contoller = TextEditingController();

  @override
  void dispose() {
    contoller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<AppStore>(context);
    final t = AppLocalizations.of(context)!;

    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: contoller,
            decoration: InputDecoration(
              hintText: t.roomid_hint,
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return t.roomid_error;
              }
              if (int.tryParse(value) == null) {
                return t.roomid_error;
              }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  var s = contoller.text;
                  store.roomId = int.parse(s);
                  store.close();
                  store.connect();
                  Navigator.pushNamed(context, Content.routeName);
                }
              },
              child: Text(t.enter),
            ),
          ),
        ],
      ),
    );
  }
}
