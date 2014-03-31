//
//  ModeTimerBtn.m
//  DesignKichinTimer
//
//  Created by z on 2013/11/25.
//  Copyright (c) 2013 FoceSystemSolution. All rights reserved.
//

#import "ModeTimerBtn.h"

@implementation ModeTimerBtn

- (id)initWithFrame:(CGRect)frame
{
  float w=155,h=50;// iPad Definition the width size and height size
  
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
    //iPhone
    w = 145;
    h = 50;
  }
  
  self = [super initWithFrame:CGRectMake(0,0,w,h)];//x y w h
  if (self) {
    
    [self setAttributedTitle:[self myColorShadowAttr:[UIColor grayColor]] forState:UIControlStateNormal];
    [self setAttributedTitle:[self myColorShadowAttr:[UIColor redColor]] forState:UIControlStateHighlighted];
    [self setAttributedTitle:[self myColorShadowAttr:[UIColor blueColor]] forState:UIControlStateDisabled];
    
    [self setBackgroundColor:[UIColor clearColor]];
//    [self setBackgroundColor:[UIColor purpleColor]];//Use Debug
  }
  return self;
}

/*
 * 「モード設定」「アイコン切替」ボタン内文字列用 影の定義関数
 */
- (NSAttributedString*)myColorShadowAttr:(UIColor*)clr
{
  NSShadow *shadow = [[NSShadow alloc] init];
  shadow.shadowOffset = CGSizeMake(1.0f, 1.0f);
  shadow.shadowColor = clr;
  shadow.shadowBlurRadius = 5.0f;
  NSDictionary *attr = @{NSShadowAttributeName:shadow,NSForegroundColorAttributeName:clr};
  
  return [[NSAttributedString alloc] initWithString:NSLocalizedString(@"btnTimer", nil) attributes:attr];
}

@end
