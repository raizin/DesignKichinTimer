//
//  ResetBtn.m
//  DesignKichinTimer
//
//  Created by z on 2014/03/31.
//  Copyright (c) 2014 FoceSystemSolution. All rights reserved.
//

#import "ResetBtn.h"

@implementation ResetBtn


// Stop & Reset Button
- (void)setReset:(BOOL)flag
{
  if(flag){
    [self setTitle:NSLocalizedString(@"btnReset", nil) forState:UIControlStateNormal];
  }else{
    [self setTitle:NSLocalizedString(@"btnStop", nil) forState:UIControlStateNormal];
  }
}


- (id)initWithFrame:(CGRect)frame
{
  float w=200,h=120,fontSize=50;// iPad Definition the width size and height size
  
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
    //iPhone
    w = 80;
    h = 60;
    fontSize = 24;
  }
  
  self = [super initWithFrame:CGRectMake(0,0,w,h)];//x y w h
  if (self) {
    
    [self setReset:YES];
    [self.titleLabel setFont:[UIFont boldSystemFontOfSize:fontSize/1.5f]];
    
    [self setBackgroundColor:[UIColor colorWithRed:0.9f green:0.9f blue:0.f alpha:0.8f]];
    [self.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [self.layer setBorderWidth:1.f];
    
    
    // Corner Radius
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
      [self.layer setCornerRadius:25.f];
    }
    else{
      [self.layer setCornerRadius:50.f];
    }
    
    // Shadow Setting
    [self.layer setShadowOpacity:0.5f];
    [self.layer setShadowOffset:CGSizeMake(2.f, 2.f)];
    
    
    //Background Color Control
    [self addTarget:self action:@selector(btnTouchDown) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(btnTouchUp) forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:self action:@selector(btnTouchUp) forControlEvents:UIControlEventTouchUpOutside];
    
    //Foreground Color Control
    [self setTitleColor:[UIColor blueColor]  forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted]; //TouchDown
    [self setTitleColor:[UIColor grayColor]  forState:UIControlStateDisabled];
  }
  return self;
}

/*
 * ボタン押下時にボタンを下に少しずらす
 */
- (void)btnTouchDown
{
  [self setCenter:CGPointMake(self.center.x +3, self.center.y +3)];
  [self setBackgroundColor:[UIColor brownColor]];
}

/*
 * ボタンを押し離した時にボタンを元に戻す
 */
- (void)btnTouchUp
{
  [self setCenter:CGPointMake(self.center.x -3, self.center.y -3)];
  [self setBackgroundColor:[UIColor colorWithRed:0.9 green:0.9 blue:0.0 alpha:0.8]];
}

@end
