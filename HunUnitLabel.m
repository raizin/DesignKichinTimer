//
//  HunUnitLabel.m
//  DesignKichinTimer
//
//  Created by z on 2014/04/02.
//  Copyright (c) 2014 FoceSystemSolution. All rights reserved.
//

#import "HunUnitLabel.h"

@implementation HunUnitLabel

- (id)init
{
  self = [super init];
  if (self) {
    //[NSString stringWithFormat:@"%@",NSLocalizedString(@"hunn", nil)];//分
    self.text = @"′";
    [self setTextAlignment:NSTextAlignmentCenter];
    [self setAdjustsFontSizeToFitWidth:YES];
  }
  return self;
}

@end
