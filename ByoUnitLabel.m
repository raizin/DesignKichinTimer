//
//  ByoUnitLabel.m
//  DesignKichinTimer
//
//  Created by z on 2014/04/02.
//  Copyright (c) 2014 FoceSystemSolution. All rights reserved.
//

#import "ByoUnitLabel.h"

@implementation ByoUnitLabel

- (id)init
{
  self = [super init];
  if (self) {
    //[NSString stringWithFormat:@"%@",NSLocalizedString(@"byoo", nil)];//秒
    [self setText:@"″"];
    [self setTextAlignment:NSTextAlignmentCenter];
    [self setAdjustsFontSizeToFitWidth:YES];
  }
  return self;
}

@end
