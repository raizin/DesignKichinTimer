//
//  InfoViewController.m
//  DesignKichinTimer
//
//  Created by z on 2013/12/22.
//  Copyright (c) 2013 FoceSystemSolution. All rights reserved.
//

#import "InfoViewController.h"
#import "TriangleBtn.h"
#import "MyInfoBtn.h"

@interface InfoViewController ()

@end

@implementation InfoViewController


// nibなしView生成関数追加
- (id)init {
  return self;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
  
  // アプリバージョン情報取得
  NSString *appVer  = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleVersion"];
  NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleName"];
  
  // 起動回数
  int appLauchedCount = (int)[APP_DELEGATE getAppLauchedCount];
  
  
  // width
  float width  = self.view.frame.size.width;
  float height = self.view.frame.size.height;
  
  
  
  // 背景色
  self.view.backgroundColor = [UIColor whiteColor];
//  self.view.backgroundColor = [UIColor grayColor];
//  self.view.backgroundColor = [UIColor colorWithRed:0.9f green:0.9f blue:1.f alpha:0.f]; //薄い青

  // Review Button
  MyInfoBtn *toReviewBtn = [MyInfoBtn buttonWithType:UIButtonTypeCustom];
  [toReviewBtn setTitle:[NSString stringWithFormat:@"%@",NSLocalizedString(@"ToReview", nil)] forState:UIControlStateNormal];
  [toReviewBtn addTarget:self action:@selector(toReview:) forControlEvents:UIControlEventTouchUpInside];
  
  // Other App View Button
  MyInfoBtn *toApviewBtn = [MyInfoBtn buttonWithType:UIButtonTypeCustom];
  [toApviewBtn setTitle:[NSString stringWithFormat:@"%@",NSLocalizedString(@"ToApview", nil)] forState:UIControlStateNormal];
  [toApviewBtn addTarget:self action:@selector(toApview:) forControlEvents:UIControlEventTouchUpInside];
  
  // Get Pro Version Button
  MyInfoBtn *toGetproBtn = [MyInfoBtn buttonWithType:UIButtonTypeCustom];
  [toGetproBtn setTitle:[NSString stringWithFormat:@"%@",NSLocalizedString(@"ToGetpro", nil)] forState:UIControlStateNormal];
  [toGetproBtn addTarget:self action:@selector(toGetpro:) forControlEvents:UIControlEventTouchUpInside];
  
  
  
  
  
  // App Version Infomaion Label
  UILabel *labelVer = [[UILabel alloc] init];
  labelVer.textColor = [UIColor blueColor];
  labelVer.text =
     [NSString stringWithFormat:@"%@%@%@%d",NSLocalizedString(@"LabelVer", nil),appVer,NSLocalizedString(@"LabelNum", nil),(int)appLauchedCount];
  
  // Thanks Label
  UILabel *label3ks = [[UILabel alloc] init];
  label3ks.textColor = [UIColor blueColor];
  label3ks.text = [NSString stringWithFormat:@"%@%@",appName,NSLocalizedString(@"Label3ks", nil)];
  
  
  // Right Corner Close Button
  TriangleBtn *closeBtn = [TriangleBtn buttonWithType:UIButtonTypeCustom];
  [closeBtn setTitleShadowColor:[ UIColor grayColor ] forState:UIControlStateNormal ];
  [closeBtn setTitleShadowColor:[ UIColor whiteColor ] forState:UIControlStateHighlighted ];
  closeBtn.titleLabel.shadowOffset = CGSizeMake( -2.0f, -2.0f );
  [closeBtn addTarget:self action:@selector(didViewClose:) forControlEvents:UIControlEventTouchUpInside];

  
  // 現在の向きを取得
  int direction = self.interfaceOrientation;
  
  
  // 端末で分岐 (iPhone or iPad)
  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
    //iPhone
    labelVer.font = [UIFont systemFontOfSize:15.f];
    label3ks.font = [UIFont systemFontOfSize:15.f];
    
    closeBtn.titleLabel.font = [ UIFont fontWithName:@"Zapfino" size:10.f ];
    [closeBtn setTitle:[NSString stringWithFormat:@"%@",NSLocalizedString(@"Close", nil)] forState:UIControlStateNormal];
  
    if(direction == UIInterfaceOrientationPortrait || direction == UIInterfaceOrientationPortraitUpsideDown){
      //Tate
      
      closeBtn.frame = CGRectMake(width -100, height -90, 100, 90); // x y w h
      closeBtn.contentEdgeInsets = UIEdgeInsetsMake(75.f, 20.f, 0.f, 0.f); // 上 左 下 右
      toReviewBtn.layer.frame = CGRectMake(72.5f, height -160, 175, 40);// x y
      toApviewBtn.layer.frame = CGRectMake(72.5f, height -110, 175, 40);// x y
      toGetproBtn.layer.frame = CGRectMake(72.5f, height  -60, 185, 40);// x y
      
      label3ks.frame = CGRectMake(30, height/2 +10, width-30, 30);// x y w h
      labelVer.frame = CGRectMake(30, height/2 +35, width-30, 30);// x y w h
    }
    else if(direction == UIInterfaceOrientationLandscapeLeft || direction == UIInterfaceOrientationLandscapeRight){
      //Yoko
      
      closeBtn.frame = CGRectMake(height -100, width -90, 100, 90); // x y w h
      closeBtn.contentEdgeInsets = UIEdgeInsetsMake(75.f, 20.f, 0.f, 0.f); // 上 左 下 右
      toReviewBtn.layer.frame = CGRectMake( 50, width -100, 175, 40);// x y
      toApviewBtn.layer.frame = CGRectMake(250, width -100, 175, 40);// x y
      toGetproBtn.layer.frame = CGRectMake( 50, width  -50, 185, 40);// x y
      
      label3ks.frame = CGRectMake(100, width/2  -5, height-100, 30);// x y w h
      labelVer.frame = CGRectMake(100, width/2 +20, height-100, 30);// x y w h
    }
  
  
  }else{
    //iPad
    labelVer.font = [UIFont systemFontOfSize:28.f];
    label3ks.font = [UIFont systemFontOfSize:28.f];
    
    [closeBtn setTitle:[NSString stringWithFormat:@"%@",NSLocalizedString(@"Close_iPad", nil)] forState:UIControlStateNormal];
    closeBtn.titleLabel.font = [ UIFont fontWithName:@"Zapfino" size:25.f ];
  
    if(direction == UIInterfaceOrientationPortrait || direction == UIInterfaceOrientationPortraitUpsideDown){
      //Tate

      closeBtn.frame = CGRectMake(width -200, height -200, 200,200); // x y w h
      closeBtn.contentEdgeInsets = UIEdgeInsetsMake(100.f, 60.f, 0.f, 0.f); // 上 左 下 右
      toReviewBtn.layer.frame = CGRectMake( 50, height -340, 330, 80);// x y
      toApviewBtn.layer.frame = CGRectMake(425, height -340, 330, 80);// x y
      toGetproBtn.layer.frame = CGRectMake( 50, height -210, 365, 80);// x y
      
      label3ks.frame = CGRectMake(100, height/2 +40, width-100, 30);// x y w h
      labelVer.frame = CGRectMake(100, height/2 +80, width-100, 30);// x y w h
    }
    else if(direction == UIInterfaceOrientationLandscapeLeft || direction == UIInterfaceOrientationLandscapeRight){
      //Yoko
      
      closeBtn.frame = CGRectMake(height -200, width -200, 200,200); // x y w h
      closeBtn.contentEdgeInsets = UIEdgeInsetsMake(100.f, 60.f, 0.f, 0.f); // 上 左 下 右
      toReviewBtn.layer.frame = CGRectMake(100, width -250, 330, 80);// x y
      toApviewBtn.layer.frame = CGRectMake(475, width -250, 330, 80);// x y
      toGetproBtn.layer.frame = CGRectMake(100, width -150, 365, 80);// x y
      
      label3ks.frame = CGRectMake(100, width/2 +40, height-100, 30);// x y w h
      labelVer.frame = CGRectMake(100, width/2 +80, height-100, 30);// x y w h
    }
  
    
  }
  
  
  // Review Button
  [self.view addSubview:toReviewBtn];
  
  // Other App View Button
  [self.view addSubview:toApviewBtn];
  
  // Get Pro Version Button
  [self.view addSubview:toGetproBtn];
  
  // Infomaion Label
  [self.view addSubview:label3ks];
  [self.view addSubview:labelVer];
//  [self.view addSubview:startNum];

  // Right Corner Close Button
  [self.view addSubview:closeBtn];
}




- (void)toReview:(id)sender
{
  NSURL *url = [NSURL URLWithString:[[NSBundle mainBundle] objectForInfoDictionaryKey: @"ReviewURL"]];
  [[UIApplication sharedApplication] openURL:url];
}
- (void)toApview:(id)sender
{
  NSURL *url = [NSURL URLWithString:[[NSBundle mainBundle] objectForInfoDictionaryKey: @"ArtistURL"]];
  [[UIApplication sharedApplication] openURL:url];
}
- (void)toGetpro:(id)sender
{
  NSURL *url = [NSURL URLWithString:[[NSBundle mainBundle] objectForInfoDictionaryKey: @"GetProURL"]];
  [[UIApplication sharedApplication] openURL:url];
}



// ボタンアクション
- (void)didViewClose:(UIButton*)sender
{
  [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
