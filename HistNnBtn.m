//
//  HistNnBtn.m
//  DesignKichinTimer
//
//  Created by z on 2014/03/30.
//  Copyright (c) 2014 FoceSystemSolution. All rights reserved.
//

#import "HistNnBtn.h"

@implementation HistNnBtn

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
  [self setTitle:[NSString stringWithFormat:@"%d",nn] forState:UIControlStateNormal];
  [self.titleLabel setFont:[UIFont boldSystemFontOfSize:[self getFontSize]/2]];
  
  [self setTitleColor:[UIColor blueColor ] forState:UIControlStateNormal];
  [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
  [self setTitleColor:[UIColor grayColor ] forState:UIControlStateDisabled];
}

- (id)initWithFrame:(CGRect)frame
{
  float w=65,h=40;// iPad Definition the width size and height size
  
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
    //iPhone
    w = 60;
    h = 18;
  }
  
  self = [super initWithFrame:CGRectMake(0,0,w,h)];//x y w h
  
  if (self) {
    [self setBackgroundColor:[UIColor colorWithRed:0.9f green:0.9f blue:0.f alpha:0.8f]];
    [self.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [self.layer setBorderWidth:1.f];
    
    //Corner Radius
    [self.layer setCornerRadius:20.f];
    
    //Shadow Setting
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
