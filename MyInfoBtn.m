//
//  MyInfoBtn.m
//  DesignKichinTimer
//
//  Created by z on 2013/12/23.
//  Copyright (c) 2013 FoceSystemSolution. All rights reserved.
//

#import "MyInfoBtn.h"

@implementation MyInfoBtn

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
      
      
      [self setBackgroundColor:[UIColor colorWithRed:0.2f green:0.2f blue:0.9f alpha:0.8f]];
      [self.layer setBorderColor:[[UIColor lightGrayColor] CGColor]];
      [self.layer setBorderWidth:1.f];
      
      
      if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        //iPhone

        // 角丸ぐあい
        [self.layer setCornerRadius:20.f];
        
        // Font Size
        self.titleLabel.font = [UIFont systemFontOfSize:14.f];
        
      }
      else{
        //iPad
        
        // 角丸ぐあい
        [self.layer setCornerRadius:40.f];
        
        // Font Size
        self.titleLabel.font = [UIFont systemFontOfSize:28.f];
      }
      
      [self.layer setShadowOpacity:0.5f];
      [self.layer setShadowOffset:CGSizeMake(2.f, 2.f)];
      
      [self addTarget:self action:@selector(myBtnTouchDown:) forControlEvents:UIControlEventTouchDown];//タッチ中
      [self addTarget:self action:@selector(myBtnTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];//リリース時

     
    }
    return self;
}

/*
 * ボタン押下時にボタンを下に少しずらす
 */
- (void)myBtnTouchDown:(id)sender
{
  UIButton *btnView   = (UIButton *)sender;
  btnView.layer.frame = CGRectMake(btnView.layer.frame.origin.x+3, btnView.layer.frame.origin.y+3, btnView.frame.size.width, btnView.frame.size.height);
  [btnView setBackgroundColor:[UIColor purpleColor]];
}

/*
 * ボタンを押し離した時にボタンを元に戻す
 */
- (void)myBtnTouchUpInside:(id)sender
{
  UIButton *btnView   = (UIButton *)sender;
  btnView.layer.frame = CGRectMake(btnView.layer.frame.origin.x-3, btnView.layer.frame.origin.y-3, btnView.frame.size.width, btnView.frame.size.height);
  [self setBackgroundColor:[UIColor colorWithRed:0.2f green:0.2f blue:0.9f alpha:0.8f]];
  
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
  
}
*/

@end
