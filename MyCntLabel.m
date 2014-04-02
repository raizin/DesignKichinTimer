//
//  MyCntLabel.m
//  DesignKichinTimer
//
//  Created by z on 2013/11/25.
//  Copyright (c) 2013 FoceSystemSolution. All rights reserved.
//

#import "MyCntLabel.h"

@implementation MyCntLabel


// Count Label Font Size  5 digits
static float CNT_FONT_SIZE_IPHONE = 70.f;
static float CNT_FONT_SIZE_IPAD   = 180.f;

// Unit Label Font Size "M and S"
static float UNIT_FONT_SIZE_IPHONE= 30.f;
static float UNIT_FONT_SIZE_IPAD  = 60.f;

- (void)setHun
{
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
    self.font = [UIFont fontWithName:@"Helvetica-Bold" size:UNIT_FONT_SIZE_IPHONE];
  }else{
    self.font = [UIFont fontWithName:@"Helvetica-Bold" size:UNIT_FONT_SIZE_IPAD];
  }
  self.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.8]; // Light Black
//  self.text = [NSString stringWithFormat:@"%@",NSLocalizedString(@"hunn", nil)];
  self.text = @"′";
  self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0.5 alpha:0]; //
}
- (void)setByo
{
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
    self.font = [UIFont fontWithName:@"Helvetica-Bold" size:UNIT_FONT_SIZE_IPHONE];
  }else{
    self.font = [UIFont fontWithName:@"Helvetica-Bold" size:UNIT_FONT_SIZE_IPAD];
  }
  self.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.8]; // Light Black
//  self.text = [NSString stringWithFormat:@"%@",NSLocalizedString(@"byoo", nil)];
  self.text = @"″";
  self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0.5 alpha:0]; //
}

- (void)setCnt
{
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
    self.font = [UIFont systemFontOfSize:CNT_FONT_SIZE_IPHONE];
  }else{
    self.font = [UIFont systemFontOfSize:CNT_FONT_SIZE_IPAD];
  }
  self.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.8]; // Light Gray
  self.text = nil;
  self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0.5 alpha:0]; //
}


- (id)initWithFrame:(CGRect)frame
{
  self = [super initWithFrame:frame];//x y w h
  if (self) {
    [self setTextAlignment:NSTextAlignmentCenter];
    [self setAdjustsFontSizeToFitWidth:YES];
    [self.layer setShadowOpacity:0.5f];
    [self.layer setShadowOffset:CGSizeMake(2.f, 2.f)];
    [self setCnt];
  }
  return self;
}

@end