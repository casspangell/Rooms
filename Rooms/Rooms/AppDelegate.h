//
//  AppDelegate.h
//  Rooms
//
//  Created by Cass Pangell on 7/28/14.
//  Copyright (c) 2014 mondolabs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@class ViewController;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (weak, nonatomic) ViewController *MainController;
@property (strong, nonatomic) UIWindow *window;

@end
