import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import 'package:danmuji/danmu_list/danmu_item.dart';
import 'package:danmuji/store/store.dart';

class DanmuList extends StatelessWidget {
  const DanmuList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = Provider.of<AppStore>(context);
    return Observer(
      builder: (_) => Flexible(
        child: ListView.builder(
          itemCount: store.danmus.length,
          itemBuilder: (_, index) {
            final item = store.danmus[index];
            return DanmuItem(item);
          },
        ),
      ),
    );
  }
}
