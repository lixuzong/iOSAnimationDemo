//
//  LIXBouncePresentAnimaion.m
//  LIXCardFormDemo
//
//  Created by lixu on 2016/12/19.
//  Copyright © 2016年 lixuzong. All rights reserved.
//

#import "LIXBouncePresentAnimaion.h"

@interface LIXBouncePresentAnimaion ()

@property (nonatomic, assign) LIXTransitionType type;

@end

@implementation LIXBouncePresentAnimaion

- (instancetype)initWithType:(LIXTransitionType)type {
    if(!(self = [super init])) return nil;
    
    self.type = type;
    
    return self;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    switch (self.type) {
        case LIXTransitionType_Spring:
            return 0.8;
            break;
        case LIXTransitionType_Custom:
            return 1.0f;
            break;
        case LIXTransitionType_ScrollTabBar:
            return 0.25f;
            break;
    }
    return 0.8f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    switch (self.type) {
        case LIXTransitionType_Custom:
            [self customTransitionAnimation:transitionContext];
            break;
        case LIXTransitionType_Spring:
            [self springTransitionAnimation:transitionContext];
            break;
        case LIXTransitionType_ScrollTabBar:
            [self scrollTabBarAnimation:transitionContext];
            break;
    }
    
}

- (void)scrollTabBarAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    UIView *fromView = fromVC.view;
    UIView *toView = toVC.view;
    
    CGFloat translation = containerView.frame.size.width;
    
    translation = self.direction == ScrollTabBarDirection_left ? translation : - translation;
    
    CGAffineTransform fromViewTransform = CGAffineTransformIdentity;
    fromViewTransform = CGAffineTransformMakeTranslation(translation, 0);
    
    CGAffineTransform toViewTransform = CGAffineTransformIdentity;
    toViewTransform = CGAffineTransformMakeTranslation(- translation, 0);
    
    toView.transform = toViewTransform;
    [containerView addSubview:toView];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        
        fromView.transform  = fromViewTransform;
        toView.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        fromView.transform = CGAffineTransformIdentity;
        toView.transform = CGAffineTransformIdentity;
        
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
    
}

- (void)customTransitionAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    UIView *fromView = fromVC.view;
    UIView *toView = toVC.view;
    
    
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    if (toVC.isBeingPresented) {
    
        [containerView addSubview:toView];
        
        CGFloat toViewWidth = containerView.frame.size.width * 2/3;
        CGFloat toViewHeight = containerView.frame.size.height * 2/3;
        toView.center = containerView.center;
        toView.bounds = CGRectMake(0, 0, 1, toViewHeight);
        
        UIView *dimmingView = [[UIView alloc] initWithFrame:toView.frame];
        [containerView insertSubview:dimmingView belowSubview:toView];
        dimmingView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        
        [UIView animateWithDuration:duration delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
            dimmingView.bounds = containerView.bounds;
            toView.bounds = CGRectMake(0, 0, toViewWidth, toViewHeight);
            
        } completion:^(BOOL finished) {
            
            [transitionContext completeTransition:YES];
        }];
    }
    
    if (fromVC.isBeingDismissed) {
        
        CGFloat fromViewHeight = fromView.frame.size.height;
        
        [UIView animateWithDuration:duration animations:^{
            
            fromView.bounds = CGRectMake(0, 0, 1, fromViewHeight);
        } completion:^(BOOL finished) {
            
            [transitionContext completeTransition:YES];
        }];
    }
}

- (void)springTransitionAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    CGRect finalFrame = [transitionContext finalFrameForViewController:toVC];
//    toVC.view.frame = CGRectOffset(finalFrame, 0, screenBounds.size.height);
    toVC.view.frame = self.startRect;
    toVC.view.backgroundColor = [UIColor orangeColor];
    
    UIView *containerView = [transitionContext containerView];
    [containerView addSubview:toVC.view];
    
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    [UIView animateWithDuration:duration
                          delay:0.0f
         usingSpringWithDamping:0.6
          initialSpringVelocity:0.0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^{
                         
                         toVC.view.frame = finalFrame;
                         //toVC.view.backgroundColor = [UIColor whiteColor];
                     } completion:^(BOOL finished) {
                         
                         
                         [transitionContext completeTransition:YES];
                     }];
}

@end
