//
//  ViewController.h
//  DesignKichinTimer
//
//  Created by z on 2013/10/18.
//  Copyright (c) 2013 FoceSystemSolution. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
//#import <iAd/iAd.h>
#import "MySetBtn.h"
#import "MyModeBtn.h"
#import "MyCntLabel.h"
#import "InfoViewController.h"
#import "CntView.h"
#import "PlusNnBtn.h"

@interface ViewController : UIViewController {
  
  //NSUserDefaults領域を使用
  NSUserDefaults *ud;

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

  
  BOOL cntUpFlag; // YES:up NO:down
  BOOL cntMode;   // YES:キッチンタイマー NO:現在時表示

  
  // カウンター表示View定義
  CntView* cntView;

  

  // カウンター表示ラベル定義
  MyCntLabel *cntLabel;
  MyCntLabel *hunLabel;//use minits unit character display
  MyCntLabel *byoLabel;//use seconds unit character display
  MyCntLabel *hisLabel;//history

  
  // カウンター表示エリア横幅,縦幅
  int cntW;
  int cntH;
  
  // カウンター表示エリア
  CALayer *cntlayer;
  
  // Button
  UIButton *infBtn; // Infomation ModalView Call Button
  UIButton *sndBtn; // Sound On / Off
  UIButton *vibBtn; // Vibrate On / Off
  UIButton *bigBtn; // Button Zoom On / Off
  
  MyModeBtn *timerSelectBtn; //「タイマー設定」切替ボタン
  MyModeBtn *clockSelectBtn; //「現在時表示」切替ボタン
  
  PlusNnBtn *setBtn10;//10 min
  PlusNnBtn *setBtn05;//5 min
  PlusNnBtn *setBtn03;//3 min
  PlusNnBtn *setBtn01;//1 min
  PlusNnBtn *setBtn001;//10 s
  MySetBtn *setBtnStart;
  MySetBtn *setBtnReset;//Reset & Stop
  
  MySetBtn *setBtnHis1;//History
  MySetBtn *setBtnHis2;//History
  MySetBtn *setBtnHis3;//History
  
  
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
@end
