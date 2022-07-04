import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      debugShowCheckedModeBanner: false,
      home: const MyPagesScreen(),
    );
  }
}

class MyPagesScreen extends StatefulWidget {
  const MyPagesScreen({super.key});

  @override
  State<MyPagesScreen> createState() => _MyPagesScreenState();
}

class _MyPagesScreenState extends State<MyPagesScreen> {
  bool _isToggle = false;
  bool _isShowHand = false;

  Widget getBear(isShow) {
    //https://stackoverflow.com/questions/49835623/how-to-load-images-with-image-file

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: isShow
          ? Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter:ColorFilter.mode(Colors.black.withOpacity(0.8), BlendMode.dstATop),
            image: const AssetImage("images/bear.jpg"),
            fit: BoxFit.cover,
          ),
        ),
      )
          : null,
    );
  }

  Widget getBearHand(isShow) {
    //https://stackoverflow.com/questions/49835623/how-to-load-images-with-image-file

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 100),
      child: isShow
          ? Container(
        alignment: Alignment.center,

        child: SizedBox(

          width: 200,
          height: 200,
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                colorFilter:ColorFilter.mode(Colors.black.withOpacity(1.0), BlendMode.dstATop),
                image: const AssetImage("images/bear_hand.jpg"),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),

      )
          : null,
    );
  }

  Widget getSwitch(value) {
    return SizedBox(
      width: 300,
      //height: 40,
      child: FittedBox(
        fit: BoxFit.fill,
        child: Switch(
          value: value,
          onChanged: (bool value) {
            setState(() {
              _isToggle = value;
              Future.delayed(const Duration(milliseconds: 400), () {
                setState(() {
                  _isShowHand = !_isShowHand;
                });
              });
            });
            //https://stackoverflow.com/questions/49471063/how-to-run-code-after-some-delay-in-flutter
            Future.delayed(const Duration(milliseconds: 1000), () {
              setState(() {
                _isToggle = !_isToggle;
                _isShowHand = _isToggle;
              });
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    //https://stackoverflow.com/questions/54606771/animate-show-or-hide-widgets-with-flutter
    return Scaffold(
      body: Stack(
        children: [
          getBear(_isToggle),
          Center(
            child: getSwitch(_isToggle),
          ),
          getBearHand(_isShowHand),
        ],
      ),
    );
  }
}

class MyWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyWidgetState();
  }
}

class _MyWidgetState extends State<MyWidget> {
  bool loading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: loading
            ? Container(
                key: Key("loading"),
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: GestureDetector(
                      onTap: _toggle,
                      child: const CircularProgressIndicator(),
                    ),
                  ),
                ),
              )
            : Container(
                key: Key("normal"),
                child: Center(
                  child: GestureDetector(
                    onTap: _toggle,
                    child: const Text("WELCOME"),
                  ),
                ),
              ),
      ),
    );
  }

  _toggle() {
    setState(() {
      loading = !loading;
    });
  }
}
