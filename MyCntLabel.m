//
//  MyCntLabel.m
//  DesignKichinTimer
//
//  Created by z on 2013/11/25.
//  Copyright (c) 2013 FoceSystemSolution. All rights reserved.
//

#import "MyCntLabel.h"

@implementation MyCntLabel


- (void)setHun:(float)fontSize
{
  self.font = [UIFont fontWithName:@"Helvetica-Bold" size:fontSize];
  self.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.8]; // Light Black
  self.text = [NSString stringWithFormat:@"%@",NSLocalizedString(@"hunn", nil)];
}
- (void)setByo:(float)fontSize
{
  self.font = [UIFont fontWithName:@"Helvetica-Bold" size:fontSize];
  self.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.8]; // Light Black
  self.text = [NSString stringWithFormat:@"%@",NSLocalizedString(@"byoo", nil)];
}

- (void)setCnt:(float)fontSize
{
  self.font = [UIFont systemFontOfSize:fontSize];
  self.text = nil;
  self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0.5 alpha:0]; //
  self.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.8]; // Light Gray
}

- (void)setHis:(float)fontSize
{
  self.font = [UIFont systemFontOfSize:fontSize];
  self.text = [NSString stringWithFormat:@"%@",NSLocalizedString(@"history", nil)];
  self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0.5 alpha:0]; //
  self.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.8]; // Light Gray
  
}
- (void)setHisEnable:(BOOL)enable
{
  if (enable) {
    self.textColor = [UIColor orangeColor];
  }else{
    self.textColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.8]; // Light Gray
  }
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
      
      self.textAlignment = NSTextAlignmentCenter;
      self.adjustsFontSizeToFitWidth = YES;
      [self.layer setShadowOpacity:0.5f];
      [self.layer setShadowOffset:CGSizeMake(2.f, 2.f)];
      
    }
    return self;
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
