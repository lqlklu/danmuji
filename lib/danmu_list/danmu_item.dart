import 'package:flutter/widgets.dart';

import 'package:danmuji/blive/entity.dart';

class DanmuItem extends StatelessWidget {
  final Danmu item;

  const DanmuItem(this.item, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text(item.brand),
            Text("${item.brandLev}"),
            Text(item.userName),
          ],
        ),
        Text(item.content),
      ],
    );
  }
}
