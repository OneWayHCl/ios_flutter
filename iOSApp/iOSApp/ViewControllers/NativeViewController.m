//
//  NativeViewController.m
//  iOSApp
//
//  Created by HCl on 2021/2/26.
//

#import "NativeViewController.h"
#import <flutter_boost/FlutterBoost.h>
#import "FLBFlutterViewController.h"

@interface NativeViewController ()

@end

@implementation NativeViewController

- (instancetype)initWithParams:(NSDictionary *)params
{
    if (self = [super init]) {
        NSLog(@"%@", params);
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"原生页面";
    
    if (self.navigationController != nil && self.navigationItem.leftBarButtonItem == nil) {
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
        self.navigationItem.leftBarButtonItem = backItem;
    }
}

- (void)backAction
{
    if (self.navigationController != nil) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)backClick:(id)sender
{
//    [self backAction];
    [FlutterBoostPlugin.sharedInstance sendEvent:@"native-flutter" arguments:@{@"first_name_key":@"xxxxx"}];
}

- (IBAction)push2flutter:(id)sender
{
    FLBFlutterViewController *fvc = FLBFlutterViewController.new;
    [fvc setName:@"push1" params:@{@"first_name_key1":@"first_name_value1"}];
    [FlutterBoostPlugin.sharedInstance sendEvent:@"first_name" arguments:@{@"first_name_key":@"first_name_value"}];
    [self.navigationController pushViewController:fvc animated:YES];
}

- (IBAction)present2flutter:(id)sender
{
    FLBFlutterViewController *fvc = FLBFlutterViewController.new;
    [fvc setName:@"present1" params:@{@"second_name_key1":@"second_name_value1"}];
    [FlutterBoostPlugin.sharedInstance sendEvent:@"second_name" arguments:@{@"second_name_key":@"second_name_value"}];
    [self presentViewController:fvc animated:YES completion:nil];
}

@end
