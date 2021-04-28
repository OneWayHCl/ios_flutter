# ios_flutter


https://juejin.cn/post/6844903977931243528

Flutter-flutter_boost与iOS页面跳转和channel参数传递

一.Flutter 项目配置

创建flutter_module项目
在pubspec.yaml中集成flutter_boost
flutter_boost: ^0.1.54
复制代码
main.dart中注册
void initState() {
    super.initState();
    FlutterBoost.singleton.registerPageBuilders({
      'first': (pageName, params, _) => FirstRouteWidget(params),
      'second': (pageName, params, _) => SecondRouteWidget(),
      'flutterFragment': (pageName, params, _) => FragmentRouteWidget(params: params,),
    });
  }
复制代码
二.iOS项目配置

项目为Xcode 11创建，自定义window,可看Xcode11

目录结构如下：

导入flutter,配置podfile文件
  flutter_application_path = '../flutter_module/'
  load File.join(flutter_application_path, '.ios', 'Flutter', 'podhelper.rb')
target 'Native-FF' do
  install_all_flutter_pods(flutter_application_path)
复制代码
执行pod install，成功后如下图：

Appdelgate配置
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    PlatformRouter * router = [[PlatformRouter alloc] init];
    router.navigationController = nav;
    [FlutterBoostPlugin.sharedInstance startFlutterWithPlatform:router onStart:^(FlutterEngine *engine) {
    }];
}
复制代码
新建文件PlatformRouter

PlatformRouter.h代码：

/** navigationController */
@property (nonatomic,strong) UINavigationController * navigationController;
复制代码
`PlatformRouter.m`代码：
复制代码
-(void)open:(NSString *)url urlParams:(NSDictionary *)urlParams exts:(NSDictionary *)exts completion:(void (^)(BOOL))completion
{
    if ([url containsString:@"sample://nativePage"]) {
        SecondViewController * secondVC = [[SecondViewController alloc] init];
        secondVC.params = urlParams;
        [self.navigationController pushViewController:secondVC animated:YES];
    }else{
        BOOL animated = [exts[@"animated"] boolValue];
        FLBFlutterViewContainer * containerVC = [[FLBFlutterViewContainer alloc] init];
        [containerVC setName:url params:urlParams];
        [self.navigationController pushViewController:containerVC animated:animated];
        if (completion) {
            completion(YES);
        }
    }
}
-(void)present:(NSString *)url urlParams:(NSDictionary *)urlParams exts:(NSDictionary *)exts completion:(void (^)(BOOL))completion
{
    BOOL animated = [exts[@"animated"] boolValue];
    FLBFlutterViewContainer * containerVC = [[FLBFlutterViewContainer alloc] init];
    [containerVC setName:url params:urlParams];
    [self.navigationController presentViewController:containerVC animated:animated completion:^{
        if (completion) {
            completion(YES);
        }
    }];
}
-(void)close:(NSString *)uid result:(NSDictionary *)result exts:(NSDictionary *)exts completion:(void (^)(BOOL))completion
{
    if ([uid containsString:@"sample://nativePage"]) {
        BOOL animated = [exts[@"animated"] boolValue];
        NSLog(@"关闭页面时,传递的信息%@",result);
       [self.navigationController popViewControllerAnimated:animated];
    }else{
        BOOL animated = [exts[@"animated"] boolValue];
        FLBFlutterViewContainer *vc = (id)self.navigationController.presentedViewController;
        if([vc isKindOfClass:FLBFlutterViewContainer.class] && [vc.uniqueIDString isEqual: uid]){
           [vc dismissViewControllerAnimated:animated completion:^{}];
        }else{
           [self.navigationController popViewControllerAnimated:animated];
        }
    }
}
复制代码
三.Flutter 与 Native 页面间跳转

1.Native 打开 Flutter 页面

iOS代码
[FlutterBoostPlugin open:@"first" urlParams:@{@"firstMessage":@"Native open Flutter first page with message"} exts:@{@"animated":@(YES)} onPageFinished:^(NSDictionary *result) {
    NSLog(@"Opened first page%@",result);
} completion:^(BOOL finish) {
}];
复制代码
Flutter代码
FlutterBoost.singleton.registerPageBuilders({
    'first': (pageName, params, _) => FirstRouteWidget(params),
});
复制代码
2.Native 关闭 Flutter 页面

iOS代码
[FlutterBoostPlugin close:@"flutterFragment" result:nil exts:nil completion:^(BOOL finish) {
}];
复制代码
Flutter代码
FlutterBoost.singleton.registerPageBuilders({
  'flutterFragment': (pageName, params, _) => FragmentRouteWidget(params: params,)
});
复制代码
3.Flutter 打开 Native 页面

Flutter代码
 FlutterBoost.singleton.open("sample://nativePage",urlParams: {"message":"Flutter open Native page!!!"}),
复制代码
iOS端在PlatformRouter中根据路由判断，执行跳转
-(void)open:(NSString *)url urlParams:(NSDictionary *)urlParams exts:(NSDictionary *)exts completion:(void (^)(BOOL))completion
{
    if ([url containsString:@"sample://nativePage"]) {
        SecondViewController * secondVC = [[SecondViewController alloc] init];
        secondVC.params = urlParams;
        [self.navigationController pushViewController:secondVC animated:YES];
    }
}
复制代码
4.Flutter 关闭 Native 页面

flutter代码：
return FlutterBoost.singleton.close("sample://nativePage",result: params);
复制代码
iOS端在PlatformRouter中根据路由判断，执行关闭：
-(void)close:(NSString *)uid result:(NSDictionary *)result exts:(NSDictionary *)exts completion:(void (^)(BOOL))completion
{
    if ([uid containsString:@"sample://nativePage"]) {
        BOOL animated = [exts[@"animated"] boolValue];
        NSLog(@"关闭页面时,传递的信息%@",result);
       [self.navigationController popViewControllerAnimated:animated];
    }
}
复制代码
四. Flutter 与 Native 方法调用和参数传递

1.Flutter 调用 Native 方法

flutter代码：
FlutterBoost.singleton.channel.sendEvent("flutter-native", {"message":"flutter send message to Native!!!"})
复制代码
iOS端监听方法：
#pragma mark - Flutter---调用---native
-(void)flutterCallNative
{
    /** 监听 Flutter 调用原生 */
    [FlutterBoostPlugin.sharedInstance addEventListener:^(NSString *name, NSDictionary *arguments) {
        NSLog(@"\n=====flutter发来消息========\n%@----\n%@",name,arguments);
    } forName:@"flutter-native"];
}
复制代码
2.Native 调用 Flutter

iOS发送事件
- (IBAction)sendMessageToFlutter:(id)sender {
    [FlutterBoostPlugin.sharedInstance sendEvent:@"native-flutter" arguments:@{@"flutter":@"native向flutter发送了参数\n"}];
}
复制代码
Flutter监听事件
FlutterBoost.singleton.channel.addEventListener("native-flutter",(name,params){
    return handleMsg(name,params);
});
handleMsg(String name,Map params){
    print("$name--原生调用flutter-$params");
}
复制代码
3.除了通过channel参数传递外，也可以通过open和close,制订自己的规则，进行非页面跳转的方法调用和参数传递
