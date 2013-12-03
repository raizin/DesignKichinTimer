//
//  AdstirInterstitial.h
//
//  Copyright (c) 2013年 United. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol AdstirInterstitialDelegate;

@interface AdstirInterstitial : NSObject
@property (copy,nonatomic) NSString* media;
@property (copy,nonatomic) NSString* spot;
@property (assign,nonatomic) id<AdstirInterstitialDelegate> delegate;
- (void)load;
- (void)show:(UIViewController*)vc;
@end

@protocol AdstirInterstitialDelegate <NSObject>
@optional
- (void)adstirInterstitialDidReceiveSetting:(AdstirInterstitial*)inter;
- (void)adstirInterstitialDidFailedToReceiveSetting:(AdstirInterstitial*)inter;
@end
