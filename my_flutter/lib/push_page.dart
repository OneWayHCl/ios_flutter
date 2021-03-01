import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_boost/flutter_boost.dart';

class PushFirstApp extends StatefulWidget {
  PushFirstApp({Key key, this.params}) : super(key: key);
  final Map params;
  @override
  _PushFirstAppState createState() => _PushFirstAppState();
}

class _PushFirstAppState extends State<PushFirstApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'enfry',
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      theme: ThemeData(primaryColor: Colors.orange),
      home: Scaffold(
          appBar: PreferredSize(
            child: AppBar(
              title: Text("First"),
              backgroundColor: Colors.lightBlue,
            ),
            preferredSize: Size.fromHeight(44.0),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new Text('第1个Flutter页面:${widget.params}'),
                SizedBox(
                  height: 15,
                ),
                new RaisedButton(
                  onPressed: () {
                    FlutterBoost.singleton
                        .open('push2', urlParams: <String, dynamic>{
                      'query': <String, dynamic>{'aaa': 'bbb'}
                    }, exts: {
                      'animated': true
                    });
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (context) => PushSecondPage(),
                    //   ),
                    // );
                  },
                  child: Text('跳转第二个Flutter页面'),
                ),
                SizedBox(
                  height: 15,
                ),
                new RaisedButton(
                  onPressed: () {
                    final BoostContainerSettings settings =
                        BoostContainer.of(context).settings;
                    FlutterBoost.singleton.close(
                      settings.uniqueId,
                      exts: {'animated': true},
                      result: <String, dynamic>{'result': '返回数据 from second'},
                    );
                  },
                  child: Text('关闭Flutter页面'),
                ),
                SizedBox(
                  height: 15,
                ),
                new RaisedButton(
                  onPressed: () {
                    FlutterBoost.singleton
                        .open('native', urlParams: <String, dynamic>{
                      'query': <String, dynamic>{'value': 'flutter传原生123'}
                    }, exts: {
                      'animated': true,
                      'ios': 'NativeViewController'
                    });
                  },
                  child: Text('跳转原生页面'),
                ),
              ],
            ),
          )),
    );
  }
}

class PushSecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 同上
      appBar: new AppBar(
        title: Text('SecondPage'),
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context, '第二个页面返回的内容');
          },
        ),
      ),
      body: new Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            new Text('第二个Flutter页面内容'),
            new RaisedButton(
              onPressed: () {
                SystemNavigator.pop();
              },
              child: Text('关闭所有Flutter页面'),
            ),
            new RaisedButton(
              onPressed: () {
                FlutterBoost.singleton.open(
                  'push3',
                  urlParams: <String, dynamic>{
                    'query': <String, dynamic>{'aaa': 'bbb'}
                  },
                );
              },
              child: Text('跳转第三页面'),
            ),
          ],
        ),
      ),
    );
  }
}
