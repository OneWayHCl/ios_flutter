//
//  AppDelegate.m
//  MyApp
//
//  Created by HCl on 2021/2/3.
//

#import "AppDelegate.h"
//#import <FlutterPluginRegistrant/GeneratedPluginRegistrant.h>
#import "PlatformRouterImp.h"
#import <flutter_boost/FlutterBoost.h>

@interface AppDelegate ()
@property (strong, nonatomic) PlatformRouterImp* pRouter;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.pRouter = [PlatformRouterImp new];
    [FlutterBoostPlugin.sharedInstance startFlutterWithPlatform:self.pRouter onStart:^(FlutterEngine *engine) {}];
    return YES;
}

+ (AppDelegate *)appDelegate
{
    AppDelegate *delegate = (id)[UIApplication sharedApplication].delegate;
    if ([delegate isKindOfClass:[AppDelegate class]]) {
        return delegate;
    }
    return nil;
}

#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
