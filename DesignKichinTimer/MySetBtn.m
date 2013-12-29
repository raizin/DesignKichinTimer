//
//  MySetBtn.m
//  DesignKichinTimer
//
//  Created by z on 2013/11/25.
//  Copyright (c) 2013 FoceSystemSolution. All rights reserved.
//

#import "MySetBtn.h"

@implementation MySetBtn


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


// Number Button
- (void)setNum:(int)number minFlag:(BOOL)unitFlag
{
  NSString *unit = [NSString stringWithFormat:@"%@",NSLocalizedString(@"hun", nil)];
  if (unitFlag == NO) {
    unit = [NSString stringWithFormat:@"%@",NSLocalizedString(@"byo", nil)];
  }
  
  // UIControlStateNormal
  [self setAttributedTitle:[self myBtnColorCtl:[UIColor blueColor ] num:number unit:unit] forState:UIControlStateNormal];
  // UIControlStateHighlighted
  [self setAttributedTitle:[self myBtnColorCtl:[UIColor whiteColor] num:number unit:unit] forState:UIControlStateHighlighted];
  // UIControlStateDisabled
  [self setAttributedTitle:[self myBtnColorCtl:[UIColor grayColor ] num:number unit:unit] forState:UIControlStateDisabled];
}

// Start Button
- (void)setStart
{
  [self setTitle:NSLocalizedString(@"btnStart", nil) forState:UIControlStateNormal];
  [self.titleLabel setFont:[UIFont boldSystemFontOfSize:[self getFontSize]/1.5f]];
}

// Stop & Reset Button
- (void)setReset:(BOOL)flag
{
  NSString *totalString;
  
  if(flag){
    totalString = NSLocalizedString(@"btnReset", nil);
  }else{
    totalString = NSLocalizedString(@"btnStop" , nil);
  }
  
  [self setTitle:totalString forState:UIControlStateNormal];
  [self.titleLabel setFont:[UIFont boldSystemFontOfSize:[self getFontSize]/1.5f]];
}

// History Button
- (void)setHis:(int)number
{
  [self.layer setCornerRadius:20];
  [self setTitle:[NSString stringWithFormat:@"%d",number] forState:UIControlStateNormal];
  [self.titleLabel setFont:[UIFont boldSystemFontOfSize:[self getFontSize]/2]];
}

- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];
  if (self) {
    
    // Initialization code
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

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
