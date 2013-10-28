//
//  ViewController.h
//  DesignKichinTimer
//
//  Created by z on 2013/10/18.
//  Copyright (c) 2013 FoceSystemSolution. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController {
  
  //  NSString *dispStr;
  //  BOOL flgViewSeco;
  //  BOOL flgViewDate;
  //  BOOL flgBlink;
  //  BOOL blinkCanma;
  
  //  CGPoint centerLocation_Date;
  //  CGPoint centerLocation_Time;
  
  // カウンター表示View定義
  UIView *cntView;

  // カウンター表示ラベル定義
  UILabel *cntLabel;
  
  // カウンター表示エリア横幅,縦幅
  int cntW;
  int cntH;
  
  // カウンター表示エリア
  CALayer *cntlayer;
  
  // Button
  UIButton *setBtn60;//60 min
  UIButton *setBtn10;//10 min
  UIButton *setBtn05;//5 min
  UIButton *setBtn03;//3 min
  UIButton *setBtn01;//1 min
  UIButton *setBtn001;//10 s
  UIButton *setBtn0001;//1 s
  UIButton *setBtnStart;
  UIButton *setBtnReset;//Reset & Stop

  
}

@end
