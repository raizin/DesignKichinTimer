//
//  ViewController.m
//  DesignKichinTimer
//
//  Created by z on 2013/10/18.
//  Copyright (c) 2013 FoceSystemSolution. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>

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
  
  //X軸の中心を取得
  int centerPoint = [self arignCenter:0];

  // Viewの位置とサイズを補正してセット
  cntView.frame     = CGRectMake([self arignCenter:cntW], 60, cntW, cntH); // x y w h
  setBtn10.frame    = CGRectMake(centerPoint -170 -200, 400, 170, 100); // x y w h
  setBtn05.frame    = CGRectMake(centerPoint  -170 -10, 400, 170, 100); // x y w h
  setBtn03.frame    = CGRectMake(centerPoint       +10, 400, 170, 100); // x y w h
  setBtn01.frame    = CGRectMake(centerPoint      +200, 400, 170, 100); // x y w h
  setBtnReset.frame = CGRectMake(centerPoint -190 -115, 550, 190, 110); // x y w h
  setBtn001.frame   = CGRectMake(centerPoint  -(170/2), 550, 170, 100); // x y w h
  setBtnStart.frame = CGRectMake(centerPoint      +115, 550, 190, 110); // x y w h

  
  
  
  
  // 横向き
  if (o == UIDeviceOrientationLandscapeLeft || o == UIDeviceOrientationLandscapeRight) {

  // 縦向き
  } else if (o == UIDeviceOrientationPortrait || o == UIDeviceOrientationPortraitUpsideDown) {
    
    // 向きが不明な場合
  } else {
    // NSLog(@"device orientation is Unkown.");
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
  
  
  //カウント表示View生成
  cntView = [[UIView alloc] initWithFrame:CGRectMake([self arignCenter:cntW], 60, cntW, cntH)];// x y w h
  [self.view addSubview:cntView];
  
  
  // カウント表示エリア生成
  cntlayer = [CALayer layer];
  cntlayer.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0].CGColor;//薄いグレイ
  cntlayer.frame = CGRectMake(0, 0, cntW, cntH); // x y w h
  cntlayer.borderColor = [UIColor colorWithRed:0.5 green:0.5 blue:1.0 alpha:1.0].CGColor;//薄い青
  cntlayer.borderWidth = 7.0;
  cntlayer.cornerRadius = 10.0;
  [cntView.layer addSublayer:cntlayer];

  
  // Viewの表示順序を設定
  //  [cntView bringSubviewToFront:cntlayer]; //最前面
  //  [self.view sendSubviewToBack:nowTimeView]; //最背面

  
  // カウント表示Label
  cntLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,cntW,cntH)];// x y w h
  cntLabel.textAlignment = NSTextAlignmentCenter;
  cntLabel.adjustsFontSizeToFitWidth = YES;
  cntLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0.5 alpha:0]; //
  cntLabel.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.8]; // Light Gray
  cntLabel.text = nil;
  
  // 表示フォントサイズ ipad:180 iphone:70  = 6 digits + "M S"
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
    //NSLog(@"iPhoneの処理");
    cntLabel.font = [UIFont systemFontOfSize:70];
  }
  else{
    //NSLog(@"iPadの処理");
    cntLabel.font = [UIFont systemFontOfSize:180];
  }
  [cntView addSubview:cntLabel];
  
  [self _addDropShadowToView:cntView]; // 内影生成
  

  
  //ボタン内文字列用 影の定義 1:blue 2:red 3:gray
  NSShadow *shadow1 = [[NSShadow alloc] init];
  shadow1.shadowOffset = CGSizeMake(1.f, 1.f);
  shadow1.shadowColor = [UIColor blueColor];
  shadow1.shadowBlurRadius = 5.f;
  NSDictionary *attr1 = @{NSShadowAttributeName:shadow1,NSForegroundColorAttributeName:[UIColor blueColor]};

  NSShadow *shadow2 = [[NSShadow alloc] init];
  shadow2.shadowOffset = CGSizeMake(1.f, 1.f);
  shadow2.shadowColor = [UIColor redColor];
  shadow2.shadowBlurRadius = 5.f;
  NSDictionary *attr2 = @{NSShadowAttributeName:shadow2,NSForegroundColorAttributeName:[UIColor redColor]};
  
  NSShadow *shadow3 = [[NSShadow alloc] init];
  shadow3.shadowOffset = CGSizeMake(1.f, 1.f);
  shadow3.shadowColor = [UIColor grayColor];
  shadow3.shadowBlurRadius = 5.f;
  NSDictionary *attr3 = @{NSShadowAttributeName:shadow3,NSForegroundColorAttributeName:[UIColor grayColor]};

  
  /*** 表示切り替え(ボタン)配置 ***/
  
  // 表示位置(高さ)分岐 iphone ipad
  int selecterY = 7;
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
    selecterY = -42;
  }
  
  NSString *clockTitle = [NSString stringWithFormat:@"%@",NSLocalizedString(@"btnClock", nil)];
  UIButton *clockSelectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  clockSelectBtn.frame = CGRectMake(15,selecterY,120,50);// x y w h
  
  NSAttributedString *attrClockTitle3 = [[NSAttributedString alloc] initWithString:clockTitle attributes:attr3];
  [clockSelectBtn setAttributedTitle:attrClockTitle3 forState:UIControlStateNormal]; // 有効時
  
  NSAttributedString *attrClockTitle2 = [[NSAttributedString alloc] initWithString:clockTitle attributes:attr2];
  [clockSelectBtn setAttributedTitle:attrClockTitle2 forState:UIControlStateHighlighted]; // タッチ中
  
  NSAttributedString *attrClockTitle1 = [[NSAttributedString alloc] initWithString:clockTitle attributes:attr1];
  [clockSelectBtn setAttributedTitle:attrClockTitle1 forState:UIControlStateDisabled]; // 無効時
  
  [cntView addSubview:clockSelectBtn];
  
  [clockSelectBtn setEnabled:NO];// default

  
  
  NSString *timerTitle = [NSString stringWithFormat:@"%@",NSLocalizedString(@"btnTimer", nil)];
  UIButton *timerSelectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  timerSelectBtn.frame = CGRectMake(145,selecterY,135,50);// x y w h

  NSAttributedString *attrTimerTitle3 = [[NSAttributedString alloc] initWithString:timerTitle attributes:attr3];
  [timerSelectBtn setAttributedTitle:attrTimerTitle3 forState:UIControlStateNormal]; // 有効時
  
  NSAttributedString *attrTimerTitle2 = [[NSAttributedString alloc] initWithString:timerTitle attributes:attr2];
  [timerSelectBtn setAttributedTitle:attrTimerTitle2 forState:UIControlStateHighlighted]; // タッチ中

  NSAttributedString *attrTimerTitle1 = [[NSAttributedString alloc] initWithString:timerTitle attributes:attr1];
  [timerSelectBtn setAttributedTitle:attrTimerTitle1 forState:UIControlStateDisabled]; // 無効時

  [cntView addSubview:timerSelectBtn];
  
  
  

  //X軸の中心を取得
  int centerPoint = [self arignCenter:0];
  NSLog(@"%d",centerPoint);
  
  setBtn10 = [UIButton buttonWithType:UIButtonTypeCustom];
  [setBtn10 setTitle:[NSString stringWithFormat:@"%@",NSLocalizedString(@"btn10", nil)] forState:UIControlStateNormal];
  [setBtn10.titleLabel setFont:[UIFont boldSystemFontOfSize:50]];
  [self myBtnCreate:setBtn10];

  setBtn05 = [UIButton buttonWithType:UIButtonTypeCustom];
  [setBtn05 setTitle:[NSString stringWithFormat:@"%@",NSLocalizedString(@"btn05", nil)] forState:UIControlStateNormal];
  [setBtn05.titleLabel setFont:[UIFont boldSystemFontOfSize:50]];
  [self myBtnCreate:setBtn05];
 
  setBtn03 = [UIButton buttonWithType:UIButtonTypeCustom];
  [setBtn03 setTitle:[NSString stringWithFormat:@"%@",NSLocalizedString(@"btn03", nil)] forState:UIControlStateNormal];
  [setBtn03.titleLabel setFont:[UIFont boldSystemFontOfSize:50]];
  [self myBtnCreate:setBtn03];

  setBtn01 = [UIButton buttonWithType:UIButtonTypeCustom];
  [setBtn01 setTitle:[NSString stringWithFormat:@"%@",NSLocalizedString(@"btn01", nil)] forState:UIControlStateNormal];
  [setBtn01.titleLabel setFont:[UIFont boldSystemFontOfSize:50]];
  [self myBtnCreate:setBtn01];

  
  setBtnReset = [UIButton buttonWithType:UIButtonTypeCustom];
  NSString *_StopReset = [NSString stringWithFormat:@"%@",NSLocalizedString(@"btnReset", nil)];
  NSMutableString *str= [NSMutableString stringWithCapacity:1];
  [str appendFormat:@"%@\n",[_StopReset substringWithRange:NSMakeRange(0,4)]];
  //  [str appendString:[_StopReset substringWithRange: NSMakeRange(3,[_StopReset length]-1)]];
  [str appendString:[_StopReset substringWithRange: NSMakeRange(4,[_StopReset length]-4)]];
  ((UILabel*)setBtnReset).lineBreakMode = NSLineBreakByWordWrapping; // 改行モードON
  [setBtnReset setTitle:str forState:UIControlStateNormal];
  [setBtnReset.titleLabel setFont:[UIFont boldSystemFontOfSize:25]];
  [self myBtnCreate:setBtnReset];
  
  setBtn001 = [UIButton buttonWithType:UIButtonTypeCustom];
  [setBtn001 setTitle:[NSString stringWithFormat:@"%@",NSLocalizedString(@"btn001", nil)] forState:UIControlStateNormal];
  [setBtn001.titleLabel setFont:[UIFont boldSystemFontOfSize:50]];
  [self myBtnCreate:setBtn001];

  setBtnStart = [UIButton buttonWithType:UIButtonTypeCustom];
  [setBtnStart setTitle:[NSString stringWithFormat:@"%@",NSLocalizedString(@"btnStart", nil)] forState:UIControlStateNormal];
  [setBtnStart.titleLabel setFont:[UIFont boldSystemFontOfSize:25]];
  [self myBtnCreate:setBtnStart];

  
  
  
  
  
  
  
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



/*
 * ボタン生成関数
 */
- (void)myBtnCreate:(id)sender
{
  UIButton *myBtn = (UIButton *)sender;
  [myBtn setBackgroundColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.0 alpha:0.8]];
  [myBtn.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
  [myBtn.layer setBorderWidth:1.0f];
  [myBtn.layer setCornerRadius:50.0f]; // iphone:25 ipad:50
  [myBtn.layer setShadowOpacity:0.5f];
  [myBtn.layer setShadowOffset:CGSizeMake(2, 2)];
  
  [myBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal]; //有効時
  [myBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted]; //タッチ(ハイライト？)時
  [myBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled]; //無効時
  
  [myBtn addTarget:self action:@selector(myBtnTouchDown:) forControlEvents:UIControlEventTouchDown]; // タッチ中 イベント
  [myBtn addTarget:self action:@selector(myBtnTouchUpInside:) forControlEvents:UIControlEventTouchUpInside]; // タッチリリース時
  [self.view addSubview:myBtn];
}



/*
 * ボタン押下時にボタンを下に少しずらす
 */
- (void)myBtnTouchDown:(id)sender
{
  UIButton *btnView   = (UIButton *)sender;
  btnView.layer.frame = CGRectMake(btnView.layer.frame.origin.x+3, btnView.layer.frame.origin.y+3, btnView.frame.size.width, btnView.frame.size.height);
  [btnView setBackgroundColor:[UIColor brownColor]];
}

/*
 * ボタンを押し離した時にボタンを元に戻す
 */
- (void)myBtnTouchUpInside:(id)sender
{
  UIButton *btnView   = (UIButton *)sender;
  btnView.layer.frame = CGRectMake(btnView.layer.frame.origin.x-3, btnView.layer.frame.origin.y-3, btnView.frame.size.width, btnView.frame.size.height);
  [btnView setBackgroundColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.0 alpha:0.8]];

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





// L字型(『)の内影
- (void)_addDropShadowToView:(UIView*)toView
{
  CALayer* subLayer = [CALayer layer];
  subLayer.frame = toView.bounds;
  [toView.layer addSublayer:subLayer];
  subLayer.masksToBounds = YES;
  
  CGSize size = subLayer.bounds.size;
  CGFloat x = 3.0;
  CGFloat y = 3.0;
  CGMutablePathRef pathRef = CGPathCreateMutable(); // polygon create

  CGPathMoveToPoint(pathRef, NULL, x, y); // start

  x += size.width - 5.0;
  CGPathAddLineToPoint(pathRef, NULL, x, y); // 1
  
  y += 10.0;
  CGPathAddLineToPoint(pathRef, NULL, x, y); // 2
  
  x -= size.width - 15.0;
  CGPathAddLineToPoint(pathRef, NULL, x, y); // 3
  
  y += size.height - 15.0;
  CGPathAddLineToPoint(pathRef, NULL, x, y); // 4
  
  x -= 5.0;   // (*)10
  CGPathAddLineToPoint(pathRef, NULL, x, y); // 5
  
  y -= 5.0;   // (*)size.height+10
  CGPathAddLineToPoint(pathRef, NULL, x, y); // 6
  
  CGPathAddLineToPoint(pathRef, NULL, 3.0, 3.0); // end
  
  CGPathCloseSubpath(pathRef);
  
  subLayer.shadowOffset = CGSizeMake(0.0, 0.0);
  subLayer.shadowColor = [[UIColor blackColor] CGColor];
  subLayer.shadowOpacity = 0.2; // 不透明度
  subLayer.shadowPath = pathRef;
  
  CGPathRelease(pathRef);
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



- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
