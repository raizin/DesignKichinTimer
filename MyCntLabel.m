//
//  MyCntLabel.m
//  DesignKichinTimer
//
//  Created by z on 2013/11/25.
//  Copyright (c) 2013 FoceSystemSolution. All rights reserved.
//

#import "MyCntLabel.h"

// Count Label Font Size  5 digits
@implementation MyCntLabel

- (id)initWithFrame:(CGRect)frame
{
  float fontSize = 180;//iPad Definition the width size and height size
 
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
    fontSize = 70;//iPhone
  }
  
  self = [super initWithFrame:frame];//x y w h
  if (self) {
    [self setTextAlignment:NSTextAlignmentCenter];
    [self setAdjustsFontSizeToFitWidth:YES];
    [self.layer setShadowOpacity:0.5f];
    [self.layer setShadowOffset:CGSizeMake(2.f, 2.f)];
    
    [self setFont:[UIFont systemFontOfSize:fontSize]];
    [self setTextColor:[UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.8]];//Adjustment Black
    [self setText:nil];
    [self setBackgroundColor:[UIColor clearColor]];
  }
  return self;
}

@end