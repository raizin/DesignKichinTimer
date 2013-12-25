//
//  TriangleBtn.m
//  DesignKichinTimer
//
//  Created by z on 2013/12/23.
//  Copyright (c) 2013 FoceSystemSolution. All rights reserved.
//

#import "TriangleBtn.h"

@implementation TriangleBtn

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      // 背景を透明にする
      self.backgroundColor = [UIColor clearColor];
      
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
  // 塗りつぶす色を設定する。
  [[UIColor greenColor] setFill];
  
  // 三角形のパスを書く　（３点でオープンパスにした。）
  CGContextRef ctx = UIGraphicsGetCurrentContext();
  float width = self.bounds.size.width;
  float height = self.bounds.size.height;
  CGContextMoveToPoint(ctx, width, 0.f); // x y
//  NSLog(@"%d x=%f y=%f",__LINE__, width, 0.f);
  
  CGContextAddLineToPoint(ctx, width, height); // x y
//  NSLog(@"%d x=%f y=%f",__LINE__, width, height);

  CGContextAddLineToPoint(ctx, 0.f, height); // x y
//  NSLog(@"%d x=%f y=%f",__LINE__, 0.f, height);
  
  // 塗りつぶす
  CGContextFillPath(ctx);
  
  
  
  /*** 影を描画 ***/

  // 線の色を青に指定
  [[UIColor whiteColor] setStroke];
  // 線を書くUIBezierPathを生成
  UIBezierPath *path = [UIBezierPath bezierPath];
  // 線の幅を指定
//  [path setLineWidth:3];

  // 始点を設定
  [path moveToPoint:CGPointMake(width, 0.f)]; // x y
  // 線を追加
  [path addLineToPoint:CGPointMake(0.f, height)]; // x y
  // 線を描画
  [path stroke];

  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextAddPath(context, path.CGPath);
  CGContextSetLineWidth(context, 2.0);
//  CGContextSetBlendMode(context, path.blendMode);
  CGContextSetShadowWithColor(context, CGSizeMake(2.f, 2.f), 5.0f, [UIColor blackColor].CGColor);
  CGContextStrokePath(context);
  
}


@end
