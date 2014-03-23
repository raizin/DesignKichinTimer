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
      
      
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
  CGFloat radius = 10.0f;
  
  rect.origin.x += 0.75;
  rect.origin.y += 0.75;
  rect.size.width -= 1.5f;
  rect.size.height -= 1.5f;
  
  CGContextRef context = UIGraphicsGetCurrentContext();
  
  //塗りつぶし色の指定
  CGContextSetFillColorWithColor(context,[UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0].CGColor);//薄いグレイ
  //縁取り色の指定
  CGContextSetStrokeColorWithColor(context,[UIColor colorWithRed:0.5 green:0.5 blue:1.0 alpha:1.0].CGColor);//薄い青
  
  CGFloat leftX = CGRectGetMinX(rect); //X軸右位置
  CGFloat centerX = CGRectGetMidX(rect); //X軸中心
  CGFloat rightX = CGRectGetMaxX(rect); //X軸左位置
  CGFloat bottomY = CGRectGetMinY(rect); //Y軸上位置
  CGFloat centerY = CGRectGetMidY(rect); //Y軸中心
  CGFloat topY = CGRectGetMaxY(rect); //Y軸下地点
  
  CGContextMoveToPoint(context, leftX, centerY); //パス描画開始座標
  CGContextAddArcToPoint(context, leftX, bottomY, centerX, bottomY, radius); //左下の角
  CGContextAddArcToPoint(context, rightX, bottomY, rightX, centerY, radius); //右下の角
  CGContextAddArcToPoint(context, rightX, topY, centerX, topY, radius); //右上の角
  CGContextAddArcToPoint(context, leftX, topY, leftX, centerY, radius); //左上の角
  CGContextClosePath(context);
  
  CGContextSetLineWidth(context, 8.0f);
  CGContextDrawPath(context, kCGPathFillStroke);//枠線と背面の塗りつぶし
  
  

  // L字型(『)の内影の作成
  CALayer* subLayer = [CALayer layer];
  subLayer.frame = rect;
  [self.layer addSublayer:subLayer];
  subLayer.masksToBounds = YES;
  
  CGSize size = subLayer.bounds.size;
  CGFloat x = 3.0;
  CGFloat y = 3.0;
  CGMutablePathRef pathRef = CGPathCreateMutable(); // polygon create
  
  CGPathMoveToPoint(pathRef, NULL, x, y); // start
  
  x += size.width - 5.0;
  CGPathAddLineToPoint(pathRef, NULL, x, y); // 1
  
  y += 10.0;
  CGPathAddLineToPoint(pathRef, NULL, x, y); // 2
  
  x -= size.width - 15.0;
  CGPathAddLineToPoint(pathRef, NULL, x, y); // 3
  
  y += size.height - 15.0;
  CGPathAddLineToPoint(pathRef, NULL, x, y); // 4
  
  x -= 5.0;   // (*)10
  CGPathAddLineToPoint(pathRef, NULL, x, y); // 5
  
  y -= 5.0;   // (*)size.height+10
  CGPathAddLineToPoint(pathRef, NULL, x, y); // 6
  
  CGPathAddLineToPoint(pathRef, NULL, 3.0, 3.0); // end
  
  CGPathCloseSubpath(pathRef);
  
  subLayer.shadowOffset = CGSizeMake(0.0, 0.0);
  subLayer.shadowColor = [[UIColor blackColor] CGColor];
  subLayer.shadowOpacity = 0.2; // 不透明度
  subLayer.shadowPath = pathRef;
  
  CGPathRelease(pathRef);
 
 
}


@end
