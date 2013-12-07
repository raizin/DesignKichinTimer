//
//  ViewController.h
//  DesignKichinTimer
//
//  Created by z on 2013/10/18.
//  Copyright (c) 2013 FoceSystemSolution. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <iAd/iAd.h>
#import "MySetBtn.h"
#import "MyModeBtn.h"
#import "MyCntLabel.h"

@interface ViewController : UIViewController {
  
  //NSUserDefaults領域を使用
  NSUserDefaults *ud;
  
  //Sound
  AVAudioPlayer *pressBtnSnd;
  AVAudioPlayer *alermSound;
  
  // タイマー定義
  NSTimer *clockTm;
  NSTimer *timerTm;

  int globalMin;// 00~999
  int globalSec;// 00~59
  
  int historyMin1;
  int historySec1;
  int historyMin2;
  int historySec2;
  int historyMin3;
  int historySec3;

  
  BOOL cntUpFlag; // YES:up NO:down
  BOOL cntMode;   // YES:キッチンタイマー NO:現在時表示

  
  // カウンター表示View定義
  UIView *cntView;
  

  // カウンター表示ラベル定義
  MyCntLabel *cntLabel;
  MyCntLabel *hunLabel;//use minits unit character display
  MyCntLabel *byoLabel;//use seconds unit character display
  
  MyCntLabel *hisLabel;//履歴

  // カウンター表示ラベル フォントサイズ定義
  float cntFontSize;
  
  // カウンター表示エリア横幅,縦幅
  int cntW;
  int cntH;
  
  // カウンター表示エリア
  CALayer *cntlayer;
  
  // Button
  MyModeBtn *timerSelectBtn; //「タイマー設定」切替ボタン
  MyModeBtn *clockSelectBtn; //「現在時表示」切替ボタン
  MyModeBtn *soundSelectBtn; // Sound On/Off
  
  MySetBtn *setBtn60;//60 min
  MySetBtn *setBtn10;//10 min
  MySetBtn *setBtn05;//5 min
  MySetBtn *setBtn03;//3 min
  MySetBtn *setBtn01;//1 min
  MySetBtn *setBtn001;//10 s
  MySetBtn *setBtn0001;//1 s
  MySetBtn *setBtnStart;
  MySetBtn *setBtnReset;//Reset & Stop
  
  MySetBtn *setBtnHis1;//History
  MySetBtn *setBtnHis2;//History
  MySetBtn *setBtnHis3;//History
  

  // Button フォントサイズ定義
  float btnFontSize;
  
  // 単位 「M」「S」フォントサイズ定義
  float unitFontSize;
  CGRect unitRectM;
  CGRect unitRectS;
  
  // フェードインを一回だけ成功させるフラグ YES:実行 NO:実行しない
  BOOL fadeinFlag;
  
  // サウンドの状態
  BOOL soundOn; // YES:ON NO:OFF
  
  // サウンドON/OFF ボタンの表示文字列
  NSString *sndBtnTitle;
  CGRect sndBtnRect; // x y w h
  
  // タイマー完了(到達)フラグ
  BOOL timeUpOk;

}
//@property (nonatomic, retain) AdstirView* adview; //プロパティーで宣言すると、管理が簡単になります。

@end
