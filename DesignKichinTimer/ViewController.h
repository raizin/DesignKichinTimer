//
//  ViewController.h
//  DesignKichinTimer
//
//  Created by z on 2013/10/18.
//  Copyright (c) 2013 FoceSystemSolution. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController {

//  UILabel *nowDate;
//  UIView  *nowDateView;
  //  NSString *dispStr;
//  UIButton *setBtn;
  //  BOOL flgViewSeco;
  //  BOOL flgViewDate;
  //  BOOL flgBlink;
//  BOOL blinkCanma;
  
//  CGPoint centerLocation_Date;
//  CGPoint centerLocation_Time;

  // カウンター表示ラベル定義
  UILabel *cntLabel;
  
  // カウンター表示エリア横幅,縦幅
  int cntW;
  int cntH;
  
  // カウンター表示エリア
  CALayer *sublayer;

}

@end
