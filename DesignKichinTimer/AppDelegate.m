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


// 残り時間（秒数）を取得
- (int)getRemnamt{
  int ret = 0;
  ret = self.globalMin * 60;
  ret += self.globalSec;
  return ret;
}


- (void)applicationDidEnterBackground:(UIApplication *)application
{
  //アプリがバックグラウンドになった時
  LOG(@"%s",__func__);
  
  //現在時を保存
  NSDate* nowDate = [NSDate date];
  [[NSUserDefaults standardUserDefaults] setObject:nowDate forKey:@"nowDate"];
  
//  UIApplication* app = [UIApplication sharedApplication];
//  LOG(@"%@",app.debugDescription);
//  LOG(@"%@",app.description);
  
  UILocalNotification *notification = [[UILocalNotification alloc] init];
  
  //残りの秒数を取得
  int remnantSec = [self getRemnamt];

  LOG(@"remnantSec=%d",remnantSec);
  
  //n秒後にメッセージが表示されます
  notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:remnantSec];

  //履歴からセットした分秒を取得
  //
  
  //メッセージ内容
//  NSString* msg = [NSString stringWithFormat:@"%d秒経過しました",5];
  NSString* msg = [NSString stringWithFormat:@"セットした時間に達しました"];
  notification.alertBody = msg;
  
  //バッジを表示する事も可能です。この場合、１が表示されます
  notification.applicationIconBadgeNumber = 1;
//  [UIApplication sharedApplication].applicationIconBadgeNumber = 99999;//1~99999まで表示可
  
  //タイムゾーンの設定
  notification.timeZone = [NSTimeZone localTimeZone];
  
  //メッセージ表示時の効果音を設定
  notification.soundName = UILocalNotificationDefaultSoundName;
  
  //ローカル通知の登録
//  [app scheduleLocalNotification:notification];
}


- (void)applicationWillEnterForeground:(UIApplication *)application
{
  //アプリがバックグラウンドからフォアグラウンドになる直前
  LOG(@"%s",__func__);
  
  //バッチをクリア
  [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
  
  //通知をスケジュールをキャンセル
  [[UIApplication sharedApplication] cancelAllLocalNotifications];
  
  
  // 経過時間の計算
  NSDate* oldDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"nowDate"];
  LOG(@"%@",[oldDate description]);

  //現在時を保存
  NSDate* nowDate = [NSDate date];
  float tmp= [nowDate timeIntervalSinceDate:oldDate];
  int hh = (int)(tmp / 3600);
  int mm = (int)((tmp-hh) / 60);
  float ss = tmp - (float)(hh*3600+mm*60);
  
//  NSLog(@"%02d:%02d:%05.2f", hh, mm, ss);
  NSLog(@"%02d:%02d:%03f", hh, mm, ss);

  
  //  self.globalMin = 0;
  //  self.globalSec = 0;
  
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