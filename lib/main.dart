import 'package:flutter/material.dart';
import 'package:mboa_connect/styles/themes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  await CompositionRoot.configure();
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
