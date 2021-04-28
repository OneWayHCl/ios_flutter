import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';

import 'package:flutter_boost/flutter_boost.dart';

class PresentPageApp extends StatelessWidget {
  const PresentPageApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: PresentPage(),
    );
  }
}

const platform = const MethodChannel('enfry.flutter.io/enfry_present');

class PresentPage extends StatefulWidget {
  PresentPage({Key key}) : super(key: key);

  @override
  _PresentPageState createState() => _PresentPageState();
}

class _PresentPageState extends State<PresentPage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  String nativeBackString = ' ';

  Future<void> invokeNativeGetResult() async {
    String backString;
    try {
      // 调用原生方法并传参，以及等待原生返回结果数据
      var result = await platform.invokeMethod(
          'getNativeResult', {'key1': 'value1', 'key2': 'value2'});
      backString = '原生返回结果:$result';
    } on PlatformException catch (e) {
      backString = "Failed to get native return: '${e.message}'.";
    }

    print('原生返回的结果$backString');

    setState(() {
      nativeBackString = backString;
    });
  }

  void dismiss() {
    // 直接调用原生方法
    platform.invokeMethod('dismiss');
  }

  void goToNativeSecondPage() {
    // 直接调用原生方法
    platform.invokeMethod('presentNativeSecondPage');
  }

  void nativeMethod() {

    FlutterBoost.singleton.channel
        .sendEvent("flutter-native", {"message": mediaCall(context)});
  }

  String mediaCall(BuildContext context) {
    var media = MediaQuery.of(context);
    print(media.toString());
    print("设备像素密度:" + media.devicePixelRatio.toString());
    print(media.orientation);
    print("屏幕：" + media.size.toString());
    print('状态栏高度：' + media.padding.top.toString());
    return media.padding.toString();
  }

  Future<dynamic> _handel(MethodCall methodCall) {
    String backNative = "failure";
    if (methodCall.method == 'flutterMedia') {
      print("参数：" + methodCall.arguments.toString());
      backNative = mediaCall(this.context);
    }
    return Future.value(backNative);
  }

  @override
  void initState() {
    super.initState();

    print('Flutter--addEventListener');
    FlutterBoost.singleton.channel.addEventListener("native-flutter",
        (name, params) {
      return handleMsg(name, params);
    });
  }

  handleMsg(String name, Map params) {
    print("$name--原生调用flutter-$params");
  }

  dismissPage() {
    final BoostContainerSettings settings = BoostContainer.of(context).settings;
    FlutterBoost.singleton.close(
      settings.uniqueId,
      result: <String, dynamic>{'result': '返回数据 from second'},
    );
  }

  @override
  Widget build(BuildContext context) {
    // flutter 注册原生监听方法
    platform.setMethodCallHandler(_handel);

    return Scaffold(
      appBar: AppBar(
        title: Text("present Flutter页面1"),
        backgroundColor: Colors.lightBlue,
        leading: IconButton(
            icon: Icon(
              Icons.close,
            ),
            onPressed: () {
              dismissPage();
            }),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              nativeBackString,
            ),
            ElevatedButton(
              onPressed: () {
                dismissPage();
              },
              child: Text('Dismiss'),
            ),
            ElevatedButton(
              onPressed: goToNativeSecondPage,
              child: Text('跳转原生第二个页面'),
            ),
            ElevatedButton(
              onPressed: invokeNativeGetResult,
              child: Text('调用原生函数获取回调结果'),
            ),
            ElevatedButton(
                // child: Text('跳转第二个Flutter页面'),
                child: Text('Flutter传数据到原生'),
                onPressed: () {
                  nativeMethod();
                  // Navigator.of(context).push(MaterialPageRoute(
                  //   builder: (context) => SecondPageContent(),
                  // ));
                }),
            // Card(
            //   elevation: 4.0,
            //   shape: new RoundedRectangleBorder(
            //       borderRadius: BorderRadius.only(
            //     topLeft: Radius.circular(16.0),
            //     topRight: Radius.circular(16.0),
            //     bottomLeft: Radius.circular(12.0),
            //     bottomRight: Radius.circular(2.0),
            //   )),
            //   child: new IconButton(
            //       icon: Icon(Icons.add), onPressed: _incrementCounter),
            // ),
            ElevatedButton(
                child: Text('显示从原生返回的手机型号'),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: new Text('原生返回手机型号'),
                          content: Text(nativeBackString),
                          actions: <Widget>[
                            ElevatedButton(
                              child: new Text('确定'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            )
                          ],
                        );
                      });
                }
                ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), //
    );
  }
}

class SecondPageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: Text('第二个Present的Flutter页面'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              new Text('第二个Present的页面内容'),
              new ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ThirdPage(),
                    ),
                  );
                },
                child: Text('跳转第三个Flutter页面'),
              ),
              new ElevatedButton(
                onPressed: () {
                  //先关掉flutter里面的页面
                  SystemNavigator.pop();
                  //再回掉 直接调用原生方法
                  platform.invokeMethod('dismiss');
                },
                child: Text('关闭Flutter页面'),
              ),
            ],
          ),
        ));
  }
}

class ThirdPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text('第三Flutter页面'),
      ),
      body: new Center(
        child: Text('我是第三Flutter页面'),
      ),
    );
  }
}
