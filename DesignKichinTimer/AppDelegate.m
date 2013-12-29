//
//  AppDelegate.m
//  DesignKichinTimer
//
//  Created by z on 2013/10/18.
//  Copyright (c) 2013 FoceSystemSolution. All rights reserved.
//

#import "AppDelegate.h"
//#import "SSGentleAlertView.h"

@implementation AppDelegate


// 起動回数を返す Globalな関数
- (int)getAppLauchedCount
{
  NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
  return (int)[ud integerForKey:@"appLauchedCount"];
}

// 起動回数を保存
- (void)setAppLauchedCount:(int)cnt
{
  NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];

  cnt++;
  
  [ud setInteger:cnt forKey:@"appLauchedCount"];
  [ud synchronize];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  //Sound play setting
  AVAudioSession *audioSession = [AVAudioSession sharedInstance];
  [audioSession setCategory:AVAudioSessionCategorySoloAmbient error:NULL];
  [audioSession setActive:YES error:NULL];
  
  int appLaunchedCountValue = [self getAppLauchedCount];
  
  // 99999回以上はカウントしない。
  if ( appLaunchedCountValue < 99999 ) {
    [self setAppLauchedCount:appLaunchedCountValue];
  }
/*
  if ( appLaunchedCountValue == 5 ) {
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:[NSString stringWithFormat:@"%@",NSLocalizedString(@"AlertTtl", nil)]
                                    message:[NSString stringWithFormat:@"%@",NSLocalizedString(@"AlertMsg", nil)]
                                   delegate:self
                          cancelButtonTitle:[NSString stringWithFormat:@"%@",NSLocalizedString(@"AlertNG", nil)]
                          otherButtonTitles:[NSString stringWithFormat:@"%@",NSLocalizedString(@"AlertOK", nil)],nil];
    [alertView show];
  }
*/  
  // Override point for customization after application launch.
  return YES;
}

/*
// アラートのボタンが押された時に呼ばれるデリゲート
-(void)alertView:(UIAlertView*)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex {
  
  //  NSString *reviewURLiOS6 = @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=APPID";
  NSURL *reviewURL = [NSURL URLWithString:[[NSBundle mainBundle] objectForInfoDictionaryKey: @"ReviewURL"]];
  
  switch (buttonIndex) {
    case 0: // キャンセル (なにもしない)
      //      NSLog(@"buttonIndex = %d", (int)buttonIndex);
      break;
      
    case 1:
      //      NSLog(@"buttonIndex = %d", (int)buttonIndex);
      
      [[UIApplication sharedApplication] openURL:reviewURL];
      
      break;
  }
}
*/




- (void)applicationWillResignActive:(UIApplication *)application
{
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
