//
//  LIXBouncePresentAnimaion.h
//  LIXCardFormDemo
//
//  Created by lixu on 2016/12/19.
//  Copyright © 2016年 lixuzong. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

typedef NS_ENUM(NSUInteger, LIXTransitionType) {
    LIXTransitionType_Spring = 0,
    LIXTransitionType_Custom,
    LIXTransitionType_ScrollTabBar
};

typedef NS_ENUM(NSUInteger, ScrollTabBarDirection) {
    ScrollTabBarDirection_left,
    ScrollTabBarDirection_right
};

@interface LIXBouncePresentAnimaion : NSObject <UIViewControllerAnimatedTransitioning>

- (instancetype)initWithType:(LIXTransitionType)type;

@property (nonatomic, assign) ScrollTabBarDirection direction;

@property (nonatomic, assign) CGRect startRect;

@end
