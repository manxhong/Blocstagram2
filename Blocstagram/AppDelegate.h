//
//  AppDelegate.h
//  Blocstagram
//
//  Created by Man Hong Lee on 1/28/15.
//  Copyright (c) 2015 ManHong Lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, assign) int previousTabIndex;
@property (strong, nonatomic) UITabBarController *tabBarController;

@end

