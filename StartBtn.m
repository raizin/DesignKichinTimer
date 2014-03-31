//
//  StartBtn.m
//  DesignKichinTimer
//
//  Created by z on 2014/03/30.
//  Copyright (c) 2014 FoceSystemSolution. All rights reserved.
//

#import "StartBtn.h"

@implementation StartBtn

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

// Start Button
- (void)setStart
{
  [self setTitle:NSLocalizedString(@"btnStart", nil) forState:UIControlStateNormal];
  [self.titleLabel setFont:[UIFont boldSystemFontOfSize:[self getFontSize]/1.5f]];
}

- (id)initWithFrame:(CGRect)frame
{
  float w=200,h=120;// iPad Definition the width size and height size
  
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
    //iPhone
    w = 80;
    h = 60;
  }
  
  self = [super initWithFrame:CGRectMake(0,0,w,h)];//x y w h
  if (self) {
    
    [self setStart];
    
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
    [self addTarget:self action:@selector(mySetBtnTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(mySetBtnTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    
    //Foreground Color Control
    [self setTitleColor:[UIColor blueColor] forState:UIControlStateNormal]; //有効時
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted]; //タッチ(ハイライト？)時
    [self setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled]; //無効時
  }
  return self;
}




/*
 * ボタン押下時にボタンを下に少しずらす
 */
- (void)mySetBtnTouchDown:(id)sender
{
  UIButton *btnView   = (UIButton *)sender;
  btnView.layer.frame = CGRectMake(btnView.layer.frame.origin.x+3, btnView.layer.frame.origin.y+3, btnView.frame.size.width, btnView.frame.size.height);
  [btnView setBackgroundColor:[UIColor brownColor]];
}

/*
 * ボタンを押し離した時にボタンを元に戻す
 */
- (void)mySetBtnTouchUpInside:(id)sender
{
  UIButton *btnView   = (UIButton *)sender;
  btnView.layer.frame = CGRectMake(btnView.layer.frame.origin.x-3, btnView.layer.frame.origin.y-3, btnView.frame.size.width, btnView.frame.size.height);
  [btnView setBackgroundColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.0 alpha:0.8]];
}

@end
