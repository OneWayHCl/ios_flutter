import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'present_page.dart';
import 'push_page.dart';
import 'package:flutter_boost/flutter_boost.dart';
import 'package:my_flutter/present_page.dart';
import 'package:my_flutter/push_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    FlutterBoost.singleton.registerPageBuilders({
      'push1': (pageName, params, _) => PushFirstApp(params: params),
      'push2': (pageName, params, _) => PushSecondPage(),
      'push3': (pageName, params, _) => ThirdPage(),
      'present1': (pageName, params, _) => PresentPageApp(),
      'present2': (pageName, params, _) => SecondPageContent(),

      ///可以在native层通过 getContainerParams 来传递参数
      // 'flutterPage': (String pageName, Map<String, dynamic> params, String _) {
      //   print('flutterPage params:$params');
      //   return FlutterRouteWidget(params: params);
      // },
    });
    // FlutterBoost.singleton
    //     .addBoostNavigatorObserver(TestBoostNavigatorObserver());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Boost example',
        builder: FlutterBoost.init(postPush: _onRoutePushed),
        home: Container(color: Colors.white));
  }

  void _onRoutePushed(
    String pageName,
    String uniqueId,
    Map<String, dynamic> params,
    Route<dynamic> route,
    Future<dynamic> _,
  ) {}
}

class TestBoostNavigatorObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic> previousRoute) {
    print('flutterboost#didPush');
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic> previousRoute) {
    print('flutterboost#didPop');
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic> previousRoute) {
    print('flutterboost#didRemove');
  }

  @override
  void didReplace({Route<dynamic> newRoute, Route<dynamic> oldRoute}) {
    print('flutterboost#didReplace');
  }
}

// class FlutterRouteWidget extends StatefulWidget {
//   const FlutterRouteWidget({this.params, this.message});

//   final Map<String, dynamic> params;
//   final String message;

//   @override
//   _FlutterRouteWidgetState createState() => _FlutterRouteWidgetState();
// }

// class _FlutterRouteWidgetState extends State<FlutterRouteWidget> {
//   // flutter 侧MethodChannel配置，channel name需要和native侧一致
//   static const MethodChannel _methodChannel =
//       MethodChannel('flutter_native_channel');
//   String _systemVersion = '';

//   Future<dynamic> _getPlatformVersion() async {
//     try {
//       final String result =
//           await _methodChannel.invokeMethod('getPlatformVersion');
//       print('getPlatformVersion:' + result);
//       setState(() {
//         _systemVersion = result;
//       });
//     } on PlatformException catch (e) {
//       print(e.message);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final String message = widget.message;
//     return Scaffold(
//       appBar: AppBar(
//         brightness: Brightness.light,
//         backgroundColor: Colors.white,
//         textTheme: const TextTheme(title: TextStyle(color: Colors.black)),
//         title: const Text('flutter_boost_example'),
//       ),
//       body: SingleChildScrollView(
//         child: Container(
//           margin: const EdgeInsets.all(24.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Container(
//                 margin: const EdgeInsets.only(top: 10.0, bottom: 20.0),
//                 child: Text(
//                   message ??
//                       'This is a flutter activity \n params:${widget.params}',
//                   style: TextStyle(fontSize: 28.0, color: Colors.blue),
//                 ),
//                 alignment: AlignmentDirectional.center,
//               ),
//               const CupertinoTextField(
//                 prefix: Icon(
//                   CupertinoIcons.person_solid,
//                   color: CupertinoColors.lightBackgroundGray,
//                   size: 28.0,
//                 ),
//                 padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 12.0),
//                 clearButtonMode: OverlayVisibilityMode.editing,
//                 textCapitalization: TextCapitalization.words,
//                 autocorrect: false,
//                 decoration: BoxDecoration(
//                   border: Border(
//                     bottom: BorderSide(
//                         width: 0.0, color: CupertinoColors.inactiveGray),
//                   ),
//                 ),
//                 placeholder: 'Name',
//               ),
//               InkWell(
//                 child: Container(
//                   padding: const EdgeInsets.all(8.0),
//                   margin: const EdgeInsets.all(8.0),
//                   color: Colors.yellow,
//                   child: const Text(
//                     'open native page',
//                     style: TextStyle(fontSize: 22.0, color: Colors.black),
//                   ),
//                 ),

//                 /// 后面的参数会在native的IPlatform.startActivity方法回调中拼接到url的query部分。
//                 /// 例如：sample://nativePage?aaa=bbb
//                 onTap: () => FlutterBoost.singleton.open(
//                   'sample://nativePage',
//                   urlParams: <String, dynamic>{
//                     'query': <String, dynamic>{'aaa': 'bbb'}
//                   },
//                 ),
//               ),
//               InkWell(
//                 child: Container(
//                   padding: const EdgeInsets.all(8.0),
//                   margin: const EdgeInsets.all(8.0),
//                   color: Colors.yellow,
//                   child: const Text(
//                     'open first',
//                     style: TextStyle(fontSize: 22.0, color: Colors.black),
//                   ),
//                 ),

//                 /// 后面的参数会在native的IPlatform.startActivity方法回调中拼接到url的query部分。
//                 /// 例如：sample://nativePage?aaa=bbb
//                 onTap: () => FlutterBoost.singleton.open(
//                   'first',
//                   urlParams: <String, dynamic>{
//                     'query': <String, dynamic>{'aaa': 'bbb'}
//                   },
//                 ),
//               ),
//               InkWell(
//                 child: Container(
//                   padding: const EdgeInsets.all(8.0),
//                   margin: const EdgeInsets.all(8.0),
//                   color: Colors.yellow,
//                   child: const Text(
//                     'open second',
//                     style: TextStyle(fontSize: 22.0, color: Colors.black),
//                   ),
//                 ),

//                 /// 后面的参数会在native的IPlatform.startActivity方法回调中拼接到url的query部分。
//                 /// 例如：sample://nativePage?aaa=bbb
//                 onTap: () => FlutterBoost.singleton.open(
//                   'second',
//                   urlParams: <String, dynamic>{
//                     'query': <String, dynamic>{'aaa': 'bbb'}
//                   },
//                 ),
//               ),
//               InkWell(
//                 child: Container(
//                   padding: const EdgeInsets.all(8.0),
//                   margin: const EdgeInsets.all(8.0),
//                   color: Colors.yellow,
//                   child: const Text(
//                     'open tab',
//                     style: TextStyle(fontSize: 22.0, color: Colors.black),
//                   ),
//                 ),

//                 /// 后面的参数会在native的IPlatform.startActivity方法回调中拼接到url的query部分。
//                 /// 例如：sample://nativePage?aaa=bbb
//                 onTap: () => FlutterBoost.singleton.open(
//                   'tab',
//                   urlParams: <String, dynamic>{
//                     'query': <String, dynamic>{'aaa': 'bbb'}
//                   },
//                 ),
//               ),
//               InkWell(
//                 child: Container(
//                   padding: const EdgeInsets.all(8.0),
//                   margin: const EdgeInsets.all(8.0),
//                   color: Colors.yellow,
//                   child: const Text(
//                     'open flutter page',
//                     style: TextStyle(fontSize: 22.0, color: Colors.black),
//                   ),
//                 ),

//                 /// 后面的参数会在native的IPlatform.startActivity方法回调中拼接到url的query部分。
//                 /// 例如：sample://nativePage?aaa=bbb
//                 onTap: () => FlutterBoost.singleton.open(
//                   'sample://flutterPage',
//                   urlParams: <String, dynamic>{
//                     'query': <String, dynamic>{'aaa': 'bbb'}
//                   },
//                 ),
//               ),
//               InkWell(
//                 child: Container(
//                   padding: const EdgeInsets.all(8.0),
//                   margin: const EdgeInsets.all(8.0),
//                   color: Colors.yellow,
//                   child: const Text(
//                     'push flutter widget',
//                     style: TextStyle(fontSize: 22.0, color: Colors.black),
//                   ),
//                 ),
//                 onTap: () {
//                   Navigator.push<dynamic>(
//                     context,
//                     MaterialPageRoute<dynamic>(builder: (_) => PushWidget()),
//                   );
//                 },
//               ),
//               InkWell(
//                 child: Container(
//                   padding: const EdgeInsets.all(8.0),
//                   margin: const EdgeInsets.all(8.0),
//                   color: Colors.yellow,
//                   child: const Text(
//                     'open flutter fragment page',
//                     style: TextStyle(fontSize: 22.0, color: Colors.black),
//                   ),
//                 ),
//                 onTap: () =>
//                     FlutterBoost.singleton.open('sample://flutterFragmentPage'),
//               ),
//               InkWell(
//                 child: Container(
//                     padding: const EdgeInsets.all(8.0),
//                     margin: const EdgeInsets.all(8.0),
//                     color: Colors.yellow,
//                     child: Text(
//                       'get system version by method channel:' + _systemVersion,
//                       style: TextStyle(fontSize: 22.0, color: Colors.black),
//                     )),
//                 onTap: () => _getPlatformVersion(),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// class FragmentRouteWidget extends StatelessWidget {
//   const FragmentRouteWidget(this.params);

//   final Map<String, dynamic> params;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('flutter_boost_example')),
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           Container(
//             margin: const EdgeInsets.only(top: 80.0),
//             child: Text(
//               'This is a flutter fragment',
//               style: TextStyle(fontSize: 28.0, color: Colors.blue),
//             ),
//             alignment: AlignmentDirectional.center,
//           ),
//           Container(
//             margin: const EdgeInsets.only(top: 32.0),
//             child: Text(
//               '${params['tag']}' ?? '',
//               style: TextStyle(fontSize: 28.0, color: Colors.red),
//             ),
//             alignment: AlignmentDirectional.center,
//           ),
//           Expanded(child: Container()),
//           InkWell(
//             child: Container(
//               padding: const EdgeInsets.all(8.0),
//               margin: const EdgeInsets.all(8.0),
//               color: Colors.yellow,
//               child: const Text(
//                 'open native page',
//                 style: TextStyle(fontSize: 22.0, color: Colors.black),
//               ),
//             ),
//             onTap: () => FlutterBoost.singleton.open('sample://nativePage'),
//           ),
//           InkWell(
//             child: Container(
//               padding: const EdgeInsets.all(8.0),
//               margin: const EdgeInsets.all(8.0),
//               color: Colors.yellow,
//               child: const Text(
//                 'open flutter page',
//                 style: TextStyle(fontSize: 22.0, color: Colors.black),
//               ),
//             ),
//             onTap: () => FlutterBoost.singleton.open('sample://flutterPage'),
//           ),
//           InkWell(
//             child: Container(
//               padding: const EdgeInsets.all(8.0),
//               margin: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 80.0),
//               color: Colors.yellow,
//               child: const Text(
//                 'open flutter fragment page',
//                 style: TextStyle(fontSize: 22.0, color: Colors.black),
//               ),
//             ),
//             onTap: () =>
//                 FlutterBoost.singleton.open('sample://flutterFragmentPage'),
//           )
//         ],
//       ),
//     );
//   }
// }

// class PushWidget extends StatefulWidget {
//   @override
//   _PushWidgetState createState() => _PushWidgetState();
// }

// class _PushWidgetState extends State<PushWidget> {
//   VoidCallback _backPressedListenerUnsub;

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();

// //    if (_backPressedListenerUnsub == null) {
// //      _backPressedListenerUnsub =
// //          BoostContainer.of(context).addBackPressedListener(() {
// //        if (BoostContainer.of(context).onstage &&
// //            ModalRoute.of(context).isCurrent) {
// //          Navigator.pop(context);
// //        }
// //      });
// //    }
//   }

//   @override
//   void dispose() {
//     print('[XDEBUG] - PushWidget is disposing~');
//     super.dispose();
//     _backPressedListenerUnsub?.call();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return const FlutterRouteWidget(message: 'Pushed Widget');
//   }
// }
