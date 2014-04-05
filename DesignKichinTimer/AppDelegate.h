//
//  AppDelegate.h
//  DesignKichinTimer
//
//  Created by z on 2013/10/18.
//  Copyright (c) 2013 FoceSystemSolution. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
//@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
- (int)getAppLauchedCount;
- (void)cntUp:(int)i;
- (void)cntDn:(int)i;
//@property (retain, nonatomic) ViewController *viewController;
@property (assign, nonatomic) int globalMin;
@property (assign, nonatomic) int globalSec;
@property (assign, nonatomic) BOOL cntUpFlag;
@end
