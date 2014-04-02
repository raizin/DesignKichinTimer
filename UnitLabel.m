//
//  UnitLabel.m
//  DesignKichinTimer
//
//  Created by z on 2014/04/02.
//  Copyright (c) 2014 FoceSystemSolution. All rights reserved.
//

#import "UnitLabel.h"

@implementation UnitLabel

- (id)initWithFrame:(CGRect)frame
{
  float w=45,h=w,fontSize = 60;//iPad Definition the width size and height size
  
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
    fontSize = 30;//iPhone
  }

  self = [super initWithFrame:CGRectMake(0,0,w,h)];//x y w h
//self = [super initWithFrame:frame];//x y w h
  if (self) {
    [self setFont:[UIFont fontWithName:@"Helvetica-Bold" size:fontSize]];
    [self.layer setShadowOpacity:0.5f];
    [self.layer setShadowOffset:CGSizeMake(2.f, 2.f)];
    [self setTextColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.8]];//Adjustment Black
    [self setBackgroundColor:[UIColor clearColor]];
  }
  return self;
}

@end
