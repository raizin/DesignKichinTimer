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


// View が初めて呼び出される時に1回だけ呼ばれる *定義済み関数
- (void)viewDidLoad
{
  [super viewDidLoad];
  
  [APP_DELEGATE setCntUpFlag:NO];  // カウントアップフラグ 初期状態
  [APP_DELEGATE setInWorkFlag:NO]; // 動作中フラグ 初期状態

  
  //UserDefaults 初期値
  [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"globalMinData"]; // M
  [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"globalSecData"]; // S
  
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
//  globalSec = 0;
//  globalMin = 0;
  [APP_DELEGATE setGlobalMin:0];
  [APP_DELEGATE setGlobalSec:0];
  
//  cntUpFlag = NO;
  timeUpOk = NO;
  
  
  //画面情報(横幅)取得
//  UIScreen *sc = [UIScreen mainScreen];
//  CGRect rect = sc.bounds;
//  CGFloat screenWidth = rect.size.width;
//  CGFloat screenHeight = rect.size.height;
//  NSLog(@"%d: w=%d h=%d",__LINE__,(int)screenWidth,(int)screenHeight); // iphone4s 320x480, ipad mini 768x1024
                                                // iphone5s 320x568
  
  int w = [UIScreen mainScreen].bounds.size.width;
//  int h = [UIScreen mainScreen].bounds.size.height;

  // カウンター表示エリアの横幅を定義
  cntW = w -20;  //300;
  cntH = (w -20) / 3;
  //cntH = (screenWidth -20) / 1.618; // 黄金比
  
  // 全体背景枠
  self.view.layer.backgroundColor = [UIColor whiteColor].CGColor;
  self.view.layer.cornerRadius = 50.0f;
  self.view.layer.frame = CGRectInset(self.view.layer.frame, 20, 20);
  
  //カウント表示View生成
  cntView = [[CntView alloc] initWithFrame:CGRectMake([self arignCenter:cntW], 60, cntW, cntH)];// x y w h
  [self.view addSubview:cntView];
  
  // カウント表示Label
  cntLabel = [[MyCntLabel alloc] initWithFrame:CGRectMake(-15,0,cntView.frame.size.width,cntView.frame.size.height)];
//  LOG(@"x=%d y=%d",(int)cntLabel.center.x,(int)cntLabel.center.y);
  [cntView addSubview:cntLabel];
  
  // History Label
  hisLabel = [[HistLabel alloc] init];// x y w h
  [hisLabel setEnable:YES];
  if (
        (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"historySecData1"]
      + (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"historyMinData1"] < 1)
  {
    [hisLabel setEnable:NO];
  }
  [self.view addSubview:hisLabel];
  
  
  
  /*** 表示切り替え(ボタン)配置 ***/
  [self btnLinkSelect];//「現在時モード」「タイマーモード」
  
  
  
  /*** カウンタ数値セットボタンUI定義 ここから ***/

  setBtn10 = [PlusNnBtn buttonWithType:UIButtonTypeCustom];[setBtn10 setTag:10];
  [setBtn10 addTarget:self action:@selector(btn10Touch) forControlEvents:UIControlEventTouchUpInside];
  [setBtn10 addGestureRecognizer:[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(lPress:)]];
  [self.view addSubview:setBtn10];
  
  setBtn05 = [PlusNnBtn buttonWithType:UIButtonTypeCustom];[setBtn05 setTag:5];
  [setBtn05 addTarget:self action:@selector(btn05Touch) forControlEvents:UIControlEventTouchUpInside];
  [setBtn05 addGestureRecognizer:[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(lPress:)]];
  [self.view addSubview:setBtn05];
  
  setBtn03 = [PlusNnBtn buttonWithType:UIButtonTypeCustom];[setBtn03 setTag:3];
  [setBtn03 addTarget:self action:@selector(btn03Touch) forControlEvents:UIControlEventTouchUpInside];
  [setBtn03 addGestureRecognizer:[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(lPress:)]];
  [self.view addSubview:setBtn03];
  
  setBtn01 = [PlusNnBtn buttonWithType:UIButtonTypeCustom];[setBtn01 setTag:1];
  [setBtn01 addTarget:self action:@selector(btn01Touch) forControlEvents:UIControlEventTouchUpInside];
  [setBtn01 addGestureRecognizer:[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(lPress:)]];
  [self.view addSubview:setBtn01];

  setBtnReset = [ResetBtn buttonWithType:UIButtonTypeCustom];
  [setBtnReset addTarget:self action:@selector(resetBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:setBtnReset];
  
  setBtn001 = [PlusNnBtn buttonWithType:UIButtonTypeCustom];[setBtn001 setTag:100];
  [setBtn001 addTarget:self action:@selector(btn001Touch) forControlEvents:UIControlEventTouchUpInside];
  [setBtn001 addGestureRecognizer:[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(lPress:)]];
  [self.view addSubview:setBtn001];

  setBtnStart = [StartBtn buttonWithType:UIButtonTypeCustom];
  [setBtnStart addTarget:self action:@selector(startBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:setBtnStart];

  setBtnHis1 = [HistNnBtn buttonWithType:UIButtonTypeCustom];[setBtnHis1 setNum:1];
  [setBtnHis1 addTarget:self action:@selector(btnHis1Touch:) forControlEvents:UIControlEventTouchUpInside];
  if ((int)[[NSUserDefaults standardUserDefaults] integerForKey:@"historySecData1"] + (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"historyMinData1"] == 0) {
    [setBtnHis1 setEnabled:NO];
  }
  [self.view addSubview:setBtnHis1];
  
  setBtnHis2 = [HistNnBtn buttonWithType:UIButtonTypeCustom];[setBtnHis2 setNum:2];
  [setBtnHis2 addTarget:self action:@selector(btnHis2Touch:) forControlEvents:UIControlEventTouchUpInside];
  if ((int)[[NSUserDefaults standardUserDefaults] integerForKey:@"historySecData2"] + (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"historyMinData2"] == 0) {
    [setBtnHis2 setEnabled:NO];
  }
  [self.view addSubview:setBtnHis2];
  
  setBtnHis3 = [HistNnBtn buttonWithType:UIButtonTypeCustom];[setBtnHis3 setNum:3];
  [setBtnHis3 addTarget:self action:@selector(btnHis3Touch:) forControlEvents:UIControlEventTouchUpInside];
  if ((int)[[NSUserDefaults standardUserDefaults] integerForKey:@"historySecData3"] + (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"historyMinData3"] == 0) {
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

// 画面が表示される直前に呼び出される *定義済み関数
- (void)viewWillAppear:(BOOL)animated
{
}

// デバイスが回転した際に、呼び出されるメソッド(※自作)
- (void) didRotate:(NSNotification *)notification {
//  UIDeviceOrientation o = [[notification object] orientation];
  UIDeviceOrientation o = [[UIDevice currentDevice] orientation];
  
  
  // iphone かつ Home button top の場合のみ 動作がおかしいので止める
  if (o == UIDeviceOrientationPortraitUpsideDown && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
    return;
  }

  if (   o == UIDeviceOrientationLandscapeLeft
      || o == UIDeviceOrientationLandscapeRight
      || o == UIDeviceOrientationPortrait
      || o == UIDeviceOrientationPortraitUpsideDown) {

    // Free版とPro版の分岐用フラグ取得
    NSString* freeFlagStr  = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"FreeVersionFlag"];
    BOOL freeFlag = [freeFlagStr boolValue];

    
    //X軸の中心を取得
    int centerPoint = [self arignCenter:0];

    // self.viewから取得すると回転時に変化(逆になったりならなかったり)するため以下のように縦横サイズを取得する
    CGFloat baseW = [UIScreen mainScreen].bounds.size.width;
    CGFloat baseH = [UIScreen mainScreen].bounds.size.height;
    
    // 端末毎に配置調整
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
      // iPhone
      
      // Viewの位置とサイズを補正してセット
      [cntView setCenter:CGPointMake(centerPoint, 85)];
    
      [setBtn10 setCenter:CGPointMake(centerPoint -121, 170)];
      [setBtn05 setCenter:CGPointMake(centerPoint  -40, 180)];
      [setBtn03 setCenter:CGPointMake(centerPoint  +40, 180)];
      [setBtn01 setCenter:CGPointMake(centerPoint +121, 170)];
      
      [setBtnReset setCenter:CGPointMake(centerPoint -100, 250)];
      [setBtn001 setCenter:CGPointMake(centerPoint, 240)];
      [setBtnStart setCenter:CGPointMake(centerPoint +100, 250)];
      
      [clockSelectBtn setCenter:CGPointMake(centerPoint -78, 22)];
      [timerSelectBtn setCenter:CGPointMake(centerPoint +62, 22)];

      [infBtn setCenter:CGPointMake(self.view.frame.size.width -17, 17)];

      // 横向き時のみ表示されるように位置を調整
      [hisLabel   setCenter:CGPointMake(centerPoint +190,  45)];//x,y
      [setBtnHis1 setCenter:CGPointMake(centerPoint +190,  75)];
      [setBtnHis2 setCenter:CGPointMake(centerPoint +190, 105)];
      [setBtnHis3 setCenter:CGPointMake(centerPoint +190, 135)];
 
      // 横向き時の調整
      if (o == UIDeviceOrientationLandscapeLeft || o == UIDeviceOrientationLandscapeRight) {
        [infBtn setCenter:CGPointMake(self.view.frame.size.width +126, 17)];
        
        if ([ResetBtnScaleOnFlag val]) {
          [self btnScaleUpYoko:setBtnReset];
        }

        if (freeFlag) {
          //フリー版はバナー広告配置調整
          [self RotatedAdView:baseH baseHigh:baseW];
        }
      }else{
        if ([ResetBtnScaleOnFlag val]) {
          [self btnScaleUpTate:setBtnReset];
        }
        if (freeFlag) {
          //フリー版はバナー広告配置調整
          [self RotatedAdView:baseW baseHigh:baseH];
        }
      }
      
    }else{
      //iPad

      // Viewの位置とサイズを補正してセット
      [cntView setCenter:CGPointMake(centerPoint, 184)];
      
      [setBtn10 setCenter:CGPointMake(centerPoint -285, 400)];
      [setBtn05 setCenter:CGPointMake(centerPoint  -95, 455)];
      [setBtn03 setCenter:CGPointMake(centerPoint  +95, 455)];
      [setBtn01 setCenter:CGPointMake(centerPoint +285, 400)];
      
      [setBtnReset setCenter:CGPointMake(centerPoint -230, 605)];
      [setBtn001   setCenter:CGPointMake(centerPoint, 590)];
      [setBtnStart setCenter:CGPointMake(centerPoint +230, 605)];
      
      [clockSelectBtn setCenter:CGPointMake(centerPoint -290, 38)];
      [timerSelectBtn setCenter:CGPointMake(centerPoint  -85, 38)];

      [infBtn setCenter:CGPointMake(self.view.frame.size.width -35, 30)];
//      LOG(@"center=%d x=%d y=%d",centerPoint,(int)infBtn.center.x,(int)infBtn.center.y);

      // 横向き時のみ表示されるように位置を調整
      [hisLabel   setCenter:CGPointMake(centerPoint +430,  80)];
      [setBtnHis1 setCenter:CGPointMake(centerPoint +430, 135)];
      [setBtnHis2 setCenter:CGPointMake(centerPoint +430, 200)];
      [setBtnHis3 setCenter:CGPointMake(centerPoint +430, 265)];
      
      // 横向き時の調整
      if (o == UIDeviceOrientationLandscapeLeft || o == UIDeviceOrientationLandscapeRight) {
        [infBtn setCenter:CGPointMake(self.view.frame.size.width +200, 30)];

        if ([ResetBtnScaleOnFlag val]) {
          [self btnScaleUpYoko:setBtnReset];
        }
        if (freeFlag) {
          //フリー版はバナー広告配置調整
          [self RotatedAdView:baseH baseHigh:baseW];
        }
      }else{
        if ([ResetBtnScaleOnFlag val]) {
          [self btnScaleUpTate:setBtnReset];
        }
        if (freeFlag) {
          //フリー版はバナー広告配置調整
          [self RotatedAdView:baseW baseHigh:baseH];
        }
      }
      
      
    }
  }
}

/*
 * タイマー用タイマー開始定義
 */
- (void)startTimerTimer {
  timerTm = [NSTimer scheduledTimerWithTimeInterval:1.f //タイマーを発生させる間隔（1.0秒毎）
                                             target:self //メソッドがあるオブジェクト
                                           selector:@selector(timerTimer:) //呼び出すメソッド
                                           userInfo:nil //メソッドに渡すパラメータ
                                            repeats:YES]; //繰り返し
}

/*
 * タイマー用タイマー実行処理
 */
- (void)timerTimer:(NSTimer *)timer
{
  [APP_DELEGATE setInWorkFlag:YES];
  
  if ([APP_DELEGATE globalSec] == 0 && [APP_DELEGATE globalMin] == 0) {
    [APP_DELEGATE setCntUpFlag:YES];
  }
  
  if ([APP_DELEGATE cntUpFlag]) {
    [self cntUpTimer];
  }else{
    [self cntDnTimer];
  }
  
  // 画面が消えても起動しつづける？
//  [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
  // 1秒間だけ、外部からのメソッド実行要求を受け付ける
//  [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate dateWithTimeIntervalSinceNow:1]];
}




/*
 * タイマー用タイマー停止(リセット)関数
 */
- (void)resetTimerTimer {
  [APP_DELEGATE setInWorkFlag:NO];
  
  if ([timerTm isValid]) {
    [timerTm invalidate];
  }
  
  // Reset処理
//  globalSec = 0;
//  globalMin = 0;
  [APP_DELEGATE setGlobalMin:0];
  [APP_DELEGATE setGlobalSec:0];
  
  cntLabel.text = @"000 00"; // 表示テキストもクリア
}

/*
 * タイマー用タイマーStop(一時停止)関数
 */
- (void)pauseTimerTimer {
  [APP_DELEGATE setInWorkFlag:NO];
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

- (void)btnDisabledAll
{
  [setBtn10 setEnabled:NO];
  [setBtn05 setEnabled:NO];
  [setBtn03 setEnabled:NO];
  [setBtn01 setEnabled:NO];
  [setBtn001 setEnabled:NO];
  [setBtnStart setEnabled:NO];
  [setBtnReset setEnabled:NO];
  [hisLabel setEnable:NO];
  [setBtnHis1 setEnabled:NO];
  [setBtnHis2 setEnabled:NO];
  [setBtnHis3 setEnabled:NO];
}
- (void)btnEnabledAll
{
  [setBtn10 setEnabled:YES];
  [setBtn05 setEnabled:YES];
  [setBtn03 setEnabled:YES];
  [setBtn01 setEnabled:YES];
  [setBtn001 setEnabled:YES];
  [setBtnStart setEnabled:YES];
  [setBtnReset setEnabled:YES];
  
  if ((int)[[NSUserDefaults standardUserDefaults] integerForKey:@"historySecData1"] + (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"historyMinData1"] >= 1) {
    [hisLabel setEnable:YES];
  }
  if ((int)[[NSUserDefaults standardUserDefaults] integerForKey:@"historySecData1"] + (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"historyMinData1"] >= 1) {
    [setBtnHis1 setEnabled:YES];
  }
  if ((int)[[NSUserDefaults standardUserDefaults] integerForKey:@"historySecData2"] + (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"historyMinData2"] >= 1) {
    [setBtnHis2 setEnabled:YES];
  }
  if ((int)[[NSUserDefaults standardUserDefaults] integerForKey:@"historySecData3"] + (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"historyMinData3"] >= 1) {
    [setBtnHis3 setEnabled:YES];
  }
  
  if ([BtnZoomOnFlag val]) {
    [self btnScaleOrg:setBtnReset]; //縮小アニメ
  }
}
- (void)btnEnableOnlyReset
{
  [setBtn10 setEnabled:NO];
  [setBtn05 setEnabled:NO];
  [setBtn03 setEnabled:NO];
  [setBtn01 setEnabled:NO];
  [setBtn001 setEnabled:NO];
  [setBtnStart setEnabled:NO];
  [setBtnReset setEnabled:YES];
  [hisLabel setEnable:NO];
  [setBtnHis1 setEnabled:NO];
  [setBtnHis2 setEnabled:NO];
  [setBtnHis3 setEnabled:NO];
  if ([BtnZoomOnFlag val]) {
    [self btnScaleUp:setBtnReset]; //拡大アニメ
  }
}
- (void)btnEnableOnlyStartReset
{
  [setBtn10 setEnabled:NO];
  [setBtn05 setEnabled:NO];
  [setBtn03 setEnabled:NO];
  [setBtn01 setEnabled:NO];
  [setBtn001 setEnabled:NO];
  [setBtnStart setEnabled:YES];
  [setBtnReset setEnabled:YES];
  [hisLabel setEnable:NO];
  [setBtnHis1 setEnabled:NO];
  [setBtnHis2 setEnabled:NO];
  [setBtnHis3 setEnabled:NO];
  if ([BtnZoomOnFlag val]) {
    [self btnScaleOrg:setBtnReset]; //縮小アニメ
  }
}

- (void)cntPlusChk
{
  [APP_DELEGATE setCntUpFlag:NO]; // タイマー設定後は必ずカウントダウン
  [self setAddHistoryFlag:YES];    // タイマー設定後の値のみ、履歴追加可能
  
  if ([APP_DELEGATE globalSec] >= 60) {
//    globalMin++;
    [APP_DELEGATE setGlobalMin:[APP_DELEGATE globalMin]+1];

    if ([APP_DELEGATE globalMin] >= 999) {
//      globalSec = 59;
      [APP_DELEGATE setGlobalSec:59];
    }else{
//      globalSec -= 60;
      [APP_DELEGATE setGlobalSec:0];
    }
  }
  if ([APP_DELEGATE globalMin] >= 999) {
//    globalMin = 999;
    [APP_DELEGATE setGlobalMin:999];
  }

  [self chkDisp];
}


- (void)btn001Touch
{
  [self btnSndChkPlay];//効果音再生
  [APP_DELEGATE setGlobalSec:[APP_DELEGATE globalSec]+10];
  [self cntPlusChk];
}
- (void)btn01Touch
{
  [self btnSndChkPlay];
  [APP_DELEGATE setGlobalMin:[APP_DELEGATE globalMin]+1];
  [self cntPlusChk];
}
- (void)btn03Touch
{
  [self btnSndChkPlay];
  [APP_DELEGATE setGlobalMin:[APP_DELEGATE globalMin]+3];
  [self cntPlusChk];
}
- (void)btn05Touch
{
  [self btnSndChkPlay];
  [APP_DELEGATE setGlobalMin:[APP_DELEGATE globalMin]+5];
  [self cntPlusChk];
}
- (void)btn10Touch
{
  [self btnSndChkPlay];
  [APP_DELEGATE setGlobalMin:[APP_DELEGATE globalMin]+10];
  [self cntPlusChk];
}


//長押し時のタイマー
- (void)lpTimer:(NSTimer *)timer
{
//  LOG(@"tmp.tag=%d",[(NSNumber*)timer.userInfo intValue]);
  
  switch ([(NSNumber*)timer.userInfo intValue]) {
    case 100:
      [self btn001Touch];
      break;
    case 10:
      [self btn10Touch];
      break;
    case 5:
      [self btn05Touch];
      break;
    case 3:
      [self btn03Touch];
      break;
    case 1:
      [self btn01Touch];
      break;
      
    default:
      break;
  }
}

//長押し対応メソッド
-(void)lPress:(UILongPressGestureRecognizer *)gRecognizer
{
//  LOG(@"tag=%d",gRecognizer.view.tag);
  
//  NSNumber tmp = gRecognizer.view.tag;
  [NSNumber numberWithInt:(int)gRecognizer.view.tag];
  
  switch (gRecognizer.state) {
    case UIGestureRecognizerStateBegan:
      //長押しを検知開始
      if (!lPTimer) {
        lPTimer = [NSTimer scheduledTimerWithTimeInterval:0.15f //タイマーを発生させる間隔（0.3秒毎）
                                                 target:self //メソッドがあるオブジェクト
                                               selector:@selector(lpTimer:) //呼び出すメソッド
                                               userInfo:[NSNumber numberWithInt:(int)gRecognizer.view.tag]//パラメータ引数
                                                repeats:YES]; //繰り返し
      }
      break;
    case UIGestureRecognizerStateEnded:
      //長押し終了時
      if ([lPTimer isValid]) {
        [lPTimer invalidate];
        lPTimer = nil;//破棄
      }
      
      if (gRecognizer.view.tag == 100) {
        [setBtn001 btnTouchUp];
      } else
      if (gRecognizer.view.tag == 10) {
        [setBtn10 btnTouchUp];
      } else
      if (gRecognizer.view.tag == 5) {
        [setBtn05 btnTouchUp];
      } else
      if (gRecognizer.view.tag == 3) {
        [setBtn03 btnTouchUp];
      } else
      if (gRecognizer.view.tag == 1) {
        [setBtn01 btnTouchUp];
      }
      break;
    default:
      break;
  }
}



- (void)resetBtnTouch:(id)sender
{
  [self btnSndChkPlay];//効果音再生
  [alermSound stop]; // 再生停止

  // リセットボタンの文言を「リセット」にする。
  [setBtnReset setReset:YES];
//  [APP_DELEGATE setCntUpFlag:NO];
  
  if ([timerTm isValid]) {
    // タイマーが動いている場合は、一時停止
    [self pauseTimerTimer];
    [self btnEnableOnlyStartReset];

    if (timeUpOk) {
      [APP_DELEGATE setGlobalMin:(int)[[NSUserDefaults standardUserDefaults] integerForKey:@"globalMinData"]];
      [APP_DELEGATE setGlobalSec:(int)[[NSUserDefaults standardUserDefaults] integerForKey:@"globalSecData"]];
//      globalMin = (int)[ud integerForKey:@"globalMinData"];
//      globalSec = (int)[ud integerForKey:@"globalSecData"];
      [self chkDisp];
      [self btnEnabledAll];
      
      timeUpOk = NO;
      [APP_DELEGATE setCntUpFlag:NO];
//      LOG(@"koko1");
//    }else{
//      LOG(@"koko2");
    }
    
  } else {

    [self resetTimerTimer];
    [self btnEnabledAll];
  }
}

- (void)startBtnTouch:(id)sender
{
  [self btnSndChkPlay];//効果音再生

  // リセットボタンの文言を「ストップ」にする。
  [setBtnReset setReset:NO];
  
  //UserDefaults このメソッド内のみで定義
  NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];

  //Set Data Memory
  [ud setInteger:[APP_DELEGATE globalMin] forKey:@"globalMinData"];  // M
  [ud setInteger:[APP_DELEGATE globalSec] forKey:@"globalSecData"];  // S

  
  if (
      [APP_DELEGATE globalMin] == (int)[ud integerForKey:@"historyMinData1"] &&
      [APP_DELEGATE globalSec] == (int)[ud integerForKey:@"historySecData1"]
      ) {
    [self setAddHistoryFlag:NO];
    
    // 履歴１と同じ内容であれば追加しない。
  }
  

  if ([APP_DELEGATE globalMin] + [APP_DELEGATE globalSec] > 0 && [self addHistoryFlag]) {
    
    // 履歴２を履歴３へ移す
    [ud setInteger:(int)[ud integerForKey:@"historyMinData2"] forKey:@"historyMinData3"];  // M
    [ud setInteger:(int)[ud integerForKey:@"historySecData2"] forKey:@"historySecData3"];  // S
    
    // 履歴１を履歴２へ移す
    [ud setInteger:(int)[ud integerForKey:@"historyMinData1"] forKey:@"historyMinData2"];  // M
    [ud setInteger:(int)[ud integerForKey:@"historySecData1"] forKey:@"historySecData2"];  // S
    
    // セットを履歴１へ残す
    [ud setInteger:[APP_DELEGATE globalMin] forKey:@"historyMinData1"];  // M
    [ud setInteger:[APP_DELEGATE globalSec] forKey:@"historySecData1"];  // S
  }
  
  [ud synchronize];
  
  
  [self startTimerTimer];
  [self btnEnableOnlyReset];
}



- (void)btnHis1Touch:(id)sender
{
  [self btnSndChkPlay];//効果音再生
//  globalMin = (int)[ud integerForKey:@"historyMinData1"];
//  globalSec = (int)[ud integerForKey:@"historySecData1"];
  [APP_DELEGATE setGlobalMin:(int)[[NSUserDefaults standardUserDefaults] integerForKey:@"historyMinData1"]];
  [APP_DELEGATE setGlobalSec:(int)[[NSUserDefaults standardUserDefaults] integerForKey:@"historySecData1"]];
  [self cntPlusChk];
}
- (void)btnHis2Touch:(id)sender
{
  [self btnSndChkPlay];//効果音再生
  [APP_DELEGATE setGlobalMin:(int)[[NSUserDefaults standardUserDefaults] integerForKey:@"historyMinData2"]];
  [APP_DELEGATE setGlobalSec:(int)[[NSUserDefaults standardUserDefaults] integerForKey:@"historySecData2"]];
  [self cntPlusChk];
}
- (void)btnHis3Touch:(id)sender
{
  [self btnSndChkPlay];//効果音再生
  [APP_DELEGATE setGlobalMin:(int)[[NSUserDefaults standardUserDefaults] integerForKey:@"historyMinData3"]];
  [APP_DELEGATE setGlobalSec:(int)[[NSUserDefaults standardUserDefaults] integerForKey:@"historySecData3"]];
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
 * 「タイマー表示」ボタン用イベント
 */
- (void) timerSelectBtnTouch:(id)sender
{
  // カウンター数値 表示位置補正
  [cntLabel setCenter:CGPointMake(cntView.frame.size.width /2 -15, cntView.frame.size.height /2)];
//  LOG(@"x=%d y=%d",(int)cntLabel.center.x,(int)cntLabel.center.y);

  // タイマーモード
  cntMode = YES;
  [self chkDisp];
  cntLabel.alpha = 0.f;

  [clockSelectBtn setEnabled:YES];
  [timerSelectBtn setEnabled:NO];

  if ([timerTm isValid]) {
    // タイマーが動いている場合はリセットボタンのみ活性化
    [self btnEnableOnlyReset];
  } else {
    
    if ([APP_DELEGATE globalMin] > 0 || [APP_DELEGATE globalSec] > 0) {
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

  
  /*** 分(')・秒(")のラベルを作成して表示 ***/
  hunLabel = [[HunUnitLabel alloc] init];// x y w h
  [cntView addSubview:hunLabel];
  
  byoLabel = [[ByoUnitLabel alloc] init];// x y w h
  [cntView addSubview:byoLabel];
  
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
    //iPhone
    [hunLabel setCenter:CGPointMake(153, 31)];
    [byoLabel setCenter:CGPointMake(251, 31)];
  }else{
    //iPad
    [hunLabel setCenter:CGPointMake(400, 82)];
    [byoLabel setCenter:CGPointMake(645, 82)];
//    LOG(@"x=%d y=%d",(int)hunLabel.center.x,(int)hunLabel.center.y);
//    LOG(@"x=%d y=%d",(int)byoLabel.center.x,(int)byoLabel.center.y);
  }
}

// 中央寄せ用 X座標算出
- (float)arignCenter:(int)componentW
{
  //画面情報(横幅)取得
  int w = [UIScreen mainScreen].bounds.size.width;
  int h = [UIScreen mainScreen].bounds.size.height;

  float ret;
  
  // 現在が横向きの場合の対処
  UIDeviceOrientation o = [[UIDevice currentDevice] orientation];
  
  if(o == UIInterfaceOrientationPortrait || o == UIInterfaceOrientationPortraitUpsideDown){
    //Tate
    ret = ( w - componentW ) / 2;

    // use next value is unknown case.
    [[NSUserDefaults standardUserDefaults] setFloat:ret forKey:@"beforeArignCenter"];

  }else if(o == UIInterfaceOrientationLandscapeLeft || o == UIInterfaceOrientationLandscapeRight){
    //Yoko
    ret = ( h - componentW ) / 2;

    // use next value is unknown case.
    [[NSUserDefaults standardUserDefaults] setFloat:ret forKey:@"beforeArignCenter"];

  }else{
    ret = [[NSUserDefaults standardUserDefaults] floatForKey:@"beforeArignCenter"]; // 一つ前の状態を取得
  }
  
  return ret;
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
  
  int hour = (int)[todayComponents hour];
  int min  = (int)[todayComponents minute];
  int sec  = (int)[todayComponents second];
  
  //  // 年月日,曜日表示
  //  nowDate.text = [NSString stringWithFormat:@"%04d/%02d/%02d (%@)",nenn,tuki,niti,[self stringShortweekday:weekIndex]];
  
  // 時間を表示
  // カウンター数値 表示位置補正
  [cntLabel setCenter:CGPointMake(cntView.frame.size.width /2, cntView.frame.size.height /2)];
//  LOG(@"x=%d y=%d",(int)cntLabel.center.x,(int)cntLabel.center.y);

  [cntLabel setText:[NSString stringWithFormat:@"%02d:%02d:%02d",hour,min,sec]];
  
  [self lbFadein:cntLabel];
}




// カウントアップ時の処理
- (void)cntUpTimer
{
  [APP_DELEGATE cntUp:1];
  
  if ([APP_DELEGATE globalSec] > 59 && [APP_DELEGATE globalMin] > 999) {
      [self pauseTimerTimer];
  }
  [self chkDisp];
}

// カウントダウン時の処理
- (void)cntDnTimer
{
  [APP_DELEGATE cntDn:1];
  
  if ([APP_DELEGATE globalSec] == 0 && [APP_DELEGATE globalMin] == 0) {
   
    // Vibrate
    [self vibrateRoop];
    [self almSndChkPlay];
    
    timeUpOk = YES;
    [APP_DELEGATE setCntUpFlag:YES];
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
  AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
  vibCount++;
  
  if (vibCount > 2) {
    [vibTimer invalidate]; // timerをストップ
  }
}



// 表示反映関数
- (void)chkDisp
{
  // Check is Mode
  if (cntMode) {
    cntLabel.text = [NSString stringWithFormat:@"%03d %02d",[APP_DELEGATE globalMin],(int)[APP_DELEGATE globalSec]];
  }
}


/*** ボタン類 配置 関数 ***/
- (void)btnLinkSelect
{
  //「現在時表示」ボタン（リンクテキスト風）
  clockSelectBtn = [ModeClockBtn buttonWithType:UIButtonTypeCustom];
  [clockSelectBtn setEnabled:YES]; // default
  [clockSelectBtn addTarget:self action:@selector(clockSelectBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:clockSelectBtn];
  
  //「タイマー設定」ボタン（リンクテキスト風）
  timerSelectBtn = [ModeTimerBtn buttonWithType:UIButtonTypeCustom];
  [timerSelectBtn setEnabled:NO]; // not default
  [timerSelectBtn addTarget:self action:@selector(timerSelectBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:timerSelectBtn];
  
  
  // ====== 「Sound & Vibrator & ButtonZoom ON/OFF」Button From here ======
  infBtn = [InfoBtn buttonWithType:UIButtonTypeCustom];
  sndBtn = [ToggleBtn buttonWithType:UIButtonTypeCustom];
  vibBtn = [ToggleBtn buttonWithType:UIButtonTypeCustom];
  bigBtn = [ToggleBtn buttonWithType:UIButtonTypeCustom];
  
  [infBtn setImage:[UIImage imageNamed:@"IconInfo25.png"]      forState:UIControlStateNormal];
  [infBtn setImage:[UIImage imageNamed:@"IconInfoTouch25.png"] forState:UIControlStateHighlighted];
  [infBtn addTarget:self action:@selector(infoBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:infBtn];

  [sndBtn setImage:[UIImage imageNamed:@"IconSndOn.png"]    forState:UIControlStateNormal];
  [sndBtn setImage:[UIImage imageNamed:@"IconSndTouch.png"] forState:UIControlStateHighlighted];
  [sndBtn addTarget:self action:@selector(sndBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
  [cntView addSubview:sndBtn];

  [bigBtn setImage:[UIImage imageNamed:@"IconBigOn.png"]    forState:UIControlStateNormal];
  [bigBtn setImage:[UIImage imageNamed:@"IconBigTouch.png"] forState:UIControlStateHighlighted];
  [bigBtn addTarget:self action:@selector(bigBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
  [cntView addSubview:bigBtn];

  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
    //iPhone

    [sndBtn setCenter:CGPointMake(278, 80)];
    [bigBtn setCenter:CGPointMake(278, 25)];
    
    [vibBtn setImage:[UIImage imageNamed:@"IconVibOn.png"] forState:UIControlStateNormal];
    [vibBtn setImage:[UIImage imageNamed:@"IconVibTouch.png"] forState:UIControlStateHighlighted];
    [vibBtn addTarget:self action:@selector(vibBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
    [vibBtn setCenter:CGPointMake(250, 80)];
    [cntView addSubview:vibBtn];
    
  }else{
    //iPad

    [sndBtn setCenter:CGPointMake(713, 214-45)];//x,y
    [bigBtn setCenter:CGPointMake(713, 264-45)];//x,y
    
    [infBtn setImage:[UIImage imageNamed:@"IconInfo40.png"]      forState:UIControlStateNormal];
    [infBtn setImage:[UIImage imageNamed:@"IconInfoTouch40.png"] forState:UIControlStateHighlighted];
  }
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
  
  
  int iAdBannerHeight = 0;
  
  NSString* freeFlagStr  = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"FreeVersionFlag"];
  BOOL freeFlag = [freeFlagStr boolValue];
  if (freeFlag) {
    //フリー版はバナー広告分 小さくする
    iAdBannerHeight = iAdView.frame.size.height;
  }
  btn.frame = CGRectMake(3, // x
                         cntView.frame.size.height + cntView.frame.origin.y +3, // y
                         self.view.frame.size.height -6, // w
                         self.view.frame.size.width - (cntView.frame.size.height + cntView.frame.origin.y) -6 -iAdBannerHeight ); // h
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
  
  int iAdBannerHeight = 0;
  
  NSString* freeFlagStr  = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"FreeVersionFlag"];
  BOOL freeFlag = [freeFlagStr boolValue];
  if (freeFlag) {
    //フリー版はバナー広告分 小さくする
    iAdBannerHeight = iAdView.frame.size.height;
  }
  
  
  btn.frame = CGRectMake(3, // x
                         cntView.frame.size.height + cntView.frame.origin.y +3, // y
                         self.view.frame.size.width -6, // w
                         self.view.frame.size.height - (cntView.frame.size.height + cntView.frame.origin.y) -6 -iAdBannerHeight ); // h
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
      [setBtnReset setFrame:CGRectMake([self arignCenter:0] -100 -(setBtnStart.frame.size.width/2), //x
                                       250 -(setBtnStart.frame.size.height/2), //y
                                       setBtnStart.frame.size.width, setBtnStart.frame.size.height)];//w,h
    }else{
      [setBtnReset setFrame:CGRectMake([self arignCenter:0] -230 -(setBtnStart.frame.size.width/2), //x
                                       605 -(setBtnStart.frame.size.height/2), //y
                                       setBtnStart.frame.size.width, setBtnStart.frame.size.height)];//w,h
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




-(void)bannerInit
{
  int w = [UIScreen mainScreen].bounds.size.width;
  int h = [UIScreen mainScreen].bounds.size.height;
  
  // iAd View Create
  iAdView = [[ADBannerView alloc] initWithFrame:CGRectZero];
  iAdView.delegate = (id<ADBannerViewDelegate>)self;
  iAdView.autoresizesSubviews = YES;
  iAdView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
  iAdView.alpha = 0.1;
  
  // 現在の画面の回転状態を取得
  UIInterfaceOrientation o = [[UIApplication sharedApplication] statusBarOrientation];
  if(o == UIInterfaceOrientationLandscapeLeft || o == UIInterfaceOrientationLandscapeRight){
    //Yoko
    [self RotatedAdView:h baseHigh:w];
  }else{
    //Tate
    [self RotatedAdView:w baseHigh:h];
  }
  
  [self.view addSubview:iAdView];
  bannerIsVisible = NO;
}
- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
  //  NSLog(@"%d: iAd Get Success!!",__LINE__);
  
  if (!bannerIsVisible) {
    [UIView beginAnimations:@"animateAdBannerOn" context:NULL];
    [UIView setAnimationDuration:0.6];//0.6 Second
    
    banner.alpha = 0.8;
    banner.hidden = NO;
    
    [UIView commitAnimations];
    
    bannerIsVisible = YES;
    [self.view addSubview:iAdView];
  }
}
- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
  NSLog(@"iAd get NG %@",error.description);
  [self iAdDisable:NO];
}
// iAdを停止する adDel＝ YES:xボタンで一定時間隠す NO:iAd失敗時隠す
-(void)iAdDisable:(BOOL)adDel
{
  
  if (adDel) {
    [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
    [UIView setAnimationDuration:3.0];//3.0 Secound
    
    iAdView.alpha = 0.1;
    
    [UIView commitAnimations];

  }else{
    
    if (bannerIsVisible) {
      [UIView beginAnimations:@"animateAdBannerOff" context:NULL];
      [UIView setAnimationDuration:3.0];//3.0 Secound
      
      iAdView.alpha = 0.1;
      
      [UIView commitAnimations];
      
      bannerIsVisible = NO;
    }
    
  }
  
}

//デバイスの向きを考慮した上で引数を渡し、配置を調整
-(void)RotatedAdView:(int)baseSize baseHigh:(int)h
{
  int xCenter = baseSize/2;
  if (iAdView) {
    iAdView.frame = CGRectMake(0, 0, baseSize, iAdView.frame.size.height);//w,h
    iAdView.center = CGPointMake(xCenter, h - (iAdView.frame.size.height / 2));//x,y
  }
}






- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}
@end
