//
//  ViewController.m
//  MyApp
//
//  Created by HCl on 2021/2/3.
//

#import "ViewController.h"
#import <Flutter/Flutter.h>
#import <FlutterPluginRegistrant/GeneratedPluginRegistrant.h>
#import <flutter_boost/FlutterBoost.h>
#import "FLBFlutterViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "AppDelegate.h"

@interface ViewController ()

@property (nonatomic, strong) UIButton *presFPageBtn;
@property (nonatomic, strong) UIButton *pushFPageBtn;
@property (strong, nonatomic) FlutterMethodChannel *presentChannel;
@property (nonatomic, strong) FLBFlutterViewController *fvc;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"原生第一个ViewController";
    self.view.backgroundColor = [UIColor grayColor];
    [self.view addSubview:self.presFPageBtn];
    self.presFPageBtn.frame = CGRectMake(69, 200, 220, 48);
    
    [self.view addSubview:self.pushFPageBtn];
    self.pushFPageBtn.frame = CGRectMake(60, 300, 220, 48);
    
    [AppDelegate appDelegate].pRouter.navigationController = self.navigationController;
    
    
    [[FlutterBoostPlugin sharedInstance] addEventListener:^(NSString *name, NSDictionary *arguments) {
        NSLog(@"监听到Flutter:%@---%@", arguments, name);
        
        UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"Flutter返回" message:arguments[@"message"] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {

        }];
        [alertVC addAction:defaultAction];
        [self.fvc presentViewController:alertVC animated:YES completion:nil];
        
    } forName:@"flutter-native"];
}

- (NSString *)getDeiveName {
    UIDevice *device = UIDevice.currentDevice;
    return device.name;
}

- (void)presentNativeSecondPage
{
    
}

- (IBAction)pushAction:(id)sender{
    
}

- (void)presentFlutterPage:(UIButton *)sender
{
    FLBFlutterViewController *fvc = FLBFlutterViewController.new;
    [fvc setName:@"present1" params:@{@"second_name_key1":@"second_name_value1"}];
    [FlutterBoostPlugin.sharedInstance sendEvent:@"second_name" arguments:@{@"second_name_key":@"second_name_value"}];
    [self presentViewController:fvc animated:YES completion:nil];
    self.fvc = fvc;
}

- (void)xx{

    self.presentChannel = [FlutterMethodChannel methodChannelWithName:@"enfry.flutter.io/enfry_present" binaryMessenger:self.fvc];
    __weak typeof(self) weakSelf = self;
    // 注册方法等待flutter页面调用
    [self.presentChannel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
        NSLog(@"%@", call.method);
        NSLog(@"%@", result);
        
        if ([call.method isEqualToString:@"getNativeResult"]) {
            NSString *name = [weakSelf getDeiveName];
            if (name == nil) {
                FlutterError *error = [FlutterError errorWithCode:@"UNAVAILABLE" message:@"Device info unavailable" details:nil];
                result(error);
            } else {
                result(name);
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                // 原生调用Flutter方法，带参数, 接收回传结果
                [weakSelf queryFlutterInfor];
            });
        } else if ([call.method isEqualToString:@"dismiss"]) {
            [weakSelf.fvc dismissViewControllerAnimated:YES completion:nil];
        } else if ([call.method isEqualToString:@"presentNativeSecondPage"]) {
//            NativeSecondVC *secondVC = [[NativeSecondVC alloc] init];
//            secondVC.modalPresentationStyle = UIModalPresentationFullScreen;
//            [self.fvc presentViewController:secondVC animated:YES completion:nil];
        } else {
            result(FlutterMethodNotImplemented);
        }
    }];
}

- (void)queryFlutterInfor{
    [self.presentChannel invokeMethod:@"flutterMedia" arguments:@{@"key1": @"value1"} result:^(id  _Nullable result) {
        NSLog(@"%@", result);
        [self showAlert:result];
    }];
}

- (void)showAlert:(NSString *)message {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"Flutter返回" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
    [alertVC addAction:defaultAction];
    [self.fvc presentViewController:alertVC animated:YES completion:nil];
}

- (void)pushFlutterPage:(UIButton *)sender
{
    FLBFlutterViewController *fvc = FLBFlutterViewController.new;
    [fvc setName:@"push1" params:@{@"first_name_key1":@"first_name_value1"}];
    [FlutterBoostPlugin.sharedInstance sendEvent:@"first_name" arguments:@{@"first_name_key":@"first_name_value"}];    
    [[AppDelegate appDelegate].pRouter.navigationController pushViewController:fvc animated:YES];
}

- (UIButton *)presFPageBtn
{
    if(!_presFPageBtn){
        _presFPageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_presFPageBtn setTitle:@"原生present->Flutter页面" forState:UIControlStateNormal];
        [_presFPageBtn addTarget:self action:@selector(presentFlutterPage:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _presFPageBtn;
}

- (UIButton *)pushFPageBtn
{
    if(!_pushFPageBtn){
        _pushFPageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pushFPageBtn setTitle:@"原生push->Flutter页面" forState:UIControlStateNormal];
        [_pushFPageBtn addTarget:self action:@selector(pushFlutterPage:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pushFPageBtn;
}

@end
