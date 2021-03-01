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

@interface ViewController ()

@property (nonatomic, strong) UIButton *presFPageBtn;
@property (nonatomic, strong) UIButton *pushFPageBtn;

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
}

- (NSString *)getDeiveName {
    UIDevice *device = UIDevice.currentDevice;
    return device.name;
}

- (IBAction)pushAction:(id)sender{}

- (void)presentFlutterPage:(UIButton *)sender
{
    FLBFlutterViewController *fvc = FLBFlutterViewController.new;
    [fvc setName:@"present1" params:@{@"second_name_key1":@"second_name_value1"}];
    [FlutterBoostPlugin.sharedInstance sendEvent:@"second_name" arguments:@{@"second_name_key":@"second_name_value"}];
//    [self.navigationController pushViewController:fvc animated:YES];
    [self presentViewController:fvc animated:YES completion:nil];
}

- (void)pushFlutterPage:(UIButton *)sender
{
    FLBFlutterViewController *fvc = FLBFlutterViewController.new;
    [fvc setName:@"push1" params:@{@"first_name_key1":@"first_name_value1"}];
    [FlutterBoostPlugin.sharedInstance sendEvent:@"first_name" arguments:@{@"first_name_key":@"first_name_value"}];
    [self.navigationController pushViewController:fvc animated:YES];
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
