//
//  ViewController.m
//  DesignKichinTimer
//
//  Created by z on 2013/10/18.
//  Copyright (c) 2013 FoceSystemSolution. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController


// View が表示される直前に呼ばれる定義済み関数（画面が再表示されるたびに呼び出されます。）
- (void)viewWillAppear:(BOOL)animated
{
  // 全体背景枠
  self.view.layer.backgroundColor = [UIColor whiteColor].CGColor;
  self.view.layer.cornerRadius = 50.0;
  self.view.layer.frame = CGRectInset(self.view.layer.frame, 20, 20);
  
  //  self.view.layer.contents = (id)[UIImage imageNamed:@"bg01.jpg"].CGImage;
  //  CALayer *sublayer = [CALayer layer];
  //  sublayer.backgroundColor = [UIColor blueColor].CGColor;
  //  sublayer.shadowOffset = CGSizeMake(0, 3);
  //  sublayer.shadowRadius = 5.0;
  //  sublayer.shadowColor = [UIColor blackColor].CGColor;
  //  sublayer.shadowOpacity = 0.8;
  //  sublayer.frame = CGRectMake(30, 30, 128, 192);
  //  [self.view.layer addSublayer:sublayer];
  
  // 表示エリアの外側デザイン枠
  
  
  
  //カウント表示View生成
  cntView = [[UIView alloc] initWithFrame:CGRectMake([self arignCenter:cntW], 60, cntW, 100)];// x y w h
  [self.view addSubview:cntView];

  
  // カウント表示エリア生成
  sublayer = [CALayer layer];
  //  sublayer.backgroundColor = [UIColor grayColor].CGColor;
  sublayer.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0].CGColor;//薄いグレイ
  sublayer.shadowOffset = CGSizeMake(0, 3);
  sublayer.shadowRadius = 5.0;
  sublayer.shadowColor = [UIColor blueColor].CGColor;
  sublayer.shadowOpacity = 0.8;
//  sublayer.frame = CGRectMake([self arignCenter:cntW], 60, cntW, cntH); // x y w h
  sublayer.frame = CGRectMake(0, 0, cntW, cntH); // x y w h
  sublayer.borderColor = [UIColor colorWithRed:0.5 green:0.5 blue:1.0 alpha:1.0].CGColor;//薄い青
  sublayer.borderWidth = 6.0;
  sublayer.cornerRadius = 10.0;
  [cntView.layer addSublayer:sublayer];
  
  
  // カウント表示Label
  cntLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,cntW,cntH)];// x y w h
  cntLabel.textAlignment = NSTextAlignmentCenter;
  
  cntLabel.text = [NSString stringWithFormat:@"%@",NSLocalizedString(@"AppName", nil)];
  [cntView addSubview:cntLabel];
  
  
  //  CALayer *imageLayer = [CALayer layer];
  //  imageLayer.frame = sublayer.bounds;
  //  imageLayer.cornerRadius = 10.0;
  //  imageLayer.contents = (id) [UIImage imageNamed:@"xxxbg01.jpg"].CGImage;
  //  imageLayer.masksToBounds = YES;
  //  [sublayer addSublayer:imageLayer];
  
  
  //  // ローカライズ Sample
  //  UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(550,550,300,30)]; // x y w h
  //  //  label.text = [NSString stringWithFormat:@"%@",NSLocalizedString(@"AppName", nil)];
  //  label.text = NSLocalizedString(@"AppName", nil);
  //  label.layer.borderWidth = 2.0;
  //  label.layer.borderColor = [UIColor blueColor].CGColor;
  ////  NSLog(@"%@", NSLocalizedString(@"AppName", nil));
  //  [self.view addSubview:label];
}







// デバイスが回転した際に、呼び出されるメソッド(※自作)
- (void) didRotate:(NSNotification *)notification {
  UIDeviceOrientation o = [[notification object] orientation];
  
  // 横向き
  if (o == UIDeviceOrientationLandscapeLeft || o == UIDeviceOrientationLandscapeRight) {
    // Viewの位置とサイズを補正してセット
    cntView.frame = CGRectMake([self arignCenter:cntW], 60, cntW, cntH); // x y w h
    
  // 縦向き
  } else if (o == UIDeviceOrientationPortrait || o == UIDeviceOrientationPortraitUpsideDown) {
    // Viewの位置とサイズを補正してセット
    cntView.frame = CGRectMake([self arignCenter:cntW], 60, cntW, cntH); // x y w h
    
    // 向きが不明な場合
  } else {
    // NSLog(@"device orientation is Unkown.");
  }
}





// 中央寄せ用 X座標算出
- (int)arignCenter:(int)w
{
  //画面情報(横幅)取得
  UIScreen *sc = [UIScreen mainScreen];
  CGRect rect = sc.bounds;
  
  // 現在が横向きの場合の対処
  UIDeviceOrientation o = [UIDevice currentDevice].orientation;
  if (o == UIDeviceOrientationLandscapeLeft || o == UIDeviceOrientationLandscapeRight) {
    //    NSLog(@"height=%f",rect.size.height);
    return ( rect.size.height - w ) / 2; // X座標を返す
  }else{
    //    NSLog(@"width=%f",rect.size.width);
    return ( rect.size.width - w ) / 2; // X座標を返す
  }
}


// View が初めて呼び出される時に1回だけ呼ばれる定義済み関数
- (void)viewDidLoad
{
  [super viewDidLoad];
  
  //画面情報(横幅)取得
  UIScreen *sc = [UIScreen mainScreen];
  CGRect rect = sc.bounds;
  CGFloat screenWidth = rect.size.width;
  CGFloat screenHeight = rect.size.height;
  
  NSLog(@"w=%f h=%f",screenWidth,screenHeight); // ipad mini 768x1024, iphone4s 320x480
  
  // カウンター表示エリアの横幅を定義
  cntW = screenWidth -20;  //300;
  cntH = (screenWidth -20) / 3;
  //cntH = (screenWidth -20) / 1.618; // 黄金比
  
  
  // デバイスの回転をサポート デバイスが回転した際に、呼び出してほしいメソッドを指定
  [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(didRotate:)
                                               name:UIDeviceOrientationDidChangeNotification
                                             object:nil];
  
  
  
  //タイマーのセット（一秒）
  [NSTimer scheduledTimerWithTimeInterval:1.0 //タイマーを発生させる間隔（1.0秒毎）
                                   target:self //メソッドがあるオブジェクト
                                 selector:@selector(driveClock:) //呼び出すメソッド
                                 userInfo:nil //メソッドに渡すパラメータ
                                  repeats:YES]; //繰り返し
  
  
  
}



// 時計(現在時)表示用関数
- (void)driveClock:(NSTimer *)timer
{
  NSDate *today = [NSDate date]; //現在時刻を取得
  NSCalendar *calender = [NSCalendar currentCalendar]; //現在時刻の時分秒を取得
  unsigned flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
  NSDateComponents *todayComponents = [calender components:flags fromDate:today];
  //  int nenn = [todayComponents year];
  //  int tuki = [todayComponents month];
  //  int niti = [todayComponents day];
  //  int weekIndex = [todayComponents weekday];
  
  int hour = [todayComponents hour];
  int min = [todayComponents minute];
  int sec = [todayComponents second];
  
  //  // 年月日,曜日表示
  //  nowDate.text = [NSString stringWithFormat:@"%04d/%02d/%02d (%@)",nenn,tuki,niti,[self stringShortweekday:weekIndex]];
  
  // 時間を表示
  cntLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d",hour,min,sec];
}










- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
