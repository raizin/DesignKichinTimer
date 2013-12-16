//
//  BtnZoomOnFlag.h
//  DesignKichinTimer
//
//  Created by z on 2013/12/16.
//  Copyright (c) 2013 FoceSystemSolution. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BtnZoomOnFlag : NSObject
+ (NSString *)name;
+ (void)setName:(NSString *)value;
+ (BOOL)val;
+ (void)setValue:(BOOL)value;
+ (void)sync;
@end
