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

  CALayer *sublayer = [CALayer layer];
  sublayer.backgroundColor = [UIColor grayColor].CGColor;
  sublayer.shadowOffset = CGSizeMake(0, 3);
  sublayer.shadowRadius = 5.0;
  sublayer.shadowColor = [UIColor blueColor].CGColor;
  sublayer.shadowOpacity = 0.8;
  sublayer.frame = CGRectMake(60, 60, 269*2, 206*2); // x y w h
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
  
  //  NSLog(@"%f",rect.size.width);
  
  return ( rect.size.width - w ) / 2;
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
