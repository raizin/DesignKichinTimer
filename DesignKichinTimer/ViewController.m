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
  CALayer *sublayer = [CALayer layer];
  sublayer.backgroundColor = [UIColor blueColor].CGColor;
  sublayer.shadowOffset = CGSizeMake(0, 3);
  sublayer.shadowRadius = 5.0;
  sublayer.shadowColor = [UIColor blackColor].CGColor;
  sublayer.shadowOpacity = 0.8;
  sublayer.frame = CGRectMake(30, 30, 128, 192);
  [self.view.layer addSublayer:sublayer];
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
