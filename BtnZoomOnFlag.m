//
//  BtnZoomOnFlag.m
//  DesignKichinTimer
//
//  Created by z on 2013/12/15.
//  Copyright (c) 2013 FoceSystemSolution. All rights reserved.
//

#import "BtnZoomOnFlag.h"

@implementation BtnZoomOnFlag
static NSString *CONFIG_NAME = @"BtnZoomOnFlag.Name";
+ (NSString *)name {
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  [userDefaults registerDefaults:@{CONFIG_NAME : @"No Name"}];
  return [userDefaults objectForKey:CONFIG_NAME];
}
+ (void)setName:(NSString *)value {
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  [userDefaults setObject:value forKey:CONFIG_NAME];
}
static NSString *CONFIG_SET = @"BtnZoomOnFlag.Setting";
+ (BOOL)val {
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  [userDefaults registerDefaults:@{CONFIG_SET : @(YES)}];
  return [userDefaults boolForKey:CONFIG_SET];
}
+ (void)setValue:(BOOL)value {
  NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
  [userDefaults setBool:value forKey:CONFIG_SET];
}
+ (void)sync {
  [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
