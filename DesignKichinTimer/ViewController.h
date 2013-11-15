//
//  ViewController.h
//  DesignKichinTimer
//
//  Created by z on 2013/10/18.
//  Copyright (c) 2013 FoceSystemSolution. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "GADBannerView.h"
#import <iAd/iAd.h>


@interface ViewController : UIViewController {
  
  // iAd用View
  ADBannerView *adView;
  BOOL bannerIsVisible;
  
  //AdMob用View
  GADBannerView *bannerView;
  
  //Sound
  AVAudioPlayer *pressBtnSnd;
  AVAudioPlayer *alermSound;
  
  // タイマー定義
  NSTimer *clockTm;
  NSTimer *timerTm;

  int globalMin;// 00~999
  int globalSec;// 00~59
  
  BOOL cntUpFlag; // YES:up NO:down
  BOOL cntMode;   // YES:キッチンタイマー NO:現在時表示

  
  // カウンター表示View定義
  UIView *cntView;

  // カウンター表示ラベル定義
  UILabel *cntLabel;
  UILabel *hunLabel;//use minits unit character display
  UILabel *byoLabel;//use seconds unit character display

  // カウンター表示ラベル フォントサイズ定義
  float cntFontSize;
  
  // カウンター表示エリア横幅,縦幅
  int cntW;
  int cntH;
  
  // カウンター表示エリア
  CALayer *cntlayer;
  
  // Button
  UIButton *timerSelectBtn; //「タイマー設定」切替ボタン
  UIButton *clockSelectBtn; //「現在時表示」切替ボタン
  UIButton *soundSelectBtn; // Sound On/Off
  
  UIButton *setBtn60;//60 min
  UIButton *setBtn10;//10 min
  UIButton *setBtn05;//5 min
  UIButton *setBtn03;//3 min
  UIButton *setBtn01;//1 min
  UIButton *setBtn001;//10 s
  UIButton *setBtn0001;//1 s
  UIButton *setBtnStart;
  UIButton *setBtnReset;//Reset & Stop

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

}

@end
