//
//  MySetBtn.m
//  DesignKichinTimer
//
//  Created by z on 2013/11/25.
//  Copyright (c) 2013 FoceSystemSolution. All rights reserved.
//

#import "MySetBtn.h"

@implementation MySetBtn


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

  [self addTarget:self action:@selector(myBtnTouchDown:) forControlEvents:UIControlEventTouchDown]; // タッチ中 イベント
  [self addTarget:self action:@selector(myBtnTouchUpInside:) forControlEvents:UIControlEventTouchUpInside]; // タッチリリース時
  
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
      
      
      [self setBackgroundColor:[UIColor colorWithRed:0.9f green:0.9f blue:0.f alpha:0.8f]];
      [self.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
      [self.layer setBorderWidth:1.f];
      
      
      // ボタンの角丸ぐあい 端末分岐 iphone:25 ipad:50
      if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        [self.layer setCornerRadius:25.f];
      }
      else{
        [self.layer setCornerRadius:50.f];
      }
      
      [self.layer setShadowOpacity:0.5f];
      [self.layer setShadowOffset:CGSizeMake(2.f, 2.f)];
      
      
      
      
      
    }
    return self;
}

/*
 * ボタンタイトル(文字列)生成関数
 */
- (NSMutableAttributedString*)myBtnColorCtl:(UIColor*)cl num:(int)num unit:(NSString*)unit
{
  // 表示フォントサイズ 端末分岐 ipad:50 iphone:20
  float btnFontSize;
  
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
    //NSLog(@"%d: iPhoneの処理",__LINE__);
    btnFontSize = 25.0f;
  }
  else{
    //NSLog(@"%d: iPadの処理",__LINE__);
    btnFontSize = 50.0f;
  }
  
  NSDictionary *fontDigit = @{ NSForegroundColorAttributeName:cl,
                               NSFontAttributeName : [UIFont boldSystemFontOfSize:btnFontSize] };
  NSDictionary *fontUnit = @{ NSForegroundColorAttributeName:cl,
                              NSFontAttributeName : [UIFont boldSystemFontOfSize:btnFontSize/1.5f] };
  
  
  NSAttributedString *btnPlusLabel = [[NSAttributedString alloc]
                                      initWithString:@"＋"
                                      attributes:fontUnit];
  NSAttributedString *btnDigiLabel = [[NSAttributedString alloc]
                                      initWithString:[NSString stringWithFormat:@"%d",num]
                                      attributes:fontDigit];
  NSAttributedString *btnUnitLabel = [[NSAttributedString alloc]
                                      initWithString:unit
                                      attributes:fontUnit];
  
  NSMutableAttributedString *_btn = [[NSMutableAttributedString alloc] initWithAttributedString:btnPlusLabel];//Total String
  [_btn appendAttributedString:btnDigiLabel];
  [_btn appendAttributedString:btnUnitLabel];
  
  return _btn;
}



/*
 * ボタン押下時にボタンを下に少しずらす
 */
- (void)myBtnTouchDown:(id)sender
{
  UIButton *btnView   = (UIButton *)sender;
  btnView.layer.frame = CGRectMake(btnView.layer.frame.origin.x+3, btnView.layer.frame.origin.y+3, btnView.frame.size.width, btnView.frame.size.height);
  [btnView setBackgroundColor:[UIColor brownColor]];
}

/*
 * ボタンを押し離した時にボタンを元に戻す
 */
- (void)myBtnTouchUpInside:(id)sender
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
