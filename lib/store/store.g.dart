// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AppStore on _AppStore, Store {
  final _$danmusAtom = Atom(name: '_AppStore.danmus');

  @override
  ObservableList<Danmu> get danmus {
    _$danmusAtom.reportRead();
    return super.danmus;
  }

  @override
  set danmus(ObservableList<Danmu> value) {
    _$danmusAtom.reportWrite(value, super.danmus, () {
      super.danmus = value;
    });
  }

  final _$superChatsAtom = Atom(name: '_AppStore.superChats');

  @override
  ObservableList<SuperChat> get superChats {
    _$superChatsAtom.reportRead();
    return super.superChats;
  }

  @override
  set superChats(ObservableList<SuperChat> value) {
    _$superChatsAtom.reportWrite(value, super.superChats, () {
      super.superChats = value;
    });
  }

  final _$_AppStoreActionController = ActionController(name: '_AppStore');

  @override
  void addDanmu(Danmu m) {
    final _$actionInfo =
        _$_AppStoreActionController.startAction(name: '_AppStore.addDanmu');
    try {
      return super.addDanmu(m);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addSuperChat(SuperChat sc) {
    final _$actionInfo =
        _$_AppStoreActionController.startAction(name: '_AppStore.addSuperChat');
    try {
      return super.addSuperChat(sc);
    } finally {
      _$_AppStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
danmus: ${danmus},
superChats: ${superChats}
    ''';
  }
}
