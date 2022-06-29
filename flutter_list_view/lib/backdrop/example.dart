import 'package:flutter/material.dart';
import '../base/base_state.dart';
import 'backdrop_factory.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MyBackDropScreen();
  }
}

class MyBackDropScreen extends StatefulWidget {
  const MyBackDropScreen({super.key});

  @override
  State<MyBackDropScreen> createState() => _MyBackDropScreenState();
}

class _MyBackDropScreenState
    extends BackDropState<ExampleBackDropFactory, MyBackDropScreen> {
  @override
  Widget build(BuildContext context) {
    backDropFactory.build(vsync: this);

    backDropFactory.setData(ExampleBackDropData());

    return MaterialApp(
      //title: 'Backdrop Demo',
      home: Scaffold(
        appBar: AppBar(
          //elevation: 0.0,
          title: const Text("Step4"),
          leading: IconButton(
            onPressed: () {
              backDropFactory.controller
                  .fling(velocity: backDropFactory.isPanelVisible ? -1.0 : 1.0);
            },
            icon: AnimatedIcon(
              icon: AnimatedIcons.close_menu,
              progress: backDropFactory.controller.view,
            ),
          ),
        ),
        // body: const Text('sss'),
        body: LayoutBuilder(
          builder: backDropFactory.showBackDrop,
        ),
      ),
    );
  }

  @override
  createFactory() => ExampleBackDropFactory(callSetState: () {
        setState(() {});
      });
}
