//
//  MySetBtn.h
//  DesignKichinTimer
//
//  Created by z on 2013/11/25.
//  Copyright (c) 2013 FoceSystemSolution. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MySetBtn : UIButton{

}
- (void)setNum:(int)number minFlag:(BOOL)unitFlag fontSize:(float)fontSize;
- (void)setStart:(float)fontSize;
- (void)setReset:(float)fontSize;
- (void)setHis:(int)number fontSize:(float)btnFontSize enableFlg:(BOOL)enable;
@end
