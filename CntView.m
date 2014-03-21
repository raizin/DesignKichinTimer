//
//  CntView.m
//  DesignKichinTimer
//
//  Created by z on 2014/03/21.
//  Copyright (c) 2014 FoceSystemSolution. All rights reserved.
//

#import "CntView.h"

@implementation CntView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
      
      self.layer.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0].CGColor;//薄いグレイ
      self.layer.borderColor = [UIColor colorWithRed:0.5 green:0.5 blue:1.0 alpha:1.0].CGColor;//薄い青
      self.layer.borderWidth = 7.0;
      self.layer.cornerRadius = 10.0;
      
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
