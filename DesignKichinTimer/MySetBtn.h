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
- (void)setNum:(int)number minFlag:(BOOL)unitFlag;
- (void)setStart;
- (void)setReset:(BOOL)flag;
- (void)setHis:(int)number;
@end
