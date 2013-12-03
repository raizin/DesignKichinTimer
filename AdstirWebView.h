//
//  AdstirWebView.h
//
//  Copyright 2012 motionBEAT Inc. All Rights Reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define ADSTIRWEBVIEW_SSP_INTERVAL -1
#define ADSTIRWEBVIEW_NO_INTERVAL 0
#define ADSTIRWEBVIEW_MIN_INTERVAL 30
#define ADSTIRWEBVIEW_DEFAULT_INTERVAL 60

@class AdstirWebView;

@protocol AdstirWebViewDelegate <NSObject>
- (void) adstirWebViewWillLeaveApplication:(AdstirWebView*)webView;
@end

@interface AdstirWebView : UIView
- (id)initWithFrame:(CGRect)frame media:(NSString*)media spot:(NSString*)spot;
@property (assign) int  intervalTime;
@property (assign) id<AdstirWebViewDelegate> delegate;
@end
