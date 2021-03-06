import 'package:flutter/material.dart';
import 'package:flutter_demo/main.dart';
import 'package:provider/provider.dart';

class ProviderPage extends StatefulWidget {
  ProviderPage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _ProviderPageState createState() => _ProviderPageState();
}

class _ProviderPageState extends State<ProviderPage> {
  int provideValue = 0;

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the ProviderPage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text("通过Provider更新数据"),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "provideValue: $provideValue",
              style: Theme.of(context).textTheme.display1,
            ),
            Provider<IncreaseWrapper>.value(
              value: Provider.of<IncreaseWrapper>(context),
              child: Consumer<IncreaseWrapper>(
                builder: (context, value, child) {
                  print("触发Provider's Consumer的build");
                  return Text("Provider & Consumer value: ${value.value}");
                },
              ),
            ),
            Text(
                "Provider directly: ${Provider.of<IncreaseWrapper>(context).value}"),
            Provider<IncreaseWrapper>.value(
              child: Text(
                  "Provider child: ${Provider.of<IncreaseWrapper>(context).value}"),
            ),
            Container(
                margin: EdgeInsets.all(10),
                height: 50,
                width: 300,
                child: FlatButton(
                  onPressed:
                      Provider.of<Counter>(context, listen: false).increment,
                  child: Consumer<Counter>(builder:
                      (BuildContext context, Counter counter, Widget child) {
                    return Text('更新本按钮的点击次数 ${counter.count} times');
                  }),
                  color: Colors.yellow,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                )),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            provideValue++;
            Provider.of<IncreaseWrapper>(context).value = provideValue;
          });
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
