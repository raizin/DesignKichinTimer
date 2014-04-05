//
//  ViewController.h
//  DesignKichinTimer
//
//  Created by z on 2013/10/18.
//  Copyright (c) 2013 FoceSystemSolution. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
//#import <QuartzCore/CoreAnimation.h>
//#import <iAd/iAd.h>
#import "ModeTimerBtn.h"
#import "ModeClockBtn.h"
#import "MyCntLabel.h"
#import "InfoViewController.h"
#import "CntView.h"
#import "PlusNnBtn.h"
#import "HistNnBtn.h"
#import "HistLabel.h"
#import "StartBtn.h"
#import "ResetBtn.h"
#import "InfoBtn.h"
#import "ToggleBtn.h"
#import "ByoUnitLabel.h"
#import "HunUnitLabel.h"

@interface ViewController : UIViewController {
  
  //NSUserDefaults領域を使用
//  NSUserDefaults *ud;

  //Sound
  AVAudioPlayer *pressBtnSnd;
  AVAudioPlayer *alermSound;
  
  // タイマー定義
  NSTimer *clockTm;
  NSTimer *timerTm;

//  int globalMin;// 00~999
//  int globalSec;// 00~59
  
  int historyMin1;
  int historySec1;
  int historyMin2;
  int historySec2;
  int historyMin3;
  int historySec3;

//  BOOL cntUpFlag; // YES:up NO:down
  BOOL cntMode;   // YES:キッチンタイマー NO:現在時表示

  // カウンター表示View定義
  CntView* cntView;

  // カウンター表示ラベル定義
  MyCntLabel *cntLabel;
  HunUnitLabel *hunLabel;//use minits unit character display
  ByoUnitLabel *byoLabel;//use seconds unit character display
  HistLabel *hisLabel;//history

  
  // カウンター表示エリア横幅,縦幅
  int cntW;
  int cntH;
  
  // カウンター表示エリア
  CALayer *cntlayer;
  
  // Button
  InfoBtn* infBtn; // Infomation ModalView Call Button
  ToggleBtn* sndBtn; // Sound On / Off
  ToggleBtn* vibBtn; // Vibrate On / Off
  ToggleBtn* bigBtn; // Button Zoom On / Off
  
  ModeTimerBtn* timerSelectBtn; //「タイマー設定」切替ボタン
  ModeClockBtn* clockSelectBtn; //「現在時表示」切替ボタン
  
  PlusNnBtn* setBtn10;//10 min
  PlusNnBtn* setBtn05;//5 min
  PlusNnBtn* setBtn03;//3 min
  PlusNnBtn* setBtn01;//1 min
  PlusNnBtn* setBtn001;//10 s
  StartBtn* setBtnStart;
  ResetBtn* setBtnReset;//Reset & Stop
  
  HistNnBtn* setBtnHis1;//History1
  HistNnBtn* setBtnHis2;//History2
  HistNnBtn* setBtnHis3;//History3
  
  
  // フェードインを一回だけ成功させるフラグ YES:実行 NO:実行しない
  BOOL fadeinFlag;
  
  // サウンドの状態
  BOOL soundOn; // YES:ON NO:OFF
  
  // サウンドON/OFF ボタンの表示文字列
  NSString *sndBtnTitle;
  CGRect sndBtnRect; // x y w h
  
  // タイマー完了(到達)フラグ
  BOOL timeUpOk;

  // リセットボタン 拡大フラグ
  BOOL resetBtnScaleFlag;  
}
@property (assign, nonatomic) BOOL addHistoryFlag;//履歴追加フラグ
@end
