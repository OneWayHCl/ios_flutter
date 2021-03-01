//
//  FLBFlutterViewController.m
//  Enfry
//
//  Created by HCl on 2021/2/25.
//  Copyright © 2021 enfry. All rights reserved.
//

#import "FLBFlutterViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"

@interface FLBFlutterViewController ()

@end

@implementation FLBFlutterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.fd_prefersNavigationBarHidden = YES;
}

@end
