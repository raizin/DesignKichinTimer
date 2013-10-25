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
  
  NSLog(@"w=%f h=%f",screenWidth,screenHeight); // iphone4s 320x480, ipad mini 768x1024
                                                // iphone5s 320x568
  
  // カウンター表示エリアの横幅を定義
  cntW = screenWidth -20;  //300;
  cntH = (screenWidth -20) / 3;
  //cntH = (screenWidth -20) / 1.618; // 黄金比
  

  
  
  // 全体背景枠
  self.view.layer.backgroundColor = [UIColor whiteColor].CGColor;
  self.view.layer.cornerRadius = 50.0;
  self.view.layer.frame = CGRectInset(self.view.layer.frame, 20, 20);
  
  //  self.view.layer.contents = (id)[UIImage imageNamed:@"bg01.jpg"].CGImage;
  //  CALayer *cntlayer = [CALayer layer];
  //  cntlayer.backgroundColor = [UIColor blueColor].CGColor;
  //  cntlayer.shadowOffset = CGSizeMake(0, 3);
  //  cntlayer.shadowRadius = 5.0;
  //  cntlayer.shadowColor = [UIColor blackColor].CGColor;
  //  cntlayer.shadowOpacity = 0.8;
  //  cntlayer.frame = CGRectMake(30, 30, 128, 192);
  //  [self.view.layer addSublayer:cntlayer];
  
  // 表示エリアの外側デザイン枠
  
  
  
  //カウント表示View生成
  cntView = [[UIView alloc] initWithFrame:CGRectMake([self arignCenter:cntW], 60, cntW, 100)];// x y w h
  [self.view addSubview:cntView];
  
  
  // カウント表示エリア生成
  cntlayer = [CALayer layer];
  //  cntlayer.backgroundColor = [UIColor grayColor].CGColor;
  cntlayer.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0].CGColor;//薄いグレイ
  cntlayer.shadowOffset = CGSizeMake(0, 3);
  cntlayer.shadowRadius = 5.0;
  cntlayer.shadowColor = [UIColor blueColor].CGColor;
  cntlayer.shadowOpacity = 0.8;
  //  cntlayer.frame = CGRectMake([self arignCenter:cntW], 60, cntW, cntH); // x y w h
  cntlayer.frame = CGRectMake(0, 0, cntW, cntH); // x y w h
  cntlayer.borderColor = [UIColor colorWithRed:0.5 green:0.5 blue:1.0 alpha:1.0].CGColor;//薄い青
  cntlayer.borderWidth = 6.0;
  cntlayer.cornerRadius = 10.0;
  [cntView.layer addSublayer:cntlayer];
  
  
  // カウント表示Label
  cntLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,cntW,cntH)];// x y w h
  cntLabel.textAlignment = NSTextAlignmentCenter;
  cntLabel.adjustsFontSizeToFitWidth = YES;
//  cntLabel.autoresizesSubviews = YES; //
//  cntLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight; // w h
//  cntLabel.contentMode = UIViewContentModeCenter;
  cntLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0.5 alpha:0];
  cntLabel.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.8];
//  cntLabel.text = [NSString stringWithFormat:@"%@",NSLocalizedString(@"AppName", nil)];
  cntLabel.text = nil;
  
  // 表示フォントサイズ ipad:185 iphone:70  = 6 digits + "M S"
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
    //NSLog(@"iPhoneの処理");
    cntLabel.font = [UIFont systemFontOfSize:70];
  }
  else{
    //NSLog(@"iPadの処理");
    cntLabel.font = [UIFont systemFontOfSize:185];
  }
  [cntView addSubview:cntLabel];
  
  
  //  CALayer *imageLayer = [CALayer layer];
  //  imageLayer.frame = cntlayer.bounds;
  //  imageLayer.cornerRadius = 10.0;
  //  imageLayer.contents = (id) [UIImage imageNamed:@"xxxbg01.jpg"].CGImage;
  //  imageLayer.masksToBounds = YES;
  //  [cntlayer addSublayer:imageLayer];
  
  
  //  // ローカライズ Sample
  //  UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(550,550,300,30)]; // x y w h
  //  //  label.text = [NSString stringWithFormat:@"%@",NSLocalizedString(@"AppName", nil)];
  //  label.text = NSLocalizedString(@"AppName", nil);
  //  label.layer.borderWidth = 2.0;
  //  label.layer.borderColor = [UIColor blueColor].CGColor;
  ////  NSLog(@"%@", NSLocalizedString(@"AppName", nil));
  //  [self.view addSubview:label];
  
  
  // ボタン配置
//  int btnW = 50;
  
  setBtn01 = [UIButton buttonWithType:UIButtonTypeCustom];
//  setBtn01.frame = CGRectMake(([self arignCenter:btnW] - 50),50,50,450);// x y w h
  setBtn01.frame = CGRectMake(500,500,100,50);// x y w h
//  setBtn01.titleLabel.text = @"hoge";
  [setBtn01 setTitle:@"1min" forState:UIControlStateNormal];
  [[setBtn01 layer] setBackgroundColor:
   [[UIColor colorWithRed:0.9 green:0.9 blue:0.0 alpha:0.6] CGColor]];
  
  
  [setBtn01 setTitleColor:[UIColor blueColor] forState:UIControlStateNormal]; //有効時
  [setBtn01 setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted]; //ハイライト時
  [setBtn01 setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled]; //無効時

  
//  [setBtn addTarget:self action:@selector(moveSettingView) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:setBtn01];
  
  
  
  
  
  
  
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
