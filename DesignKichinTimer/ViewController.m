//
//  ViewController.m
//  DesignKichinTimer
//
//  Created by z on 2013/10/18.
//  Copyright (c) 2013 FoceSystemSolution. All rights reserved.
//

#import "ViewController.h"
#import "SoundOnFlag.h"
#import "VibrateOnFlag.h"
#import "BtnZoomOnFlag.h"
#import "ResetBtnScaleOnFlag.h"

@interface ViewController()
@end

@implementation ViewController


// iOS7 Status Bar Disabled
- (BOOL)prefersStatusBarHidden
{
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
    return YES;
  }else{
    return NO; // ipad
  }
}
- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
  return UIStatusBarAnimationFade;
}


// View が初めて呼び出される時に1回だけ呼ばれる *定義済み関数
- (void)viewDidLoad
{
  [super viewDidLoad];
  
  // Head Status Bar Hidden
  if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
  }
  
  //NSUserDefaults 初期化
  ud = [NSUserDefaults standardUserDefaults];
  
  //UserDefaults 初期値
  [ud setInteger:0 forKey:@"globalMinData"]; // M
  [ud setInteger:0 forKey:@"globalSecData"]; // S
  
  // リセットボタン 拡大中フラグ
  [ResetBtnScaleOnFlag setValue:NO];
  [ResetBtnScaleOnFlag sync];

  
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
  cntView = [[CntView alloc] initWithFrame:CGRectMake([self arignCenter:cntW], 60, cntW, cntH)];// x y w h
  [cntView setBackgroundColor:[UIColor whiteColor]];
  [self.view addSubview:cntView];
  
  
  // カウント表示Label
  cntLabel = [[MyCntLabel alloc] initWithFrame:CGRectMake(-15,0,cntView.frame.size.width,cntView.frame.size.height)];// x y w h
  [cntLabel setCnt];
  [cntView addSubview:cntLabel];
  
  // History Label
  hisLabel = [[MyCntLabel alloc] init];// x y w h
  [hisLabel setHis];
  [hisLabel setHisEnable:YES];
  if ((int)[ud integerForKey:@"historySecData1"] + (int)[ud integerForKey:@"historyMinData1"] < 1) {
    [hisLabel setHisEnable:NO];
  }
  [self.view addSubview:hisLabel];
  
  
  
  /*** 表示切り替え(ボタン)配置 ***/
  [self btnLinkSelect];//「現在時モード」「タイマーモード」
  
  
  
  /*** カウンタ数値セットボタンUI定義 ここから ***/
  setBtn10 = [MySetBtn buttonWithType:UIButtonTypeCustom];
  [setBtn10 setNum:10 minFlag:YES];
  [setBtn10 addTarget:self action:@selector(btn10Touch:) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:setBtn10];
 
  setBtn05 = [MySetBtn buttonWithType:UIButtonTypeCustom];
  [setBtn05 setNum:5 minFlag:YES];
  [setBtn05 addTarget:self action:@selector(btn05Touch:) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:setBtn05];
  
  setBtn03 = [MySetBtn buttonWithType:UIButtonTypeCustom];
  [setBtn03 setNum:3 minFlag:YES];
  [setBtn03 addTarget:self action:@selector(btn03Touch:) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:setBtn03];
  
  setBtn01 = [MySetBtn buttonWithType:UIButtonTypeCustom];
  [setBtn01 setNum:1 minFlag:YES];
  [setBtn01 addTarget:self action:@selector(btn01Touch:) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:setBtn01];

  setBtnReset = [MySetBtn buttonWithType:UIButtonTypeCustom];
  [setBtnReset setReset:YES];
  [setBtnReset addTarget:self action:@selector(resetBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:setBtnReset];
  
  setBtn001 = [MySetBtn buttonWithType:UIButtonTypeCustom];
  [setBtn001 setNum:10 minFlag:NO];
  [setBtn001 addTarget:self action:@selector(btn001Touch:) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:setBtn001];

  setBtnStart = [MySetBtn buttonWithType:UIButtonTypeCustom];
  [setBtnStart setStart];
  [setBtnStart addTarget:self action:@selector(startBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:setBtnStart];

  setBtnHis1 = [MySetBtn buttonWithType:UIButtonTypeCustom];
  [setBtnHis1 setHis:1];
  [setBtnHis1 addTarget:self action:@selector(btnHis1Touch:) forControlEvents:UIControlEventTouchUpInside];
  if ((int)[ud integerForKey:@"historySecData1"] + (int)[ud integerForKey:@"historyMinData1"] == 0) {
    [setBtnHis1 setEnabled:NO];
  }
  [self.view addSubview:setBtnHis1];
  
  setBtnHis2 = [MySetBtn buttonWithType:UIButtonTypeCustom];
  [setBtnHis2 setHis:2];
  [setBtnHis2 addTarget:self action:@selector(btnHis2Touch:) forControlEvents:UIControlEventTouchUpInside];
  if ((int)[ud integerForKey:@"historySecData2"] + (int)[ud integerForKey:@"historyMinData2"] == 0) {
    [setBtnHis2 setEnabled:NO];
  }
  [self.view addSubview:setBtnHis2];
  
  setBtnHis3 = [MySetBtn buttonWithType:UIButtonTypeCustom];
  [setBtnHis3 setHis:3];
  [setBtnHis3 addTarget:self action:@selector(btnHis3Touch:) forControlEvents:UIControlEventTouchUpInside];
  if ((int)[ud integerForKey:@"historySecData3"] + (int)[ud integerForKey:@"historyMinData3"] == 0) {
    [setBtnHis3 setEnabled:NO];
  }
  [self.view addSubview:setBtnHis3];
  /*** カウンタ数値セットボタンUI定義 ここまで ***/
  
  
  // デバイスの回転をサポート デバイスが回転した際に、呼び出してほしいメソッドを指定
  [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(didRotate:)
                                               name:UIDeviceOrientationDidChangeNotification
                                             object:nil];
  
  [self timerInitDisp];
  
  
  NSString* freeFlagStr  = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"FreeVersionFlag"];
  BOOL freeFlag = [freeFlagStr boolValue];
  if (freeFlag) {
    //フリー版はバナー広告表示 (遅延実行)
    [self performSelector:@selector(bannerInit) withObject:nil afterDelay:0];
  }
}

-(void)bannerInit
{
  LOG(@"%s",__func__);
//  int w = [UIScreen mainScreen].bounds.size.width;
//  int h = [UIScreen mainScreen].bounds.size.height;
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


  
  if (   o == UIDeviceOrientationLandscapeLeft
      || o == UIDeviceOrientationLandscapeRight
      || o == UIDeviceOrientationPortrait
      || o == UIDeviceOrientationPortraitUpsideDown) {
    
    //X軸の中心を取得
    int centerPoint = [self arignCenter:0];
    
    // 端末によりボタンの配置／大きさの調整
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
      //NSLog(@"%d: iPhoneの処理",__LINE__);
      
      // Viewの位置とサイズを補正してセット
      cntView.frame = CGRectMake([self arignCenter:cntW], 35, cntW, cntH); // x y w h
      
      setBtn10.frame    = CGRectMake(centerPoint -74  -85, 150, 74, 50); // x y w h
      setBtn05.frame    = CGRectMake(centerPoint -74 -3.5, 150, 74, 50); // x y w h
      setBtn03.frame    = CGRectMake(centerPoint     +3.5, 150, 74, 50); // x y w h
      setBtn01.frame    = CGRectMake(centerPoint      +85, 150, 74, 50); // x y w h
      setBtnReset.frame = CGRectMake(centerPoint     -135, 220, 80, 60); // x y w h
      setBtn001.frame   = CGRectMake(centerPoint  -(74/2), 225, 74, 50); // x y w h
      setBtnStart.frame = CGRectMake(centerPoint      +55, 220, 80, 60); // x y w h
      
      clockSelectBtn.frame = CGRectMake(centerPoint - 150     , -3,145,50);
      timerSelectBtn.frame = CGRectMake(centerPoint - 150 +140, -3,145,50);

      infBtn.frame = CGRectMake(self.view.frame.size.width -35, 0, 35, 35); // x y w h
     
      // 横向きのみ履歴ボタン表示
      if (o == UIDeviceOrientationLandscapeLeft || o == UIDeviceOrientationLandscapeRight) {
        infBtn.frame = CGRectMake(self.view.frame.size.width +110, 5, 35, 35); // x y w h

        setBtnHis1.frame = CGRectMake(centerPoint     +158,  55, 60, 18 ); // x y w h
        setBtnHis2.frame = CGRectMake(centerPoint     +158,  80, 60, 18 ); // x y w h
        setBtnHis3.frame = CGRectMake(centerPoint     +158, 105, 60, 18 ); // x y w h
        
        // History Label
        hisLabel.frame   = CGRectMake((int)cntView.frame.origin.x +307, 30, 55, 20 ); // x y w h
//        NSLog(@"%d x=%d",__LINE__,(int)cntView.frame.origin.x);
        
        if ([ResetBtnScaleOnFlag val]) {
          [self btnScaleUpYoko:setBtnReset];
        }
      }else{
        if ([ResetBtnScaleOnFlag val]) {
          [self btnScaleUpTate:setBtnReset];
        }
      }
      
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
      
      // 横向きのみ履歴ボタン表示
      if (o == UIDeviceOrientationLandscapeLeft || o == UIDeviceOrientationLandscapeRight) {
        setBtnHis1.frame = CGRectMake(centerPoint     +385, 110, 65, 40 ); // x y w h
        setBtnHis2.frame = CGRectMake(centerPoint     +385, 170, 65, 40 ); // x y w h
        setBtnHis3.frame = CGRectMake(centerPoint     +385, 230, 65, 40 ); // x y w h
        
        // History Label
        hisLabel.frame   = CGRectMake((int)cntView.frame.origin.x +749, 70, 90, 20 ); // x y w h
//        NSLog(@"%d x=%d",__LINE__,(int)cntView.frame.origin.x);
        
        if ([ResetBtnScaleOnFlag val]) {
          [self btnScaleUpYoko:setBtnReset];
        }
      }else{
        if ([ResetBtnScaleOnFlag val]) {
          [self btnScaleUpTate:setBtnReset];
        }
      }
    }
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
//  [setBtn60 setEnabled:NO];
  [setBtn10 setEnabled:NO];
  [setBtn05 setEnabled:NO];
  [setBtn03 setEnabled:NO];
  [setBtn01 setEnabled:NO];
  [setBtn001 setEnabled:NO];
//  [setBtn0001 setEnabled:NO];
  [setBtnStart setEnabled:NO];
  [setBtnReset setEnabled:NO];
  [hisLabel setHisEnable:NO];
  [setBtnHis1 setEnabled:NO];
  [setBtnHis2 setEnabled:NO];
  [setBtnHis3 setEnabled:NO];
}
- (void)btnEnabledAll
{
//  [setBtn60 setEnabled:YES];
  [setBtn10 setEnabled:YES];
  [setBtn05 setEnabled:YES];
  [setBtn03 setEnabled:YES];
  [setBtn01 setEnabled:YES];
  [setBtn001 setEnabled:YES];
//  [setBtn0001 setEnabled:YES];
  [setBtnStart setEnabled:YES];
  [setBtnReset setEnabled:YES];
  
  if ((int)[ud integerForKey:@"historySecData1"] + (int)[ud integerForKey:@"historyMinData1"] >= 1) {
    [hisLabel setHisEnable:YES];
  }
  if ((int)[ud integerForKey:@"historySecData1"] + (int)[ud integerForKey:@"historyMinData1"] >= 1) {
    [setBtnHis1 setEnabled:YES];
  }
  if ((int)[ud integerForKey:@"historySecData2"] + (int)[ud integerForKey:@"historyMinData2"] >= 1) {
    [setBtnHis2 setEnabled:YES];
  }
  if ((int)[ud integerForKey:@"historySecData3"] + (int)[ud integerForKey:@"historyMinData3"] >= 1) {
    [setBtnHis3 setEnabled:YES];
  }
  
  if ([BtnZoomOnFlag val]) {
    [self btnScaleOrg:setBtnReset]; //縮小アニメ
  }
}
- (void)btnEnableOnlyReset
{
//  [setBtn60 setEnabled:NO];
  [setBtn10 setEnabled:NO];
  [setBtn05 setEnabled:NO];
  [setBtn03 setEnabled:NO];
  [setBtn01 setEnabled:NO];
  [setBtn001 setEnabled:NO];
//  [setBtn0001 setEnabled:NO];
  [setBtnStart setEnabled:NO];
  [setBtnReset setEnabled:YES];
  [hisLabel setHisEnable:NO];
  [setBtnHis1 setEnabled:NO];
  [setBtnHis2 setEnabled:NO];
  [setBtnHis3 setEnabled:NO];
  if ([BtnZoomOnFlag val]) {
    [self btnScaleUp:setBtnReset]; //拡大アニメ
  }
}
- (void)btnEnableOnlyStartReset
{
//  [setBtn60 setEnabled:NO];
  [setBtn10 setEnabled:NO];
  [setBtn05 setEnabled:NO];
  [setBtn03 setEnabled:NO];
  [setBtn01 setEnabled:NO];
  [setBtn001 setEnabled:NO];
//  [setBtn0001 setEnabled:NO];
  [setBtnStart setEnabled:YES];
  [setBtnReset setEnabled:YES];
  [hisLabel setHisEnable:NO];
  [setBtnHis1 setEnabled:NO];
  [setBtnHis2 setEnabled:NO];
  [setBtnHis3 setEnabled:NO];
  if ([BtnZoomOnFlag val]) {
    [self btnScaleOrg:setBtnReset]; //縮小アニメ
  }
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

  // リセットボタンの文言を「リセット」にする。
  [setBtnReset setReset:YES];
  
  
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

  // リセットボタンの文言を「ストップ」にする。
  [setBtnReset setReset:NO];

  
  //Set Data Memory
  [ud setInteger:globalMin forKey:@"globalMinData"];  // M
  [ud setInteger:globalSec forKey:@"globalSecData"];  // S


  BOOL addHistoryFlag = YES;
  if (
      globalMin == (int)[ud integerForKey:@"historyMinData1"] &&
      globalSec == (int)[ud integerForKey:@"historySecData1"]
      ) {
    addHistoryFlag = NO;
    
    // 履歴１と同じ内容であれば追加しない。
  }
  

  if (globalMin + globalSec > 0 && addHistoryFlag) {
    
    // 履歴２を履歴３へ移す
    [ud setInteger:(int)[ud integerForKey:@"historyMinData2"] forKey:@"historyMinData3"];  // M
    [ud setInteger:(int)[ud integerForKey:@"historySecData2"] forKey:@"historySecData3"];  // S
    
    // 履歴１を履歴２へ移す
    [ud setInteger:(int)[ud integerForKey:@"historyMinData1"] forKey:@"historyMinData2"];  // M
    [ud setInteger:(int)[ud integerForKey:@"historySecData1"] forKey:@"historySecData2"];  // S
    
    // セットを履歴１へ残す
    [ud setInteger:globalMin forKey:@"historyMinData1"];  // M
    [ud setInteger:globalSec forKey:@"historySecData1"];  // S
  }
  
  
  
  
  [ud synchronize];

  
  
  [self startTimerTimer];
  [self btnEnableOnlyReset];
}



- (void)btnHis1Touch:(id)sender
{
  [self btnSndChkPlay];//効果音再生
  
  globalMin = (int)[ud integerForKey:@"historyMinData1"];
  globalSec = (int)[ud integerForKey:@"historySecData1"];

  [self cntPlusChk];
}
- (void)btnHis2Touch:(id)sender
{
  [self btnSndChkPlay];//効果音再生
  
  globalMin = (int)[ud integerForKey:@"historyMinData2"];
  globalSec = (int)[ud integerForKey:@"historySecData2"];
  
  [self cntPlusChk];
}
- (void)btnHis3Touch:(id)sender
{
  [self btnSndChkPlay];//効果音再生
  
  globalMin = (int)[ud integerForKey:@"historyMinData3"];
  globalSec = (int)[ud integerForKey:@"historySecData3"];
  
  [self cntPlusChk];
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
- (void)sndBtnTouch:(id)sender
{
  UIButton *btn = sender;
  
  // アラート
  UIAlertView *alert = [[UIAlertView alloc] init];
  
  if ([SoundOnFlag val]) {
    [btn setImage:[UIImage imageNamed:@"IconSndOff.png"] forState:UIControlStateNormal];
    
    [SoundOnFlag setValue:NO];
    [SoundOnFlag sync];
    
    [alermSound stop];//鳴っている途中なら止める
    
    alert.title   = [NSString stringWithFormat:@"%@",NSLocalizedString(@"SndTtl", nil)];
    alert.message = [NSString stringWithFormat:@"%@",NSLocalizedString(@"SndMsgOff", nil)];
    [alert addButtonWithTitle:@" O K "];
    
  }else{
    [btn setImage:[UIImage imageNamed:@"IconSndOn.png"] forState:UIControlStateNormal];
    
    [SoundOnFlag setValue:YES];
    [SoundOnFlag sync];
    
    alert.title   = [NSString stringWithFormat:@"%@",NSLocalizedString(@"SndTtl", nil)];
    alert.message = [NSString stringWithFormat:@"%@",NSLocalizedString(@"SndMsgOn", nil)];
    [alert addButtonWithTitle:@" O K "];
  }
  
  [alert show];
}

/*
 * バイブレーションのON/OFFボタン用イベント
 */
- (void)vibBtnTouch:(id)sender
{
  UIButton *btn = sender;
  
  // アラート
  UIAlertView *alert = [[UIAlertView alloc] init];
  
  if ([VibrateOnFlag val]) {
    [btn setImage:[UIImage imageNamed:@"IconVibOff.png"] forState:UIControlStateNormal];
    
    [VibrateOnFlag setValue:NO];
    [VibrateOnFlag sync];
    
    alert.title   = [NSString stringWithFormat:@"%@",NSLocalizedString(@"VibTtl", nil)];
    alert.message = [NSString stringWithFormat:@"%@",NSLocalizedString(@"VibMsgOff", nil)];
    [alert addButtonWithTitle:@" O K "];
    
  }else{
    [btn setImage:[UIImage imageNamed:@"IconVibOn.png"] forState:UIControlStateNormal];
    
    [VibrateOnFlag setValue:YES];
    [VibrateOnFlag sync];
    
    alert.title   = [NSString stringWithFormat:@"%@",NSLocalizedString(@"VibTtl", nil)];
    alert.message = [NSString stringWithFormat:@"%@",NSLocalizedString(@"VibMsgOn", nil)];
    [alert addButtonWithTitle:@" O K "];
  }
  
  [alert show];
}

/*
 * Button Zoom ON/OFFボタン用イベント
 */
- (void)bigBtnTouch:(id)sender
{
  UIButton *btn = sender;
  
  // アラート
  UIAlertView *alert = [[UIAlertView alloc] init];
  
  if ([BtnZoomOnFlag val]) {
    [btn setImage:[UIImage imageNamed:@"IconBigOff.png"] forState:UIControlStateNormal];
    
    //拡大していた場合は戻す
    if ([ResetBtnScaleOnFlag val]) {
      [self btnScaleOrg:setBtnReset]; //縮小アニメ
    }
    
    [BtnZoomOnFlag setValue:NO];
    [BtnZoomOnFlag sync];
    
    alert.title   = [NSString stringWithFormat:@"%@",NSLocalizedString(@"BigTtl", nil)];
    alert.message = [NSString stringWithFormat:@"%@",NSLocalizedString(@"BigMsgOff", nil)];
    [alert addButtonWithTitle:@" O K "];
    
  }else{
    [btn setImage:[UIImage imageNamed:@"IconBigOn.png"] forState:UIControlStateNormal];
    
    [BtnZoomOnFlag setValue:YES];
    [BtnZoomOnFlag sync];
    
    alert.title   = [NSString stringWithFormat:@"%@",NSLocalizedString(@"BigTtl", nil)];
    alert.message = [NSString stringWithFormat:@"%@",NSLocalizedString(@"BigMsgOn", nil)];
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
  [self btnFadeout:sndBtn];
  [self btnFadeout:vibBtn];
  [self btnFadeout:bigBtn];

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
  // カウンター数値 表示位置補正
  cntLabel.frame = CGRectMake(-15, 0, cntView.frame.size.width, cntView.frame.size.height); //x y w h

  
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
  [self btnFadein:sndBtn];
  [self btnFadein:vibBtn];
  [self btnFadein:bigBtn];
}


- (void)timerInitDisp {

  cntMode = YES; // Timer Mode
  
  // キッチンタイマー用 初期表示
//  cntLabel.text = @"000 00";
  [self chkDisp];

  
  /*** 分・秒のラベルを作成して表示 ***/
  
  // 表示サイズ 端末分岐
  CGRect unitRectM;
  CGRect unitRectS;
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
    //NSLog(@"%d: iPhoneの処理",__LINE__);
    unitRectM = CGRectMake(131,9,45,45); // x y w h
    unitRectS = CGRectMake(229,9,45,45); // x y w h
  }
  else{
    //NSLog(@"%d: iPadの処理",__LINE__);
    unitRectM = CGRectMake(378,60,45,45); // x y w h
    unitRectS = CGRectMake(623,60,45,45); // x y w h
  }
  
  hunLabel = [[MyCntLabel alloc] initWithFrame:unitRectM];// x y w h
  [hunLabel setHun];
  [cntView addSubview:hunLabel];
  
  byoLabel = [[MyCntLabel alloc] initWithFrame:unitRectS];// x y w h
  [byoLabel setByo];
  [cntView addSubview:byoLabel];
}

// 中央寄せ用 X座標算出
- (float)arignCenter:(int)w
{
  //画面情報(横幅)取得
  UIScreen *sc = [UIScreen mainScreen];
  CGRect rect = sc.bounds;

  float ret;
  
  // 現在が横向きの場合の対処
  UIDeviceOrientation o = [[UIDevice currentDevice] orientation];
  
  if(o == UIInterfaceOrientationPortrait || o == UIInterfaceOrientationPortraitUpsideDown){
    //Tate
    ret = ( rect.size.width - w ) / 2;

    // use next value is unknown case.
    [ud setFloat:ret forKey:@"beforeArignCenter"];

  }else if(o == UIInterfaceOrientationLandscapeLeft || o == UIInterfaceOrientationLandscapeRight){
    //Yoko
    ret = ( rect.size.height - w ) / 2;

    // use next value is unknown case.
    [ud setFloat:ret forKey:@"beforeArignCenter"];

  }else{
    ret = [ud floatForKey:@"beforeArignCenter"]; // 一つ前の状態を取得
  }
  
  return ret;
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
  
  // カウンター数値 表示位置補正
  cntLabel.frame = CGRectMake(0, 0, cntView.frame.size.width, cntView.frame.size.height);

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
    [self vibrateRoop];
    
    [self almSndChkPlay];
    
    timeUpOk = YES;
    cntUpFlag = YES;
  }
  
  [self chkDisp];
  
}



NSTimer* vibTimer;

- (void) vibrateRoop {
  if ([VibrateOnFlag val]==NO) {
    return;
  }
  
  vibCount = 0;
  vibTimer = [NSTimer
           scheduledTimerWithTimeInterval:1.0f
           target: self
           selector:@selector(vibrateRepeat:)
           userInfo:nil
           repeats:YES];
}

int vibCount;

- (void) vibrateRepeat:(CFRunLoopTimerRef *)timer {
//  NSLog(@"%d Vibration %s",__LINE__,__func__);
  AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
  vibCount++;
  
  if (vibCount > 2) {
    [vibTimer invalidate]; // timerをストップ
  }
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
  
  [clockSelectBtn ModeSelect:CGRectMake(15,7,135,50)    // x y w h // use ipad positioning
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
  
  [timerSelectBtn ModeSelect:CGRectMake(155,7,155,50)    // x y w h // use ipad positioning
                    btnTitle:[NSString stringWithFormat:@"%@",NSLocalizedString(@"btnTimer", nil)]];
  
  [timerSelectBtn setEnabled:NO]; // not default
  
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
    [self.view addSubview:timerSelectBtn]; // iphone
  }else{
    [cntView addSubview:timerSelectBtn];   // ipad
  }
  [timerSelectBtn addTarget:self action:@selector(timerSelectBtnTouch:) forControlEvents:UIControlEventTouchUpInside]; // タッチリリース時
  // ====== 「タイマー設定」ボタン（リンクテキスト風）ここまで ======
  
  
  // ====== 「Sound & Vibrator & ButtonZoom ON/OFF」Button From here ======
  infBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  sndBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  vibBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  bigBtn = [UIButton buttonWithType:UIButtonTypeCustom];
  
  [infBtn setImage:[UIImage imageNamed:@"IconInfo.png"]    forState:UIControlStateNormal];
  [infBtn setImage:[UIImage imageNamed:@"IconInfoTouch.png"] forState:UIControlStateHighlighted];

  [sndBtn setImage:[UIImage imageNamed:@"IconSndOn.png"]    forState:UIControlStateNormal];
  [sndBtn setImage:[UIImage imageNamed:@"IconSndTouch.png"] forState:UIControlStateHighlighted];

  [bigBtn setImage:[UIImage imageNamed:@"IconBigOn.png"]    forState:UIControlStateNormal];
  [bigBtn setImage:[UIImage imageNamed:@"IconBigTouch.png"] forState:UIControlStateHighlighted];

  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
    [self.view addSubview:infBtn];

    sndBtn.frame = CGRectMake(cntView.bounds.size.width -37,cntView.bounds.size.height -35,30,30); // x y w h
    bigBtn.frame = CGRectMake(cntView.bounds.size.width -37,cntView.frame.origin.y -50,30,30); // x y w h
    
    [vibBtn setImage:[UIImage imageNamed:@"IconVibOn.png"]    forState:UIControlStateNormal];
    vibBtn.frame = CGRectMake(cntView.bounds.size.width -66,cntView.bounds.size.height -36,32,32); // x y w h
    [cntView addSubview:vibBtn];
    
  }else{
    infBtn.frame = CGRectMake(cntView.bounds.size.width -60, 10, 50, 50); // x y w h
    [cntView addSubview:infBtn];

    sndBtn.frame = CGRectMake(cntView.bounds.size.width -60,cntView.bounds.size.height  -60,50,50); // x y w h
    bigBtn.frame = CGRectMake(cntView.bounds.size.width -60,cntView.bounds.size.height -110,50,50); // x y w h
  }
  [infBtn setImageEdgeInsets:UIEdgeInsetsMake(8.f, 8.f, 8.f, 8.f)]; // 上 左 下 右
  [infBtn addTarget:self action:@selector(infoBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
  
//  [sndBtn setBackgroundColor:[UIColor purpleColor]];
  [sndBtn setImageEdgeInsets:UIEdgeInsetsMake(6.f, 6.f, 6.f, 6.f)]; // 上 左 下 右
  [sndBtn addTarget:self action:@selector(sndBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
  [cntView addSubview:sndBtn];

//  [vibBtn setBackgroundColor:[UIColor yellowColor]];
  [vibBtn setImageEdgeInsets:UIEdgeInsetsMake(6.f, 6.f, 6.f, 6.f)]; // 上 左 下 右
  [vibBtn addTarget:self action:@selector(vibBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
  [cntView addSubview:vibBtn];
  
//  [bigBtn setBackgroundColor:[UIColor purpleColor]];
  [bigBtn setImageEdgeInsets:UIEdgeInsetsMake(6.f, 6.f, 6.f, 6.f)]; // 上 左 下 右
  [bigBtn addTarget:self action:@selector(bigBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
  [cntView addSubview:bigBtn];
  
  

  
  
  // ====== 「Sound & Vibrator & ButtonZoom ON/OFF」Button To here ======
}

/*
 * ボタン拡大アニメ(横)
 */
- (void)btnScaleUpYoko:(UIButton *)btn
{
  [self.view bringSubviewToFront:btn]; //最前面
  //拡大アニメーション
  [UIView beginAnimations:nil context:nil];
  [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
  [UIView setAnimationDuration:1.f];
  btn.frame = CGRectMake(3, // x
                         cntView.frame.size.height + cntView.frame.origin.y +3, // y
                         self.view.frame.size.height -6, // w
                         self.view.frame.size.width - (cntView.frame.size.height + cntView.frame.origin.y) -6 ); // h
  [UIView commitAnimations];
  [self.view.layer removeAllAnimations];
}
/*
 * ボタン拡大アニメ(縦)
 */
- (void)btnScaleUpTate:(UIButton *)btn
{
  [self.view bringSubviewToFront:btn]; //最前面
  //拡大アニメーション
  [UIView beginAnimations:nil context:nil];
  [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
  [UIView setAnimationDuration:1.f];
  btn.frame = CGRectMake(3, // x
                         cntView.frame.size.height + cntView.frame.origin.y +3, // y
                         self.view.frame.size.width -6, // w
                         self.view.frame.size.height - (cntView.frame.size.height + cntView.frame.origin.y) -6 ); // h
  [UIView commitAnimations];
  [self.view.layer removeAllAnimations];
}


/*
 * UIButton scale up method
 */
- (void)btnScaleUp:(UIButton *)btn
{
  if ([ResetBtnScaleOnFlag val] == NO) {

    int direction = self.interfaceOrientation;
    if(direction == UIInterfaceOrientationPortrait || direction == UIInterfaceOrientationPortraitUpsideDown){
      [self btnScaleUpTate:btn];
    }
    else if(direction == UIInterfaceOrientationLandscapeLeft || direction == UIInterfaceOrientationLandscapeRight){
      [self btnScaleUpYoko:btn];
    }

    [ResetBtnScaleOnFlag setValue:YES];
    [ResetBtnScaleOnFlag sync];
  }
}
/*
 * UIButton scale org method
 */
- (void)btnScaleOrg:(UIButton *)btn
{
  if ([ResetBtnScaleOnFlag val]) {

    //元に戻す アニメーション
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:0.5f];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
      setBtnReset.frame = CGRectMake([self arignCenter:0] -135, 220, 80, 60); // x y w h
    }else{
      setBtnReset.frame = CGRectMake([self arignCenter:0] -190 -115, 550, 190, 110); // x y w h
    }
    
    [UIView commitAnimations];
    [self.view.layer removeAllAnimations];
    [ResetBtnScaleOnFlag setValue:NO];
    [ResetBtnScaleOnFlag sync];
  }
}

/*
 * UIButton scale org method
 */
- (void)infoBtnTouch:(UIButton *)btn
{
  // InfoViewController生成
  InfoViewController* ivCtl = [[InfoViewController alloc] init];
  
  ivCtl.modalTransitionStyle = UIModalTransitionStylePartialCurl; // 下からめくり上げるスタイル
  
  // InfoViewを表示
  [self presentViewController: ivCtl animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}
@end
