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


/*
 * アプリがバックグラウンドになった時に呼ばれる関数 定義済み関数
 */
- (void)applicationDidEnterBackground:(UIApplication *)application
{
  if (self.inWorkFlag == NO) {
    LOG();
    return;//作動中でなければ何もしない。
  }
  
  //現在時をUD領域に保存
  NSDate* nowDate = [NSDate date];
  [[NSUserDefaults standardUserDefaults] setObject:nowDate forKey:@"nowDate"];

  if ([self cntUpFlag]) {
    LOG();
    return;//カウントアップ中の場合 ここまで（現在時取得のみ）
  }
  
  
  //通知イベントの作成
  UILocalNotification *notification = [[UILocalNotification alloc] init];
  
  //残りの秒数を取得してセット
  [self setRemnantSec:[self getRemnamt]];
//  LOG(@"remnantSec=%d",[self remnantSec]);//In Background Sec
  
  //n秒後にメッセージが表示されます
  notification.fireDate = [NSDate dateWithTimeIntervalSinceNow:[self remnantSec]];
  
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
//  notification.soundName = @"piLong30.caf";//30sec within
  
  //ローカル通知イベントの登録
  [[UIApplication sharedApplication] scheduleLocalNotification:notification];
}

/**
 * アプリがバックグラウンドからフォアグラウンドになる直前に呼ばれる関数
 */
- (void)applicationWillEnterForeground:(UIApplication *)application
{
  //バッチをクリア
  [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
  
  //通知をスケジュールをキャンセル
  [[UIApplication sharedApplication] cancelAllLocalNotifications];
  
  if (self.inWorkFlag == NO) {
    return;//作動中でなければ何もしない。
  }
  
  // バックグラウンドに入った時刻取得
  NSDate* oldDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"nowDate"];
//  LOG(@"%@",[oldDate description]);

  //現在時を取得
  NSDate* nowDate = [NSDate date];
//  LOG(@"%@",[nowDate description]);
  
  // 経過時間の差分秒 を取得
  int diffSec = [nowDate timeIntervalSinceDate:oldDate];
//  LOG(@"%d",(int)diffSec);
  
  
  // バックグラウンド前の残秒数 - 経過秒数 がマイナスなら その分をカウントアップ
  if ([self remnantSec] < diffSec) {
    
    [self setCntUpFlag:YES];
    
    diffSec -= [self remnantSec];
    [self setGlobalMin:0];
    [self setGlobalSec:0];
    LOG();
  }

//  LOG(@"diffSec=%d",diffSec);
  
  if ([self cntUpFlag]) {
    [self cntUp:(int)diffSec];
  }else{
    [self cntDn:(int)diffSec];
  }
}



// カウントアップ関数
- (void)cntUp:(int)i
{
  self.globalSec += i;
  
  if (self.globalSec > 59) {
    
    self.globalMin += self.globalSec /60;
    self.globalSec = self.globalSec %60;
    
    if (self.globalMin > 999) {
      self.globalMin = 999;
      self.globalSec = 59;
    }
  }
}


// カウントダウン関数Old
- (void)cntDn:(int)i
{
  //バックグラウンド前の分・秒
//  LOG(@"m=%d s=%d",[self globalMin],[self globalSec]);
  
  self.globalSec -= i;
  
  if (self.globalSec < 0) {
    self.globalMin--;
    
    self.globalMin -= self.globalSec /60;
    //    self.globalSec = 60 + (self.globalSec %60);
    self.globalSec = 60 + (self.globalSec %60);
  }
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