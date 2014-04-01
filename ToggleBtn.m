//
//  ToggleBtn.m
//  DesignKichinTimer
//
//  Created by z on 2014/04/01.
//  Copyright (c) 2014 FoceSystemSolution. All rights reserved.
//

#import "ToggleBtn.h"

@implementation ToggleBtn

- (id)initWithFrame:(CGRect)frame
{
  float w=60,h=w;// Definition the width size and height size
  
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
    //iPhone
    w=33; h=w;
  }
  
  self = [super initWithFrame:CGRectMake(0,0,w,h)];//x y w h
  if (self) {
    //    [self setBackgroundColor:[UIColor purpleColor]];//Use Debug
    //    [self setAlpha:0.5f];//Use Debug
    [self setImageEdgeInsets:UIEdgeInsetsMake(8.f, 8.f, 8.f, 8.f)]; // 上 左 下 右
  }
  return self;
}

@end
