import 'package:flutter/material.dart';
import 'package:flutter_demo/provider_page.dart';
import 'package:provider/provider.dart';
//import 'package:package_info/package_info.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<IncreaseWrapper>.value(value: IncreaseWrapper(100)),

        /// ChangeNotifierProvider
        /// 解决了数据改变后无法监听的问题
        ChangeNotifierProvider<Counter>.value(value: Counter()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  ValueNotifierData valueNotifierData = ValueNotifierData("0");

  void _incrementCounter() {
    _counter++;

    /// 通过key获取state调用方法更新
    _globalKey.currentState.updateValue(_counter);

    /// 通过ValueNotifierData更新
    valueNotifierData.value = _counter.toString();

    /// 调用setState更新根Widget
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
    });

    /*  PackageInfo.fromPlatform().then((PackageInfo packageInfo) {
      String _appBuildNumber = packageInfo.buildNumber;
      String _appVersion = packageInfo.version;
      setState(() {
        print("_appVersion: $_appVersion");
        print("_appBuildNumber: $_appBuildNumber");
      });
    });*/
  }

  GlobalKey<ChildStateWidget> _globalKey = GlobalKey();

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
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
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
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.display1,
            ),
            ChildWidget(
              key: _globalKey,
            ),
            InnerWidget(
              data: valueNotifierData,
            ),
            Container(
                margin: EdgeInsets.all(10),
                height: 50,
                width: 300,
                child: FlatButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ProviderPage()));
                  },
                  child: Text(
                      "从下个界面更新数据: ${Provider.of<IncreaseWrapper>(context).value}"),
                  color: Colors.cyanAccent,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                )),
            Container(
                margin: EdgeInsets.all(10),
                height: 50,
                width: 300,
                child: FlatButton(
                  onPressed:
                      Provider.of<Counter>(context, listen: false).increment,
                  child: Consumer<Counter>(builder:
                      (BuildContext context, Counter counter, Widget child) {
                    print("触发ChangeNotifierProvider's Consumer的build");
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
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

///使用GlobalKey更新子Widget
class ChildWidget extends StatefulWidget {
  ChildWidget({key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return ChildStateWidget();
  }
}

class ChildStateWidget extends State<ChildWidget> {
  int _updateTimes = 0;

  updateValue(int times) {
    setState(() {
      _updateTimes = times;
    });
  }

  @override
  void initState() {
    super.initState();
    print("ChildWidget initState");
  }

  @override
  Widget build(BuildContext context) {
    print("ChildWidget build");
    return Container(
      color: Colors.green,
      margin: EdgeInsets.all(10),
      height: 50,
      width: 300,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text("第$_updateTimes次更新"),
          Text("当前时间: ${DateTime.now()}")
        ],
      ),
    );
  }
}

/// 使用ValueNotifier更新子Widget
class ValueNotifierData extends ValueNotifier<String> {
  ValueNotifierData(value) : super(value);
}

class InnerWidget extends StatefulWidget {
  InnerWidget({this.data});

  final ValueNotifierData data;

  @override
  InnerWidgetState createState() => InnerWidgetState();
}

class InnerWidgetState extends State<InnerWidget> {
  String info;

  @override
  initState() {
    super.initState();
    widget.data.addListener(_handleValueChanged);
    info = 'Initial value: ' + widget.data.value;
  }

  @override
  void dispose() {
    widget.data.removeListener(_handleValueChanged);
    super.dispose();
  }

  void _handleValueChanged() {
    print("_handleValueChanged");
    setState(() {
      info = 'Value changed to: ' + widget.data.value;
    });
  }

  @override
  Widget build(BuildContext context) {
    print("InnerWidget build");
    return Container(
      color: Colors.yellow,
      margin: EdgeInsets.all(10),
      height: 50,
      width: 300,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[Text(info), Text("当前时间: ${DateTime.now()}")],
      ),
    );
  }
}

/// 通过Provider完成数据间共享, 需要定义数据的包裹类型
class IncreaseWrapper {
  int value = 6;

  IncreaseWrapper(this.value);
}

class Counter with ChangeNotifier {
  int _count = 0;

  int get count => _count;

  void increment() {
    _count++;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
