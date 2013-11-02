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
  NSLog(@"%d",centerPoint);


  // Viewの位置とサイズを補正してセット
  cntView.frame = CGRectMake([self arignCenter:cntW], 60, cntW, cntH); // x y w h
  
  
  // 端末によりボタンの配置／大きさの調整
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
    //NSLog(@"iPhoneの処理");
    setBtn10.frame    = CGRectMake(centerPoint -74  -85, 180, 74, 50); // x y w h
    setBtn05.frame    = CGRectMake(centerPoint -74 -3.5, 180, 74, 50); // x y w h
    setBtn03.frame    = CGRectMake(centerPoint     +3.5, 180, 74, 50); // x y w h
    setBtn01.frame    = CGRectMake(centerPoint      +85, 180, 74, 50); // x y w h
    setBtnReset.frame = CGRectMake(centerPoint  -135.0f, 250.0f, 80.0f, 60.0f); // x y w h
    setBtn001.frame   = CGRectMake(centerPoint  -(74/2), 255, 74, 50); // x y w h
    setBtnStart.frame = CGRectMake(centerPoint      +55, 250, 80, 60); // x y w h
  }
  else{
    //NSLog(@"iPadの処理");
    setBtn10.frame    = CGRectMake(centerPoint -170 -200, 400, 170, 100); // x y w h
    setBtn05.frame    = CGRectMake(centerPoint -170  -10, 400, 170, 100); // x y w h
    setBtn03.frame    = CGRectMake(centerPoint       +10, 400, 170, 100); // x y w h
    setBtn01.frame    = CGRectMake(centerPoint      +200, 400, 170, 100); // x y w h
    setBtnReset.frame = CGRectMake(centerPoint -190 -115, 550, 190, 110); // x y w h
    setBtn001.frame   = CGRectMake(centerPoint  -(170/2), 550, 170, 100); // x y w h
    setBtnStart.frame = CGRectMake(centerPoint      +115, 550, 190, 110); // x y w h
  }
  
  

  
  
  
  
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
  self.view.layer.cornerRadius = 50.0f;
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
  
  // 表示フォントサイズ 端末分岐 ipad:180 iphone:70  = 6 digits + "M S"
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
    //NSLog(@"iPhone");
    cntFontSize = 70.0f;
    
  }
  else{
    //NSLog(@"iPad");
    cntFontSize = 180.0f;

  }
  cntLabel.font = [UIFont systemFontOfSize:cntFontSize];

  [cntView addSubview:cntLabel];
  
  [self _addDropShadowToView:cntView]; // 内影生成
  
  
  

  
  
  
  
  /*** 表示切り替え(ボタン)配置 ***/
  
  // 表示位置(高さ)分岐 iphone ipad
  int selecterY = 7;
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
    selecterY = -42;
  }
  
  // ====== 「現在時表示」ボタン（リンクテキスト風）ここから ======
  NSString *clockTitle = [NSString stringWithFormat:@"%@",NSLocalizedString(@"btnClock", nil)];
  clockSelectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  clockSelectBtn.frame = CGRectMake(15,selecterY,120,50);// x y w h
  
  [clockSelectBtn setAttributedTitle:[self myColorShadowAttr:[UIColor grayColor] btnTitle:clockTitle] forState:UIControlStateNormal]; // 有効時
  [clockSelectBtn setAttributedTitle:[self myColorShadowAttr:[UIColor redColor] btnTitle:clockTitle] forState:UIControlStateHighlighted]; // タッチ中
  [clockSelectBtn setAttributedTitle:[self myColorShadowAttr:[UIColor blueColor] btnTitle:clockTitle] forState:UIControlStateDisabled]; // 無効時
  
  [cntView addSubview:clockSelectBtn];
  
  [clockSelectBtn addTarget:self action:@selector(clockSelectBtnTouchUpInside:) forControlEvents:UIControlEventTouchUpInside]; // タッチリリース時
  
  // ====== 「現在時表示」ボタン（リンクテキスト風）ここまで ======

  
  
  
  // ====== 「タイマー設定」ボタン（リンクテキスト風）ここから ======
  NSString *timerTitle = [NSString stringWithFormat:@"%@",NSLocalizedString(@"btnTimer", nil)];
  timerSelectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  timerSelectBtn.frame = CGRectMake(145,selecterY,135,50); // x y w h
  
  [timerSelectBtn setAttributedTitle:[self myColorShadowAttr:[UIColor grayColor] btnTitle:timerTitle] forState:UIControlStateNormal]; // 有効時
  [timerSelectBtn setAttributedTitle:[self myColorShadowAttr:[UIColor redColor] btnTitle:timerTitle] forState:UIControlStateHighlighted]; // タッチ中
  [timerSelectBtn setAttributedTitle:[self myColorShadowAttr:[UIColor blueColor] btnTitle:timerTitle] forState:UIControlStateDisabled]; // 無効時
  
  [cntView addSubview:timerSelectBtn];

  [timerSelectBtn setEnabled:NO]; // default
  
  [timerSelectBtn addTarget:self action:@selector(timerSelectBtnTouchUpInside:) forControlEvents:UIControlEventTouchUpInside]; // タッチリリース時

  // ====== 「タイマー設定」ボタン（リンクテキスト風）ここまで ======
  
  
  
  
  // 表示フォントサイズ 端末分岐 ipad:50 iphone:20
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
    //NSLog(@"iPhoneの処理");
    btnFontSize = 25.0f;
  }
  else{
    //NSLog(@"iPadの処理");
    btnFontSize = 50.0f;
  }
  
  
  setBtn10 = [UIButton buttonWithType:UIButtonTypeCustom];
  [self myMutableBtnCreate:setBtn10 btnNum:10 minFlag:YES];
  
  setBtn05 = [UIButton buttonWithType:UIButtonTypeCustom];
  [self myMutableBtnCreate:setBtn05 btnNum:5 minFlag:YES];
  
  setBtn03 = [UIButton buttonWithType:UIButtonTypeCustom];
  [self myMutableBtnCreate:setBtn03 btnNum:3 minFlag:YES];
  
  setBtn01 = [UIButton buttonWithType:UIButtonTypeCustom];
  [self myMutableBtnCreate:setBtn01 btnNum:1 minFlag:YES];

  
  setBtnReset = [UIButton buttonWithType:UIButtonTypeCustom];
  NSString *_btnReset = [NSString stringWithFormat:@"%@",NSLocalizedString(@"btnReset", nil)];
  NSMutableString *__btnReset = [NSMutableString stringWithCapacity:1.0f];
  [__btnReset appendFormat:@"%@\n",[_btnReset substringWithRange:NSMakeRange(0,4)]];
  [__btnReset appendString:[_btnReset substringWithRange: NSMakeRange(4,[_btnReset length]-4)]];
  ((UILabel*)setBtnReset).lineBreakMode = NSLineBreakByWordWrapping; // 改行モードON
  [setBtnReset setTitle:__btnReset forState:UIControlStateNormal];
  [setBtnReset.titleLabel setFont:[UIFont boldSystemFontOfSize:btnFontSize/2]];
  [self myBtnCreate:setBtnReset];
  
  
  setBtn001 = [UIButton buttonWithType:UIButtonTypeCustom];
  [self myMutableBtnCreate:setBtn001 btnNum:10 minFlag:NO];

  
  setBtnStart = [UIButton buttonWithType:UIButtonTypeCustom];
  [setBtnStart setTitle:[NSString stringWithFormat:@"%@",NSLocalizedString(@"btnStart", nil)] forState:UIControlStateNormal];
  [setBtnStart.titleLabel setFont:[UIFont boldSystemFontOfSize:btnFontSize/2]];
  [self myBtnCreate:setBtnStart];

  
  
  
  // デバイスの回転をサポート デバイスが回転した際に、呼び出してほしいメソッドを指定
  [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(didRotate:)
                                               name:UIDeviceOrientationDidChangeNotification
                                             object:nil];
  
  
  
  
  [self timerInitDisp];
  
}


/*
 * 現在時表示用タイマー開始関数
 */
- (void)startClockTimer {
  clockTm = [NSTimer scheduledTimerWithTimeInterval:1.f //タイマーを発生させる間隔（1.0秒毎）
                                              target:self //メソッドがあるオブジェクト
                                            selector:@selector(driveClock:) //呼び出すメソッド
                                            userInfo:nil //メソッドに渡すパラメータ
                                              repeats:YES]; //繰り返し
}
/*
 * 現在時表示用タイマー停止関数
 */
- (void)stopClockTimer {
  if ([clockTm isValid]) {
    [clockTm invalidate];
  }
  cntLabel.text = @""; // 表示テキストもクリア
}


/*
 * 「タイマー設定」「現在時表示」切り替え ボタン内文字列用 影の定義関数
 */
- (NSAttributedString*)myColorShadowAttr:(UIColor*)clr btnTitle:(NSString*)lb
{
  NSShadow *shadow = [[NSShadow alloc] init];
  shadow.shadowOffset = CGSizeMake(1.0f, 1.0f);
  shadow.shadowColor = clr;
  shadow.shadowBlurRadius = 5.0f;
  NSDictionary *attr = @{NSShadowAttributeName:shadow,NSForegroundColorAttributeName:clr};
  
  NSAttributedString *attrTitle = [[NSAttributedString alloc] initWithString:lb attributes:attr];

  return attrTitle;
}


/*
 * 「現在時表示」ボタン用イベント
 */
- (void)clockSelectBtnTouchUpInside:(id)sender
{
  [clockSelectBtn setEnabled:NO];
  [timerSelectBtn setEnabled:YES];

  //すべてのボタンをDisableにする
  [setBtn60 setEnabled:NO];
  [setBtn10 setEnabled:NO];
  [setBtn05 setEnabled:NO];
  [setBtn03 setEnabled:NO];
  [setBtn01 setEnabled:NO];
  [setBtn001 setEnabled:NO];
  [setBtn0001 setEnabled:NO];
  [setBtnStart setEnabled:NO];
  [setBtnReset setEnabled:NO];

  //タイマーモード用ラベルクリア
  hunLabel.text = @"";
  byoLabel.text = @"";
  cntLabel.text = @"";

  //現在時表示用タイマー開始
  [self startClockTimer];

 
  
}

/*
 * 「タイマー設定」ボタン用イベント
 */
- (void) timerSelectBtnTouchUpInside:(id)sender
{
  [clockSelectBtn setEnabled:YES];
  [timerSelectBtn setEnabled:NO];
  
  //すべてのボタンをEnableにする
  [setBtn60 setEnabled:YES];
  [setBtn10 setEnabled:YES];
  [setBtn05 setEnabled:YES];
  [setBtn03 setEnabled:YES];
  [setBtn01 setEnabled:YES];
  [setBtn001 setEnabled:YES];
  [setBtn0001 setEnabled:YES];
  [setBtnStart setEnabled:YES];
  [setBtnReset setEnabled:YES];

  //現在時表示用タイマー停止(クリア)
  [self stopClockTimer];
  
  // 初期状態表示
  [self timerInitDisp];
  
  
}

- (void)timerInitDisp {

  // キッチンタイマー用 初期表示
  cntLabel.text = @"00 00";
  [cntLabel.layer setShadowOpacity:0.5f];
  [cntLabel.layer setShadowOffset:CGSizeMake(2.f, 2.f)];
  
  //分・秒のラベルを作成して表示
  hunLabel = [[UILabel alloc] initWithFrame:CGRectMake(345,60,45,45)];// x y w h
  hunLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:30.f];
  hunLabel.textAlignment = NSTextAlignmentCenter;
  hunLabel.adjustsFontSizeToFitWidth = YES;
  hunLabel.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.8]; // Light Black
  hunLabel.text = [NSString stringWithFormat:@"%@",NSLocalizedString(@"hunn", nil)];
  //  hunLabel.backgroundColor= [UIColor colorWithRed:0.0 green:0.5 blue:0.5 alpha:0.3];
  [hunLabel.layer setShadowOpacity:0.5f];
  [hunLabel.layer setShadowOffset:CGSizeMake(2.f, 2.f)];
  [cntView addSubview:hunLabel];
  
  byoLabel = [[UILabel alloc] initWithFrame:CGRectMake(590,60,45,45)];// x y w h
  byoLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:30.f];
  byoLabel.textAlignment = NSTextAlignmentCenter;
  byoLabel.adjustsFontSizeToFitWidth = YES;
  byoLabel.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.8]; // Light Black
  byoLabel.text = [NSString stringWithFormat:@"%@",NSLocalizedString(@"byoo", nil)];
  //  byoLabel.backgroundColor= [UIColor colorWithRed:0.0 green:0.5 blue:0.5 alpha:0.3];
  [byoLabel.layer setShadowOpacity:0.5f];
  [byoLabel.layer setShadowOffset:CGSizeMake(2.f, 2.f)];
  [cntView addSubview:byoLabel];

}


/*
 * ボタンタイトル(文字列)生成関数
 */
- (NSMutableAttributedString*)myBtnColorCtl:(UIColor*)cl btnNum:(NSInteger)num unit:(NSString*)unit
{
  NSDictionary *fontDigit = @{ NSForegroundColorAttributeName:cl,
                               NSFontAttributeName : [UIFont boldSystemFontOfSize:btnFontSize] };
  NSDictionary *fontUnit = @{ NSForegroundColorAttributeName:cl,
                              NSFontAttributeName : [UIFont boldSystemFontOfSize:btnFontSize/1.5f] };
  
  
  NSAttributedString *btnPlusLabel = [[NSAttributedString alloc]
                                      initWithString:@"＋"
                                      attributes:fontUnit];
  NSAttributedString *btnDigiLabel = [[NSAttributedString alloc]
                                      initWithString:[NSString stringWithFormat:@"%d",num]
                                      attributes:fontDigit];
  NSAttributedString *btnUnitLabel = [[NSAttributedString alloc]
                                      initWithString:unit
                                      attributes:fontUnit];
  
  NSMutableAttributedString *_btn = [[NSMutableAttributedString alloc] initWithAttributedString:btnPlusLabel];//Total String
  [_btn appendAttributedString:btnDigiLabel];
  [_btn appendAttributedString:btnUnitLabel];
  
  return _btn;
}

/*
 * ボタン生成関数
 */
- (void)myMutableBtnCreate:(id)sender btnNum:(NSInteger)num minFlag:(BOOL)unitFlag
{
  UIButton *myBtn = (UIButton *)sender;
  [myBtn setBackgroundColor:[UIColor colorWithRed:0.9f green:0.9f blue:0.f alpha:0.8f]];
  [myBtn.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
  [myBtn.layer setBorderWidth:1.f];
  
  NSString *unit = [NSString stringWithFormat:@"%@",NSLocalizedString(@"hun", nil)];
//  NSLog(@"%@",NSLocalizedString(@"hun", nil));
  if (unitFlag == NO) {
    unit = [NSString stringWithFormat:@"%@",NSLocalizedString(@"byo", nil)];
  }

  // UIControlStateNormal
  [myBtn setAttributedTitle:[self myBtnColorCtl:[UIColor blueColor ] btnNum:num unit:unit] forState:UIControlStateNormal];
  // UIControlStateHighlighted
  [myBtn setAttributedTitle:[self myBtnColorCtl:[UIColor whiteColor] btnNum:num unit:unit] forState:UIControlStateHighlighted];
  // UIControlStateDisabled
  [myBtn setAttributedTitle:[self myBtnColorCtl:[UIColor grayColor ] btnNum:num unit:unit] forState:UIControlStateDisabled];
  
  
  // ボタンの角丸ぐあい 端末分岐 iphone:25 ipad:50
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
    [myBtn.layer setCornerRadius:25.f];
  }
  else{
    [myBtn.layer setCornerRadius:50.f];
  }
  
  [myBtn.layer setShadowOpacity:0.5f];
  [myBtn.layer setShadowOffset:CGSizeMake(2.f, 2.f)];
  
  [myBtn addTarget:self action:@selector(myBtnTouchDown:) forControlEvents:UIControlEventTouchDown]; // タッチ中 イベント
  [myBtn addTarget:self action:@selector(myBtnTouchUpInside:) forControlEvents:UIControlEventTouchUpInside]; // タッチリリース時
  [self.view addSubview:myBtn];
}

- (void)myBtnCreate:(id)sender
{
  UIButton *myBtn = (UIButton *)sender;
  [myBtn setBackgroundColor:[UIColor colorWithRed:0.9f green:0.9f blue:0.f alpha:0.8f]];
  [myBtn.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
  [myBtn.layer setBorderWidth:1.f];
  
  // ボタンの角丸ぐあい 端末分岐 iphone:25 ipad:50
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
    [myBtn.layer setCornerRadius:25.f];
  }
  else{
    [myBtn.layer setCornerRadius:50.f];
  }
  
  [myBtn.layer setShadowOpacity:0.5f];
  [myBtn.layer setShadowOffset:CGSizeMake(2.f, 2.f)];
  
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
//  NSLog(@"driveClock Start!");
  
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
