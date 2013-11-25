//
//  MyModeBtn.h
//  DesignKichinTimer
//
//  Created by z on 2013/11/25.
//  Copyright (c) 2013 FoceSystemSolution. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyModeBtn : UIButton{
}
- (void)ModeSelect:(CGRect)xywh btnTitle:(NSString *)lb;
- (void)SwitchIcon:(CGRect)xywh btnTitle:(NSString *)lb stateFlag:(BOOL)flag;

@end
