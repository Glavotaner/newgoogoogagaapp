import 'package:googoogagaapp/screens/kiss_selection/widgets/kiss_type.dart';

class KissType {
  String body;
  String title;
  String confirmMessage;
  String? assetPath;

  KissType(
      {required this.body,
      required this.title,
      required this.confirmMessage,
      this.assetPath});

  static final List<KissType> kissTypes = [
    KissType(
        body: 'you are givded regular kiss!',
        title: 'Regular kiss',
        confirmMessage: 'you gave regular kiss, good job!',
        assetPath: 'assets/regularKiss.jpg'),
    KissType(
        body: 'wahwahweewah you got BIG kiss',
        title: 'Big kiss',
        confirmMessage: 'you send big kiss!',
        assetPath: 'assets/bigKiss.jpg'),
    KissType(
        body: 'hello boss, you got boss baby kiss',
        title: 'Boss baby kiss',
        confirmMessage: 'you gave boss babba kiss',
        assetPath: 'assets/bossBabyKiss.jpg'),
  ];
}

List<KissTypeWidget> buildKissTypes() {
  return KissType.kissTypes
      .where((kissType) => kissType.assetPath?.isNotEmpty ?? false)
      .map((kissType) => KissTypeWidget(kissType))
      .toList();
}
