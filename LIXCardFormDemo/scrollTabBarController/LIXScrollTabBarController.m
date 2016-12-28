//
//  LIXScrollTabBarController.m
//  LIXCardFormDemo
//
//  Created by lixu on 2016/12/21.
//  Copyright © 2016年 lixuzong. All rights reserved.
//

#import "LIXScrollTabBarController.h"
#import "LIXBouncePresentAnimaion.h"

@interface LIXScrollTabBarController () <UITabBarControllerDelegate>

@property (nonatomic, assign) BOOL interActive;
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *interaction;

@property (nonatomic, assign) NSInteger subViewControllerCount;

@end

@implementation LIXScrollTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.interaction = [[UIPercentDrivenInteractiveTransition alloc] init];
    self.subViewControllerCount = self.viewControllers ? self.viewControllers.count : 0;
    self.delegate = self;
    
    UIView *topBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 60)];
    topBarView.backgroundColor = [UIColor redColor];
    
    [self.view addSubview:topBarView];
    
    self.tabBar.tintColor = [UIColor redColor];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self  action:@selector(handlePanGestureRecognize:)];
    [self.view addGestureRecognizer:pan];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)handlePanGestureRecognize:(UIPanGestureRecognizer *)panGesture {
    
    CGFloat transitionX = [panGesture translationInView:self.view].x;
    CGFloat progress = ABS(transitionX) / self.view.frame.size.width;
    
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            self.interActive = true;
            CGFloat velocityX = [panGesture velocityInView:self.view].x;
            if (velocityX < 0) {
                if (self.selectedIndex < _subViewControllerCount - 1) {
                    
                    self.selectedIndex += 1;
                }
            }
            else {
                if (self.selectedIndex > 0) {
                    
                    self.selectedIndex -= 1;
                }
            }
        }
            break;
            
        case UIGestureRecognizerStateChanged:
        {
            [self.interaction updateInteractiveTransition:progress];
        }
            break;
        
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
        {
            if (progress > 0.3) {
                self.interaction.completionSpeed = 0.99;
                [self.interaction finishInteractiveTransition];
            }
            else {
                self.interaction.completionSpeed = 0.99;
                [self.interaction cancelInteractiveTransition];
            }
            self.interActive = false;
        }
        default:
            break;
    }
    
}

#pragma mark - UITabBarControllerDelegate

- (id <UIViewControllerAnimatedTransitioning>)tabBarController:(UITabBarController *)tabBarController
                     animationControllerForTransitionFromViewController:(UIViewController *)fromVC
                                              toViewController:(UIViewController *)toVC {
    
    NSInteger fromIndex = [tabBarController.viewControllers indexOfObject:fromVC];
    NSInteger toIndex = [tabBarController.viewControllers indexOfObject:toVC];
    
    ScrollTabBarDirection dirction = fromIndex < toIndex ? ScrollTabBarDirection_right : ScrollTabBarDirection_left;
    
    LIXBouncePresentAnimaion *animation = [[LIXBouncePresentAnimaion alloc] initWithType:LIXTransitionType_ScrollTabBar];
    animation.direction = dirction;
    
    return animation;
}

- (id <UIViewControllerInteractiveTransitioning>)tabBarController:(UITabBarController *)tabBarController interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController {
    
    return _interActive ? _interaction : nil;
}

@end
