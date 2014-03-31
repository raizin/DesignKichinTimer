//
//  PlusNnBtn.m
//  DesignKichinTimer
//
//  Created by z on 2014/03/29.
//  Copyright (c) 2014 FoceSystemSolution. All rights reserved.
//

#import "PlusNnBtn.h"

@implementation PlusNnBtn

- (float)getFontSize
{
  // ボタンのラベル フォントサイズ
  static float BTN_FONT_SIZE_IPHONE = 24.f;
  static float BTN_FONT_SIZE_IPAD   = 50.f;
  
  // 表示フォントサイズ 端末分岐 ipad:50 iphone:20
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
    return BTN_FONT_SIZE_IPHONE;
  }
  else{
    return BTN_FONT_SIZE_IPAD;
  }
}

- (void)setNum:(int)nn
{
  NSString* unit = [NSString stringWithFormat:@"%@",NSLocalizedString(@"hun", nil)];
  [self setAttributedTitle:[self myBtnColorCtl:[UIColor blueColor ] num:nn unit:unit] forState:UIControlStateNormal];
  [self setAttributedTitle:[self myBtnColorCtl:[UIColor whiteColor] num:nn unit:unit] forState:UIControlStateHighlighted];
  [self setAttributedTitle:[self myBtnColorCtl:[UIColor grayColor ] num:nn unit:unit] forState:UIControlStateDisabled];
}
- (void)setNumByo:(int)nn
{
  NSString* unit = [NSString stringWithFormat:@"%@",NSLocalizedString(@"byo", nil)];
  [self setAttributedTitle:[self myBtnColorCtl:[UIColor blueColor ] num:nn unit:unit] forState:UIControlStateNormal];
  [self setAttributedTitle:[self myBtnColorCtl:[UIColor whiteColor] num:nn unit:unit] forState:UIControlStateHighlighted];
  [self setAttributedTitle:[self myBtnColorCtl:[UIColor grayColor ] num:nn unit:unit] forState:UIControlStateDisabled];
}


- (id)initWithFrame:(CGRect)frame
{
  float w=170,h=100;// iPad Definition the width size and height size
  
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
    //iPhone
    w = 74;
    h = 50;
  }
  
  self = [super initWithFrame:CGRectMake(0,0,w,h)];//x y w h
  if (self) {
    [self setBackgroundColor:[UIColor colorWithRed:0.9f green:0.9f blue:0.f alpha:0.8f]];
    [self.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [self.layer setBorderWidth:1.f];
    
    // Corner Radius
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
      [self.layer setCornerRadius:25.f];
    }
    else{
      [self.layer setCornerRadius:50.f];
    }
    
    // Shadow Setting
    [self.layer setShadowOpacity:0.5f];
    [self.layer setShadowOffset:CGSizeMake(2.f, 2.f)];
    
    //Background Color Control
    [self addTarget:self action:@selector(btnTouchDown) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(btnTouchUp) forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:self action:@selector(btnTouchUp) forControlEvents:UIControlEventTouchUpOutside];
  }
  return self;
}


/*
 * ボタン長押し
- (void)longPress:(UILongPressGestureRecognizer *)gestureRecognizer
{
    NSLog(@"%s",__func__);
    
    switch (gestureRecognizer.state) {
      case UIGestureRecognizerStateBegan://長押しを検知開始
      {
        NSLog(@"UIGestureRecognizerStateBegan");
      }
        break;
      case UIGestureRecognizerStateEnded://長押し終了時
      {
        NSLog(@"UIGestureRecognizerStateEnded");
      }
        break;
      default:
        break;
    }
}
 */


/*
 * ボタンタイトル(文字列)生成関数
 */
- (NSMutableAttributedString*)myBtnColorCtl:(UIColor*)cl num:(int)num unit:(NSString*)unit
{
  NSDictionary *fontPlus = @{ NSForegroundColorAttributeName:cl,
                              NSFontAttributeName : [UIFont systemFontOfSize:[self getFontSize]/1.3f] };
  NSDictionary *fontSpace= @{ NSForegroundColorAttributeName:cl,
                              NSFontAttributeName : [UIFont systemFontOfSize:[self getFontSize]/3.0f] };
  NSDictionary *fontDigit= @{ NSForegroundColorAttributeName:cl,
                              NSFontAttributeName : [UIFont boldSystemFontOfSize:[self getFontSize]] };
  NSDictionary *fontUnit = @{ NSForegroundColorAttributeName:cl,
                              NSFontAttributeName : [UIFont boldSystemFontOfSize:[self getFontSize]/1.5f] };
  
  NSAttributedString *btnPlusLabel = [[NSAttributedString alloc] initWithString:@"+" attributes:fontPlus];
  NSAttributedString *btnSpaceLabel= [[NSAttributedString alloc] initWithString:@" " attributes:fontSpace];
  NSAttributedString *btnDigiLabel = [[NSAttributedString alloc]
                                      initWithString:[NSString stringWithFormat:@"%d",num] attributes:fontDigit];
  NSAttributedString *btnUnitLabel = [[NSAttributedString alloc] initWithString:unit attributes:fontUnit];
  
  //Total String
  NSMutableAttributedString *_btn = [[NSMutableAttributedString alloc] initWithAttributedString:btnPlusLabel];
  [_btn appendAttributedString:btnSpaceLabel];
  [_btn appendAttributedString:btnDigiLabel];
  [_btn appendAttributedString:btnUnitLabel];
  
  return _btn;
}


/*
 * ボタン押下時にボタンを下に少しずらす
 */
- (void)btnTouchDown
{
  [self setCenter:CGPointMake(self.center.x +3, self.center.y +3)];
  [self setBackgroundColor:[UIColor brownColor]];
}

/*
 * ボタンを押し離した時にボタンを元に戻す
 */
- (void)btnTouchUp
{
  [self setCenter:CGPointMake(self.center.x -3, self.center.y -3)];
  [self setBackgroundColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.0 alpha:0.8]];
}

@end
