import 'package:flutter/material.dart';
import 'package:mboa_connect/src/composition_root.dart';
import 'package:mboa_connect/styles/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await CompositionRoot.setup();
  final firstPage = CompositionRoot.start();

  runApp(MboaConnect(firstPage));
}

class MboaConnect extends StatelessWidget {
  final Widget firstPage;

  MboaConnect(this.firstPage);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mboa Connect',
      theme: lightTheme(context),
      darkTheme: darkTheme(context),
      home: firstPage,
    );
  }
}
