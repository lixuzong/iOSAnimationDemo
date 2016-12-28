//
//  LIXPrivateTransitionContext.m
//  LIXCardFormDemo
//
//  Created by lixu on 2016/12/21.
//  Copyright © 2016年 lixuzong. All rights reserved.
//

#import "LIXPrivateTransitionContext.h"

@interface LIXPrivateTransitionContext ()

@property (nonatomic, strong) NSDictionary *privateViewControllers;
@property (nonatomic, assign) CGRect privateDisappearingFromRect;
@property (nonatomic, assign) CGRect privateAppearingFromRect;
@property (nonatomic, assign) CGRect privateDisappearingToRect;
@property (nonatomic, assign) CGRect privateAppearingToRect;

@property (nonatomic, weak) UIView *containerView;
@property (nonatomic, assign) UIModalPresentationStyle presentationStyle;

@end

@implementation LIXPrivateTransitionContext

- (instancetype)initWithFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController goingRight:(BOOL)goingRight {
    
    if (!(self = [super init])) return nil;
    
    self.presentationStyle = UIModalPresentationCustom;
    self.containerView = fromViewController.view.superview;
    
    self.privateViewControllers =
  @{
        UITransitionContextFromViewControllerKey: fromViewController,
        UITransitionContextToViewControllerKey: toViewController
    };
    
    CGFloat travelDistance = (goingRight ? - self.containerView.bounds.size.width : self.containerView.bounds.size.width);
    
    self.privateAppearingFromRect = self.privateAppearingToRect = self.containerView.bounds;
    self.privateDisappearingToRect = CGRectOffset(self.containerView.bounds, travelDistance, 0);
    self.privateAppearingFromRect = CGRectOffset(self.containerView.bounds, -travelDistance, 0);
    
    return self;
}

- (CGRect)initialFrameForViewController:(UIViewController *)vc {
    
    if (vc == [self viewControllerForKey:UITransitionContextFromViewControllerKey]) {
        return self.privateDisappearingFromRect;
    }
    else {
        return self.privateAppearingFromRect;
    }
}

- (CGRect)finalFrameForViewController:(UIViewController *)vc {
    if (vc == [self viewControllerForKey:UITransitionContextFromViewControllerKey]) {
        return self.privateDisappearingToRect;
    }
    else {
        return self.privateAppearingToRect;
    }
}

- (UIViewController *)viewControllerForKey:(NSString *)key {
    return self.privateViewControllers[key];
}

- (BOOL)transitionWasCancelled { return NO; }

- (void)updateInteractiveTransition:(CGFloat)percentComplete {};
- (void)finishInteractiveTransition{}
- (void)cancelInteractiveTransition{};
- (void)pauseInteractiveTransition{};

- (void)completeTransition:(BOOL)didComplete {
    
    if (self.completionBlock) {
        self.completionBlock(didComplete);
    }

};


@end
