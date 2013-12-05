//
//  ViewController.m
//  DesignKichinTimer
//
//  Created by z on 2013/10/18.
//  Copyright (c) 2013 FoceSystemSolution. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SoundOnFlag.h"
#import "GADBannerView.h"


@interface ViewController()

@end


@implementation ViewController


// View が表示される直前に呼ばれる定義済み関数（*画面再描画毎）
- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
//	self.adview = [[AdstirView alloc]initWithOrigin:CGPointMake(0, 0)];
//	self.adview.media = @"MEDIA-e0c497ff";
//	self.adview.spot = 1;
//	self.adview.rootViewController = self;
//	[self.adview start];
//	[self.view addSubview:self.adview];
}
- (void)viewWillDisappear:(BOOL)animated
{
//	[self.adview stop];
//	[self.adview removeFromSuperview];
//	self.adview.rootViewController = nil;
//	self.adview = nil;
	[super viewWillDisappear:animated];
}



// Statusbar non-display setting
- (BOOL)prefersStatusBarHidden
{
  // iphone only non-display
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
    return YES;
  }else{
    return NO;
  }
}

// View が初めて呼び出される時に1回だけ呼ばれる定義済み関数
- (void)viewDidLoad
{
  [super viewDidLoad];

  if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
    [self prefersStatusBarHidden];
    [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
  }
  
  
  
  // カウント部分 フォントサイズ ipad:180 iphone:70 = 5 digits + "M S"
  static float CNT_FONT_SIZE_IPHONE = 70.f;
  static float CNT_FONT_SIZE_IPAD   = 180.f;
  
  // ボタンのラベル フォントサイズ
  static float BTN_FONT_SIZE_IPHONE = 25.f;
  static float BTN_FONT_SIZE_IPAD   = 50.f;

  // Google AdMob 広告ユニットID
  static NSString *MY_UNIT_ID = @"ca-app-pub-8799115520187072/6215156947";
  
  
  //NSUserDefaults 初期化
  ud = [NSUserDefaults standardUserDefaults];
  


  //UserDefaults 初期値
  [ud setInteger:0 forKey:@"globalMinData"]; // M
  [ud setInteger:0 forKey:@"globalSecData"]; // S

  
  /*** Sound Setting ***/
  
  //ボタン音
  NSURL *pi = [[NSBundle mainBundle] URLForResource:@"pi_old" withExtension:@"mp3"];
  pressBtnSnd = [[AVAudioPlayer alloc] initWithContentsOfURL:pi error:NULL];
  [pressBtnSnd prepareToPlay];
//  pressBtnSnd.volume = 0.4;
  pressBtnSnd.numberOfLoops = 0; // 再生回数 -1:ループ再生

  //Alerm音
  NSURL *alerm = [[NSBundle mainBundle] URLForResource:@"piLong" withExtension:@"mp3"];
  alermSound = [[AVAudioPlayer alloc] initWithContentsOfURL:alerm error:NULL];
  [alermSound prepareToPlay];
//  alermSound.volume = 0.4;
  alermSound.numberOfLoops = 0; // 再生回数 -1:ループ再生
  
  
  
  //自動スリープの解除
//  UIApplication *application = [UIApplication sharedApplication];
//  application.idleTimerDisabled = YES;

  
  //初期化
  globalSec = 0;
  globalMin = 0;
  cntUpFlag = NO;
  timeUpOk = NO;

  
  
  //画面情報(横幅)取得
  UIScreen *sc = [UIScreen mainScreen];
  CGRect rect = sc.bounds;
  CGFloat screenWidth = rect.size.width;
//  CGFloat screenHeight = rect.size.height;
  
//  NSLog(@"%d: w=%d h=%d",__LINE__,(int)screenWidth,(int)screenHeight); // iphone4s 320x480, ipad mini 768x1024
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
  cntLabel = [[MyCntLabel alloc] initWithFrame:CGRectMake(0,0,cntW,cntH)];// x y w h
  
  // 表示フォントサイズ 端末分岐 ipad:180 iphone:70  = 5 digits + "M S"
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
    [cntLabel setCnt:CNT_FONT_SIZE_IPHONE];
  }else{
    [cntLabel setCnt:CNT_FONT_SIZE_IPAD];
  }
  [cntView addSubview:cntLabel];
  
  [self _addDropShadowToView:cntView]; // 内影生成
  
  
  
  /*** 表示切り替え(ボタン)配置 ***/
  [self btnLinkSelect];//「現在時モード」「タイマーモード」
  
  
  
  /*** カウンタ数値セットボタンUI定義 ここから ***/
  
  // 表示フォントサイズ 端末分岐 ipad:50 iphone:20
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
    btnFontSize = BTN_FONT_SIZE_IPHONE;
  }
  else{
    btnFontSize = BTN_FONT_SIZE_IPAD;
  }
  
  setBtn10 = [MySetBtn buttonWithType:UIButtonTypeCustom];
  [setBtn10 setNum:10 minFlag:YES fontSize:btnFontSize];
  [setBtn10 addTarget:self action:@selector(btn10Touch:) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:setBtn10];
 
  setBtn05 = [MySetBtn buttonWithType:UIButtonTypeCustom];
  [setBtn05 setNum:5 minFlag:YES fontSize:btnFontSize];
  [setBtn05 addTarget:self action:@selector(btn05Touch:) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:setBtn05];
  
  setBtn03 = [MySetBtn buttonWithType:UIButtonTypeCustom];
  [setBtn03 setNum:3 minFlag:YES fontSize:btnFontSize];
  [setBtn03 addTarget:self action:@selector(btn03Touch:) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:setBtn03];
  
  setBtn01 = [MySetBtn buttonWithType:UIButtonTypeCustom];
  [setBtn01 setNum:1 minFlag:YES fontSize:btnFontSize];
  [setBtn01 addTarget:self action:@selector(btn01Touch:) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:setBtn01];

  setBtnReset = [MySetBtn buttonWithType:UIButtonTypeCustom];
  [setBtnReset setReset:btnFontSize];
  [setBtnReset addTarget:self action:@selector(resetBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:setBtnReset];
  
  setBtn001 = [MySetBtn buttonWithType:UIButtonTypeCustom];
  [setBtn001 setNum:10 minFlag:NO fontSize:btnFontSize];
  [setBtn001 addTarget:self action:@selector(btn001Touch:) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:setBtn001];

  setBtnStart = [MySetBtn buttonWithType:UIButtonTypeCustom];
  [setBtnStart setStart:btnFontSize];
  [setBtnStart addTarget:self action:@selector(startBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:setBtnStart];

  

  
  
  
  // デバイスの回転をサポート デバイスが回転した際に、呼び出してほしいメソッドを指定
  [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(didRotate:)
                                               name:UIDeviceOrientationDidChangeNotification
                                             object:nil];
  
  
  
  
  [self timerInitDisp];
  
  
  
  
  
  
  /*** AdMob用 広告表示 ここから ***/
  adViewHeightMargin = 30; // iphone
  CGRect adRect = CGRectMake(0.0,
                             self.view.frame.size.height - GAD_SIZE_320x50.height,
                             GAD_SIZE_320x50.width,
                             GAD_SIZE_320x50.height);
  
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    // iPad用定義
    
    adViewHeightMargin = 66;

    adRect = CGRectMake(0.0,
                        self.view.frame.size.height - GAD_SIZE_728x90.height,
                        GAD_SIZE_728x90.width,
                        GAD_SIZE_728x90.height);
  
  }
  
  mobView = [[GADBannerView alloc] initWithFrame:adRect];
  
  mobView.adUnitID = MY_UNIT_ID;
  mobView.delegate = (id<GADBannerViewDelegate>)self;
  mobView.rootViewController = self;
  
  //画面下部へ表示
  mobView.frame = CGRectMake(0, // x
                            screenWidth - adViewHeightMargin, // y
                            mobView.frame.size.width,   // w
                            mobView.frame.size.height); // h
  
  [self.view addSubview:mobView];
  
  [mobView loadRequest:[GADRequest request]];

  mobView.hidden = YES;
  /*** AdMob用 広告表示 ここまで ***/

  
  

  /*** iAd用 広告表示 ここから ***/
  adView = [[ADBannerView alloc] initWithFrame:CGRectZero];
  
  //画面下部へ表示
  adViewHeightMargin = 30; // iphone
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
    adViewHeightMargin = 66;
  }
  
  adView.frame = CGRectMake(0, // x
                            screenWidth - adViewHeightMargin, // y
                            adView.frame.size.width,   // w
                            adView.frame.size.height); // h
  
  
  
  adView.delegate = (id<ADBannerViewDelegate>)self;
  adView.autoresizesSubviews = YES;
  adView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;

  [self.view addSubview:adView];
  bannerIsVisible = YES;
  /*** iAd用 広告表示 ここまで ***/
}


- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
  NSLog(@"%d: iAd Get Success!!",__LINE__);

  if (!bannerIsVisible) {
    [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
    [UIView setAnimationDuration:0.3];
    
//    banner.frame = CGRectOffset(banner.frame, 0, CGRectGetHeight(banner.frame));
    banner.alpha = 1.0f;
    banner.hidden = NO;
    
    [UIView commitAnimations];

    bannerIsVisible = YES;
//    [self.view bringSubviewToFront:adView];//再背面に移動
    [self.view addSubview:adView];
    
    mobView.hidden = YES;
//    [self.view sendSubviewToBack:mobView];//最前面に移動
    [mobView removeFromSuperview];
    
  }

}
- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
  NSLog(@"%d: iAd get NG??",__LINE__);
  
  if (bannerIsVisible) {
    [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
    [UIView setAnimationDuration:0.3];
    
//    banner.frame = CGRectOffset(banner.frame, 0, -CGRectGetHeight(banner.frame));
    banner.alpha = 0.0f;
    banner.hidden = YES;
    
    [UIView commitAnimations];

    bannerIsVisible = NO;
//    [self.view sendSubviewToBack:adView];//再背面に移動
    [adView removeFromSuperview];
  
    mobView.hidden = NO;
//    [self.view bringSubviewToFront:mobView];//最前面に移動
    [self.view addSubview:mobView];
  }
}


- (BOOL)shouldAutorotate
{
  if(YES){
    return YES;
  } else {
    return NO;
  }
}







// デバイスが回転した際に、呼び出されるメソッド(※自作)
- (void) didRotate:(NSNotification *)notification {
  //  UIDeviceOrientation o = [[notification object] orientation];
  UIDeviceOrientation o = [[UIDevice currentDevice] orientation];
  
  
  // iphone かつ Home button top の場合のみ 動作がおかしいので止める
  if (o == UIDeviceOrientationPortraitUpsideDown && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
//    NSLog(@"%d: return void",__LINE__);
    return;
  }

  
  
  //X軸の中心を取得
  int centerPoint = [self arignCenter:0];
//  NSLog(@"%d: centerPoint=%d",__LINE__,centerPoint);
  
  
  if (   o == UIDeviceOrientationLandscapeLeft
      || o == UIDeviceOrientationLandscapeRight
      || o == UIDeviceOrientationPortrait
      || o == UIDeviceOrientationPortraitUpsideDown) {
    
    
    
    // 端末によりボタンの配置／大きさの調整
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
      //NSLog(@"%d: iPhoneの処理",__LINE__);
      
      // Viewの位置とサイズを補正してセット
      cntView.frame = CGRectMake([self arignCenter:cntW], 35, cntW, cntH); // x y w h
      
      
      setBtn10.frame    = CGRectMake(centerPoint -74  -85, 150, 74, 50); // x y w h
      setBtn05.frame    = CGRectMake(centerPoint -74 -3.5, 150, 74, 50); // x y w h
      setBtn03.frame    = CGRectMake(centerPoint     +3.5, 150, 74, 50); // x y w h
      setBtn01.frame    = CGRectMake(centerPoint      +85, 150, 74, 50); // x y w h
      setBtnReset.frame = CGRectMake(centerPoint  -135.0f, 220.0f, 80.0f, 60.0f); // x y w h
      setBtn001.frame   = CGRectMake(centerPoint  -(74/2), 225, 74, 50); // x y w h
      setBtnStart.frame = CGRectMake(centerPoint      +55, 220, 80, 60); // x y w h
      
      clockSelectBtn.frame = CGRectMake(centerPoint - 150     , -3,120,50);
      timerSelectBtn.frame = CGRectMake(centerPoint - 150 +130, -3,145,50);
      
    }else{
      //NSLog(@"%d: iPadの処理",__LINE__);

      // Viewの位置とサイズを補正してセット
      cntView.frame = CGRectMake([self arignCenter:cntW], 60, cntW, cntH); // x y w h

      
      setBtn10.frame    = CGRectMake(centerPoint -170 -200, 400, 170, 100); // x y w h
      setBtn05.frame    = CGRectMake(centerPoint -170  -10, 400, 170, 100); // x y w h
      setBtn03.frame    = CGRectMake(centerPoint       +10, 400, 170, 100); // x y w h
      setBtn01.frame    = CGRectMake(centerPoint      +200, 400, 170, 100); // x y w h
      setBtnReset.frame = CGRectMake(centerPoint -190 -115, 550, 190, 110); // x y w h
      setBtn001.frame   = CGRectMake(centerPoint  -(170/2), 550, 170, 100); // x y w h
      setBtnStart.frame = CGRectMake(centerPoint      +115, 550, 190, 110); // x y w h
    }
    
  }

  
  
  /*** 広告表示位置制御 ***/
  
  // 横向き
  if (o == UIDeviceOrientationLandscapeLeft || o == UIDeviceOrientationLandscapeRight) {
    
    mobView.center = CGPointMake(centerPoint, mobView.center.y);

  // 縦向き
  } else if (o == UIDeviceOrientationPortrait || o == UIDeviceOrientationPortraitUpsideDown) {
    
    mobView.center = CGPointMake(centerPoint, mobView.center.y);
  
    
    // 向きが不明な場合
  } else {
    // NSLog(@"%d: device orientation is Unkown.",__LINE__);
  }
}





/*
 * タイマー用タイマー開始関数
 */
- (void)startTimerTimer {
  timerTm = [NSTimer scheduledTimerWithTimeInterval:1.f //タイマーを発生させる間隔（1.0秒毎）
                                             target:self //メソッドがあるオブジェクト
                                           selector:@selector(timerTimer:) //呼び出すメソッド
                                           userInfo:nil //メソッドに渡すパラメータ
                                            repeats:YES]; //繰り返し
//  [[NSRunLoop mainRunLoop] addTimer:timerTm forMode:NSRunLoopCommonModes];// 画面が消えても起動しつづける
}
/*
 * タイマー用タイマー停止(リセット)関数
 */
- (void)resetTimerTimer {
  if ([timerTm isValid]) {
    [timerTm invalidate];
  }
  
  // Reset処理
  globalSec = 0;
  globalMin = 0;
  
  cntLabel.text = @"000 00"; // 表示テキストもクリア
}

/*
 * タイマー用タイマーStop(一時停止)関数
 */
- (void)pauseTimerTimer {
  [timerTm invalidate];
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
//  cntLabel.text = @""; // 表示テキストもクリア
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


- (void)btnDisabledAll
{
  [setBtn60 setEnabled:NO];
  [setBtn10 setEnabled:NO];
  [setBtn05 setEnabled:NO];
  [setBtn03 setEnabled:NO];
  [setBtn01 setEnabled:NO];
  [setBtn001 setEnabled:NO];
  [setBtn0001 setEnabled:NO];
  [setBtnStart setEnabled:NO];
  [setBtnReset setEnabled:NO];
}
- (void)btnEnabledAll
{
  [setBtn60 setEnabled:YES];
  [setBtn10 setEnabled:YES];
  [setBtn05 setEnabled:YES];
  [setBtn03 setEnabled:YES];
  [setBtn01 setEnabled:YES];
  [setBtn001 setEnabled:YES];
  [setBtn0001 setEnabled:YES];
  [setBtnStart setEnabled:YES];
  [setBtnReset setEnabled:YES];
}
- (void)btnEnableOnlyReset
{
  [setBtn60 setEnabled:NO];
  [setBtn10 setEnabled:NO];
  [setBtn05 setEnabled:NO];
  [setBtn03 setEnabled:NO];
  [setBtn01 setEnabled:NO];
  [setBtn001 setEnabled:NO];
  [setBtn0001 setEnabled:NO];
  [setBtnStart setEnabled:NO];
  [setBtnReset setEnabled:YES];
}
- (void)btnEnableOnlyStartReset
{
  [setBtn60 setEnabled:NO];
  [setBtn10 setEnabled:NO];
  [setBtn05 setEnabled:NO];
  [setBtn03 setEnabled:NO];
  [setBtn01 setEnabled:NO];
  [setBtn001 setEnabled:NO];
  [setBtn0001 setEnabled:NO];
  [setBtnStart setEnabled:YES];
  [setBtnReset setEnabled:YES];
}

- (void)cntPlusChk
{
  if (globalSec >= 60) {
    globalMin++;

    if (globalMin >= 999) {
      globalSec = 59;
    }else{
      globalSec -= 60;
    }
  }
  if (globalMin >= 999) {
    globalMin = 999;
  }

  [self chkDisp];
}

- (void)btn001Touch:(id)sender
{
  [self btnSndChkPlay];//効果音再生
  
  globalSec += 10;
  [self cntPlusChk];
}

- (void)btn01Touch:(id)sender
{
  [self btnSndChkPlay];//効果音再生
  
  globalMin += 1;
  [self cntPlusChk];
}
- (void)btn03Touch:(id)sender
{
  [self btnSndChkPlay];//効果音再生
  
  globalMin += 3;
  [self cntPlusChk];
}
- (void)btn05Touch:(id)sender
{
  [self btnSndChkPlay];//効果音再生
  
  globalMin += 5;
  [self cntPlusChk];
}
- (void)btn10Touch:(id)sender
{
  [self btnSndChkPlay];//効果音再生
  
  globalMin += 10;
  [self cntPlusChk];
}


- (void)resetBtnTouch:(id)sender
{
  [self btnSndChkPlay];//効果音再生
  [alermSound stop]; // 再生停止

  
  
  if ([timerTm isValid]) {
    // タイマーが動いている場合は、一時停止
//    NSLog(@"%d: aaa",__LINE__);
    
    [self pauseTimerTimer];
    [self btnEnableOnlyStartReset];

    if (timeUpOk) {
      globalMin = (int)[ud integerForKey:@"globalMinData"];
      globalSec = (int)[ud integerForKey:@"globalSecData"];
      [self chkDisp];
      [self btnEnabledAll];
      
      cntUpFlag = NO;
      timeUpOk = NO;
    }
    
  } else {
//    NSLog(@"%d: bbb",__LINE__);

    [self resetTimerTimer];
    [self btnEnabledAll];
    cntUpFlag = NO;
  }
}

- (void)startBtnTouch:(id)sender
{
  [self btnSndChkPlay];//効果音再生
 
  //Set Data Memory
  [ud setInteger:globalMin forKey:@"globalMinData"];  // M
  [ud setInteger:globalSec forKey:@"globalSecData"];  // S
  [ud synchronize];

  
  
  [self startTimerTimer];
  [self btnEnableOnlyReset];
}


/*
 * フラグをチェックしてボタン音再生
 */
- (void)btnSndChkPlay
{
  if ([SoundOnFlag val]) {
    [pressBtnSnd setCurrentTime:0.f]; // 開始位置をもどす
    [pressBtnSnd play]; // 再生開始
  }
}

/*
 * フラグをチェックしてアラーム再生
 */
- (void)almSndChkPlay
{
  if ([SoundOnFlag val]) {
    alermSound.currentTime = 0.f; // 開始位置をもどす
    [alermSound play]; // 再生開始
  }
}


/*
 * 音のON/OFFボタン用イベント
 */
- (void)soundSelectBtnTouch:(id)sender
{
  // アラート
  UIAlertView *alert = [[UIAlertView alloc] init];
  
  if ([SoundOnFlag val]) {
    [soundSelectBtn SwitchIcon:sndBtnRect btnTitle:sndBtnTitle stateFlag:NO];

    [SoundOnFlag setValue:NO];
    [SoundOnFlag sync];
    
    [alermSound stop];//鳴っている途中なら止める

    alert.title   = [NSString stringWithFormat:@"%@",NSLocalizedString(@"SndTtlOff", nil)];
    alert.message = [NSString stringWithFormat:@"%@",NSLocalizedString(@"SndMsgOff", nil)];
    [alert addButtonWithTitle:@" O K "];
    
  }else{
    [soundSelectBtn SwitchIcon:sndBtnRect btnTitle:sndBtnTitle stateFlag:YES];

    [SoundOnFlag setValue:YES];
    [SoundOnFlag sync];

    alert.title   = [NSString stringWithFormat:@"%@",NSLocalizedString(@"SndTtlOn", nil)];
    alert.message = [NSString stringWithFormat:@"%@",NSLocalizedString(@"SndMsgOn", nil)];
    [alert addButtonWithTitle:@" O K "];
  }

  [alert show];
}

/*
 * 「現在時表示」ボタン用イベント
 */
- (void)clockSelectBtnTouch:(id)sender
{
  // フェードアウトしてfadeinフラグをたてる
  [self lbFadeout:cntLabel];
  [self lbFadeout:hunLabel];
  [self lbFadeout:byoLabel];
  [self btnFadeout:soundSelectBtn];

  fadeinFlag = YES;

  
  [clockSelectBtn setEnabled:NO];
  [timerSelectBtn setEnabled:YES];

  //すべてのボタンをDisableにする
  [self btnDisabledAll];


  //現在時表示用タイマー開始
  [self startClockTimer];
  

  // 現在時表示モード
  cntMode = NO;
  
  
  
}

/*
 * UILabel fadeout method
 */
- (void)lbFadeout:(UILabel *)lb
{
  [UIView beginAnimations:nil context:nil];
  [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
  [UIView setAnimationDuration:1.f];
  lb.alpha = 0.f;
  [UIView commitAnimations];
}
/*
 * UILabel fadein method
 */
- (void)lbFadein:(UILabel *)lb
{
  if (fadeinFlag) {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:1.f];
    lb.alpha = 8.f;
    [UIView commitAnimations];
  }
}


/*
 * UIButton fadeout method
 */
- (void)btnFadeout:(UIButton *)btn
{
  [UIView beginAnimations:nil context:nil];
  [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
  [UIView setAnimationDuration:1.f];
  btn.alpha = 0.f;
  [UIView commitAnimations];
}
/*
 * UIButton fadein method
 */
- (void)btnFadein:(UIButton *)btn
{
  if (fadeinFlag) {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:1.f];
    btn.alpha = 8.f;
    [UIView commitAnimations];
  }
}



/*
 * 「タイマー設定」ボタン用イベント
 */
- (void) timerSelectBtnTouch:(id)sender
{
  // キッチンタイマーモード
  cntMode = YES;
  [self chkDisp];
  cntLabel.alpha = 0.f;

  [clockSelectBtn setEnabled:YES];
  [timerSelectBtn setEnabled:NO];
  

  if ([timerTm isValid]) {
    // タイマーが動いている場合はリセットボタンのみ活性化
    [self btnEnableOnlyReset];
  } else {
    
    if (globalMin > 0 || globalSec > 0) {
      [self btnEnableOnlyStartReset];
    }else{
    
      //すべてのボタンをEnableにする
      [self btnEnabledAll];
    }
  }

  //現在時表示用タイマー停止(クリア)
  [self stopClockTimer];
  
  // 表示
//  [self timerInitDisp];
  [self lbFadein:hunLabel];
  [self lbFadein:byoLabel];
  [self lbFadein:cntLabel];
  [self btnFadein:soundSelectBtn];

}

- (void)timerInitDisp {

  cntMode = YES; // Timer Mode
  
  // キッチンタイマー用 初期表示
//  cntLabel.text = @"000 00";
  [self chkDisp];

  
  /*** 分・秒のラベルを作成して表示 ***/
  
  // 表示フォントサイズ 端末分岐 ipad:30 iphone:15
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
    //NSLog(@"%d: iPhoneの処理",__LINE__);
    unitFontSize = 15.f;
    unitRectM = CGRectMake(146,9,45,45); // x y w h
    unitRectS = CGRectMake(244,9,45,45); // x y w h
  }
  else{
    //NSLog(@"%d: iPadの処理",__LINE__);
    unitFontSize = 30.f;
    unitRectM = CGRectMake(388,60,45,45); // x y w h
    unitRectS = CGRectMake(633,60,45,45); // x y w h
  }
  
  hunLabel = [[MyCntLabel alloc] initWithFrame:unitRectM];// x y w h
  [hunLabel setHun:unitFontSize];
  [cntView addSubview:hunLabel];
  
  byoLabel = [[MyCntLabel alloc] initWithFrame:unitRectS];// x y w h
  [byoLabel setByo:unitFontSize];
  [cntView addSubview:byoLabel];
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
    //    NSLog(@"%d: height=%f",__LINE__,rect.size.height);
    return ( rect.size.height - w ) / 2; // X座標を返す
  }else{
    //    NSLog(@"%d: width=%f",__LINE__,rect.size.width);
    return ( rect.size.width - w ) / 2; // X座標を返す
  }
}



// 時計(現在時)表示用関数
- (void)driveClock:(NSTimer *)timer
{
  //  NSLog(@"%d: driveClock Start!",__LINE__);
  
  NSDate *today = [NSDate date]; //現在時刻を取得
  NSCalendar *calender = [NSCalendar currentCalendar]; //現在時刻の時分秒を取得
  unsigned flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
  NSDateComponents *todayComponents = [calender components:flags fromDate:today];
  //  int nenn = [todayComponents year];
  //  int tuki = [todayComponents month];
  //  int niti = [todayComponents day];
  //  int weekIndex = [todayComponents weekday];
  
  int hour = (int)[todayComponents hour];
  int min  = (int)[todayComponents minute];
  int sec  = (int)[todayComponents second];
  
  //  // 年月日,曜日表示
  //  nowDate.text = [NSString stringWithFormat:@"%04d/%02d/%02d (%@)",nenn,tuki,niti,[self stringShortweekday:weekIndex]];
  
  // 時間を表示
  cntLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d",hour,min,sec];

  [self lbFadein:cntLabel];
}



// タイマー表示用関数
- (void)timerTimer:(NSTimer *)timer
{
//  NSLog(@"%d: timerTimer Start!",__LINE__);
  
  if (globalSec == 0 && globalMin == 0) {
//    NSLog(@"%d: Count UP Start!",__LINE__);
    cntUpFlag = YES;
  }
  
  if (cntUpFlag) {
    [self cntUpTimer];
  }else{
    [self cntDnTimer];
  }
  
}

// カウントアップ用関数
- (void)cntUpTimer
{
  globalSec++;
    
  if (globalSec > 59) {
    globalSec = 0;
    globalMin++;
    
    if (globalMin > 999) {
      [self pauseTimerTimer];
      globalMin = 999;
      globalSec = 59;
    }
  }
  [self chkDisp];
}

// カウントダウン用関数
- (void)cntDnTimer
{
  if (globalSec == 0) {
    globalMin--;
    globalSec = 59;
  }else{
    globalSec--;
  }
  
  if (globalSec == 0 && globalMin == 0) {
   
    
    // Vibrate
//    AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
    
    [self almSndChkPlay];
    
    timeUpOk = YES;
    cntUpFlag = YES;
  }
  
  
  [self chkDisp];
  
}


// 表示反映関数
- (void)chkDisp
{
  
//  NSLog(@"%d: cntMode = %hhd",__LINE__,cntMode);
  
  // Check is Mode
  if (cntMode) {
    cntLabel.text = [NSString stringWithFormat:@"%03d %02d",globalMin,globalSec];
  }
}


/*** 表示切り替え(ボタン)配置 関数 ***/
- (void)btnLinkSelect
{
  
  // ====== 「現在時表示」ボタン（リンクテキスト風）ここから ======
  clockSelectBtn = [MyModeBtn buttonWithType:UIButtonTypeCustom];
  
  [clockSelectBtn ModeSelect:CGRectMake(15,7,120,50)    // x y w h // use ipad positioning
                    btnTitle:[NSString stringWithFormat:@"%@",NSLocalizedString(@"btnClock", nil)]];
  
  [clockSelectBtn setEnabled:YES]; // default
  
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
    [self.view addSubview:clockSelectBtn]; // iphone
  }else{
    [cntView addSubview:clockSelectBtn];   // ipad
  }
  [clockSelectBtn addTarget:self action:@selector(clockSelectBtnTouch:) forControlEvents:UIControlEventTouchUpInside]; // タッチリリース時
  // ====== 「現在時表示」ボタン（リンクテキスト風）ここまで ======
  
  
  // ====== 「タイマー設定」ボタン（リンクテキスト風）ここから ======
  timerSelectBtn = [MyModeBtn buttonWithType:UIButtonTypeCustom];
  
  [timerSelectBtn ModeSelect:CGRectMake(145,7,145,50)    // x y w h // use ipad positioning
                    btnTitle:[NSString stringWithFormat:@"%@",NSLocalizedString(@"btnTimer", nil)]];
  
  [timerSelectBtn setEnabled:NO]; // not default
  
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
    [self.view addSubview:timerSelectBtn]; // iphone
  }else{
    [cntView addSubview:timerSelectBtn];   // ipad
  }
  [timerSelectBtn addTarget:self action:@selector(timerSelectBtnTouch:) forControlEvents:UIControlEventTouchUpInside]; // タッチリリース時
  // ====== 「タイマー設定」ボタン（リンクテキスト風）ここまで ======
  
  
  // ====== 「Sound ON/OFF」Button From here ======
  soundSelectBtn = [MyModeBtn buttonWithType:UIButtonTypeCustom];
  
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
    sndBtnTitle = [NSString stringWithFormat:@"%@",NSLocalizedString(@"btnSound", nil)];
    sndBtnRect  = CGRectMake(cntView.bounds.size.width -40,cntView.bounds.size.height -40,35,35);
  }else{
    sndBtnTitle = [NSString stringWithFormat:@"[ %@ ]",NSLocalizedString(@"btnSound", nil)];
    sndBtnRect  = CGRectMake(cntView.bounds.size.width -60,cntView.bounds.size.height -40,50,35);
  }
  
  [soundSelectBtn SwitchIcon:sndBtnRect btnTitle:sndBtnTitle stateFlag:[SoundOnFlag val]];
  [soundSelectBtn addTarget:self action:@selector(soundSelectBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
  [cntView addSubview:soundSelectBtn];
  // ====== 「Sound ON/OFF」Button To here ======
  
}



- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
