//
//  HistLabel.m
//  DesignKichinTimer
//
//  Created by z on 2014/03/30.
//  Copyright (c) 2014 FoceSystemSolution. All rights reserved.
//

#import "HistLabel.h"

@implementation HistLabel

- (void)setEnable:(BOOL)enable
{
  if (enable) {
    self.textColor = [UIColor orangeColor];
  }else{
    self.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.8]; // Light Gray
  }
}

- (id)initWithFrame:(CGRect)frame
{
  float w=100,h=30;// iPad Definition the width size and height size
  
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
    //iPhone
    w = 75;
    h = 20;
  }
  
  self = [super initWithFrame:CGRectMake(0,0,w,h)]; //x,y,w,h
  if (self) {
    [self setFont:[UIFont boldSystemFontOfSize:20.0f]];
    [self setText:[NSString stringWithFormat:@"%@",NSLocalizedString(@"history", nil)]];
    [self setBackgroundColor:[UIColor clearColor]];
    [self setTextAlignment:NSTextAlignmentCenter];
    [self setAdjustsFontSizeToFitWidth:YES];
    [self.layer setShadowOpacity:0.5f];
    [self.layer setShadowOffset:CGSizeMake(2.f, 2.f)];
//    [self setBackgroundColor:[UIColor blueColor]]; //Use Debug
  }
  return self;
}

@end