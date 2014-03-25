//
//  AppDelegate.m
//  DesignKichinTimer
//
//  Created by z on 2013/10/18.
//  Copyright (c) 2013 FoceSystemSolution. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

/**
 * 起動回数を返す Globalな関数
 */
- (int)getAppLauchedCount
{
  NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
  return (int)[ud integerForKey:@"appLauchedCount"];
}

/**
 * 起動回数のカウントアップ
 * 2147483647(=INT_MAX) を超えそうになったら 1 に戻す。-> デフォルトでは、-2147483647に戻る
 */
- (void)setAppLauchedCount
{
  NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
  
  int cnt = (int)[ud integerForKey:@"appLauchedCount"];
  if (cnt == INT_MAX) {
    cnt = 1;
  }
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
  
  [self setAppLauchedCount]; // 起動回数カウントUP

  
  // Override point for customization after application launch.
  return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
  //非アクティブ or 割り込み（電話が掛かってきた時など）
  LOG(@"%s",__func__);
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  //アプリがバックグラウンドになった時
  LOG(@"%s",__func__);
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  //アプリがバックグラウンドからフォアグラウンドになる直前
  LOG(@"%s",__func__);
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  // アプリがアクティブになった時
  LOG(@"%s",__func__);
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  // アプリ終了
  LOG(@"%s",__func__);
}

/*
 - (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
 {
 NSLog(@"connection didFailWithError");
 exit(0);
 
 
 if(error.code==-1009){
 
 exit(0);
 
 }
 
 }
 */

@end
















//