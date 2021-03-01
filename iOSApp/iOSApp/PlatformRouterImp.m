//
//  DemoRouter.m
//  Runner
//
//  Created by Jidong Chen on 2018/10/22.
//  Copyright © 2018年 The Chromium Authors. All rights reserved.
//

#import "PlatformRouterImp.h"
#import <flutter_boost/FlutterBoost.h>
#import "FLBFlutterViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

@interface PlatformRouterImp()
@end

@implementation PlatformRouterImp

- (void)openNativeVC:(NSString *)name
           urlParams:(NSDictionary *)params
                exts:(NSDictionary *)exts{
    UIViewController *vc = nil;
    if (exts && exts[@"ios"]) {
        vc = [NSClassFromString(exts[@"ios"]) new];
    }
    if (!vc) {
        vc = [UIViewController new];
    }
    BOOL animated = YES;
    if (exts) {
        animated = [exts[@"animated"] boolValue];
    }
    NSLog(@"%@", params);
    
    if([params[@"present"] boolValue]){
        [self.navigationController presentViewController:vc animated:animated completion:^{
            
        }];
    }
    else {
        [self.navigationController pushViewController:vc animated:animated];
    }
}

- (UINavigationController *)navigationController
{
    if (!_navigationController) {
        _navigationController = [UIViewController selectedNavigationController];
    }
    return _navigationController;
}

#pragma mark - Boost 1.5
- (void)open:(NSString *)name
   urlParams:(NSDictionary *)params
        exts:(NSDictionary *)exts
  completion:(void (^)(BOOL))completion
{
    if ([name isEqualToString:@"native"]) {//模拟打开native页面
        [self openNativeVC:name urlParams:params exts:exts];
        return;
    }
    BOOL animated = YES;
    if (exts) {
        animated = [exts[@"animated"] boolValue];
    }
    FLBFlutterViewController *vc = FLBFlutterViewController.new;
    [vc setName:name params:params];
    [self.navigationController pushViewController:vc animated:animated];
    if(completion) completion(YES);
}

- (void)present:(NSString *)name
   urlParams:(NSDictionary *)params
        exts:(NSDictionary *)exts
  completion:(void (^)(BOOL))completion
{
    BOOL animated = YES;
    if (exts) {
        animated = [exts[@"animated"] boolValue];
    }
    FLBFlutterViewController *vc = FLBFlutterViewController.new;
    [vc setName:name params:params];
    [self.navigationController presentViewController:vc animated:animated completion:^{
        if(completion) completion(YES);
    }];
}

- (void)close:(NSString *)uid
       result:(NSDictionary *)result
         exts:(NSDictionary *)exts
   completion:(void (^)(BOOL))completion
{
    BOOL animated = YES;
    if (exts) {
        animated = [exts[@"animated"] boolValue];
    }
    FLBFlutterViewController *vc = (id)self.navigationController.presentedViewController;
    if([vc isKindOfClass:FLBFlutterViewController.class] && [vc.uniqueIDString isEqual:uid]){
        [vc dismissViewControllerAnimated:animated completion:^{}];
    }
    else {
        [self.navigationController popViewControllerAnimated:animated];
    }
}
@end
