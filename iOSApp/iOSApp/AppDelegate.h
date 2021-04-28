//
//  AppDelegate.h
//  MyApp
//
//  Created by HCl on 2021/2/3.
//

#import <UIKit/UIKit.h>
#import "PlatformRouterImp.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, readonly) PlatformRouterImp *pRouter;

+ (AppDelegate *)appDelegate;
@end

