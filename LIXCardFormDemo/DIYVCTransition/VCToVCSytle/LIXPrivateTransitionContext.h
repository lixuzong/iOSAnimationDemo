//
//  LIXPrivateTransitionContext.h
//  LIXCardFormDemo
//
//  Created by lixu on 2016/12/21.
//  Copyright © 2016年 lixuzong. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface LIXPrivateTransitionContext : NSObject <UIViewControllerContextTransitioning, UIViewControllerInteractiveTransitioning>

- (instancetype)initWithFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController goingRight:(BOOL)goingRight;

@property (nonatomic, copy) void (^completionBlock)(BOOL didComplete);
@property (nonatomic, assign, getter=isAnimated) BOOL animated;
@property (nonatomic, assign, getter=isInteractive) BOOL interactive;

@end
