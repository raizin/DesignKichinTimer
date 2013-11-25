//
//  MyModeBtn.m
//  DesignKichinTimer
//
//  Created by z on 2013/11/25.
//  Copyright (c) 2013 FoceSystemSolution. All rights reserved.
//

#import "MyModeBtn.h"

@implementation MyModeBtn


- (void)ModeSelect:(CGRect)xywh btnTitle:(NSString *)lb
{  
  self.frame = xywh; // use ipad positioning
  
  [self setAttributedTitle:[self myColorShadowAttr:[UIColor grayColor] btnTitle:lb] forState:UIControlStateNormal]; // 有効時
  [self setAttributedTitle:[self myColorShadowAttr:[UIColor redColor] btnTitle:lb] forState:UIControlStateHighlighted]; // タッチ中
  [self setAttributedTitle:[self myColorShadowAttr:[UIColor blueColor] btnTitle:lb] forState:UIControlStateDisabled]; // 無効時
}


- (void)SwitchIcon:(CGRect)xywh btnTitle:(NSString *)lb stateFlag:(BOOL)flag
{
  self.frame = xywh;
  
  //前回の状態から初期の状態を設定
  if (flag) {
    [self setAttributedTitle:[self myColorShadowAttr:[UIColor blueColor] btnTitle:lb] forState:UIControlStateNormal];
  }else{
    [self setAttributedTitle:[self myColorShadowAttr:[UIColor grayColor] btnTitle:lb] forState:UIControlStateNormal];
  }

  [self setAttributedTitle:[self myColorShadowAttr:[UIColor redColor ] btnTitle:lb] forState:UIControlStateHighlighted];
}



- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


/*
 * 「モード設定」「アイコン切替」ボタン内文字列用 影の定義関数
 */
- (NSAttributedString*)myColorShadowAttr:(UIColor*)clr btnTitle:(NSString*)lb
{
  NSShadow *shadow = [[NSShadow alloc] init];
  shadow.shadowOffset = CGSizeMake(1.0f, 1.0f);
  shadow.shadowColor = clr;
  shadow.shadowBlurRadius = 5.0f;
  NSDictionary *attr = @{NSShadowAttributeName:shadow,NSForegroundColorAttributeName:clr};
  
  NSAttributedString *attrTitle = [[NSAttributedString alloc] initWithString:lb attributes:attr];
  
  return attrTitle;
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
