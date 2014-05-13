//
//  ViewController.h
//  DesignKichinTimer
//
//  Created by z on 2013/10/18.
//  Copyright (c) 2013 FoceSystemSolution. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <iAd/iAd.h>
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

  /// Banner広告用定義 ここから ///
  ADBannerView* iAdView; // iAd用View
  BOOL bannerIsVisible;
  /// Banner広告用定義 ここまで ///

  //Sound
  AVAudioPlayer *pressBtnSnd, *alermSound;
  
  // タイマー定義
  NSTimer *clockTm, *timerTm, *lPTimer;
  


//  int globalMin;// 00~999
//  int globalSec;// 00~59
  
  int historyMin1, historySec1;
  int historyMin2, historySec2;
  int historyMin3, historySec3;

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
  
  // 10min 5min 3min 1min 10sec
  PlusNnBtn *setBtn10, *setBtn05, *setBtn03, *setBtn01, *setBtn001;
  StartBtn *setBtnStart;
  ResetBtn *setBtnReset;//Reset & Stop
  
  HistNnBtn *setBtnHis1, *setBtnHis2, *setBtnHis3;//History Button
  
  
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
