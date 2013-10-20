//
//  ViewController.m
//  DesignKichinTimer
//
//  Created by z on 2013/10/18.
//  Copyright (c) 2013 FoceSystemSolution. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController


- (void)viewWillAppear:(BOOL)animated
{
  // 全体背景枠
  self.view.layer.backgroundColor = [UIColor whiteColor].CGColor;
  self.view.layer.cornerRadius = 50.0;
  self.view.layer.frame = CGRectInset(self.view.layer.frame, 20, 20);
  
  //  self.view.layer.contents = (id)[UIImage imageNamed:@"bg01.jpg"].CGImage;
//  CALayer *sublayer = [CALayer layer];
//  sublayer.backgroundColor = [UIColor blueColor].CGColor;
//  sublayer.shadowOffset = CGSizeMake(0, 3);
//  sublayer.shadowRadius = 5.0;
//  sublayer.shadowColor = [UIColor blackColor].CGColor;
//  sublayer.shadowOpacity = 0.8;
//  sublayer.frame = CGRectMake(30, 30, 128, 192);
//  [self.view.layer addSublayer:sublayer];

  // 表示エリアの外側デザイン枠
  
  
  
  // カウント表示エリア生成
  int cntW = 200; // width
  
  CALayer *sublayer = [CALayer layer];
//  sublayer.backgroundColor = [UIColor grayColor].CGColor;
  sublayer.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0].CGColor; // 薄いグレイ
  sublayer.shadowOffset = CGSizeMake(0, 3);
  sublayer.shadowRadius = 5.0;
  sublayer.shadowColor = [UIColor blueColor].CGColor;
  sublayer.shadowOpacity = 0.8;
  sublayer.frame = CGRectMake([self arignCenter:cntW], 60, cntW, 100); // x y w h
  sublayer.borderColor = [UIColor blackColor].CGColor;
  sublayer.borderWidth = 2.0;
  sublayer.cornerRadius = 10.0;
  [self.view.layer addSublayer:sublayer];
  
  
//  CALayer *imageLayer = [CALayer layer];
//  imageLayer.frame = sublayer.bounds;
//  imageLayer.cornerRadius = 10.0;
//  imageLayer.contents = (id) [UIImage imageNamed:@"xxxbg01.jpg"].CGImage;
//  imageLayer.masksToBounds = YES;
//  [sublayer addSublayer:imageLayer];
  
  
//  // ローカライズ Sample
//  UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(550,550,300,30)]; // x y w h
//  //  label.text = [NSString stringWithFormat:@"%@",NSLocalizedString(@"AppName", nil)];
//  label.text = NSLocalizedString(@"AppName", nil);
//  label.layer.borderWidth = 2.0;
//  label.layer.borderColor = [UIColor blueColor].CGColor;
////  NSLog(@"%@", NSLocalizedString(@"AppName", nil));
//  [self.view addSubview:label];
}





// 中央寄せ用 X座標算出
- (int)arignCenter:(int)w
{
  //画面情報(横幅)取得
  UIScreen *sc = [UIScreen mainScreen];
  CGRect rect = sc.bounds;
  
  // 現在が横向きの場合の対処
  UIDeviceOrientation o = [UIDevice currentDevice].orientation;
  
  if (o == UIDeviceOrientationLandscapeLeft || o == UIDeviceOrientationLandscapeRight) {
    NSLog(@"height=%f",rect.size.height);
    return ( rect.size.height - w ) / 2;
  }else{
    NSLog(@"width=%f",rect.size.width);
    return ( rect.size.width - w ) / 2;
  }
}



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
