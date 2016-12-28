//
//  LIXContainerViewController.m
//  LIXCardFormDemo
//
//  Created by lixu on 2016/12/21.
//  Copyright © 2016年 lixuzong. All rights reserved.
//

#import "LIXContainerViewController.h"

#import "LIXBouncePresentAnimaion.h"
#import "LIXPrivateTransitionContext.h"

static CGFloat const kButtonSlotWidth = 100;
static CGFloat const kButtonSlotHeight = 44;

@interface LIXContainerViewController ()

@property (nonatomic, strong) UIView *privateContainerView;
@property (nonatomic, strong) UIView *privateButtonsView;

@property (nonatomic, strong) NSArray *configrations;

@end

@implementation LIXContainerViewController

- (instancetype)initWithViewControllers:(NSArray *)viewControllers {
    NSParameterAssert([viewControllers count] > 0);
    
    if(!(self = [super init])) return nil;
    
    self.viewControllers = [viewControllers copy];
    
    self.configrations = ({
        NSArray *configurations = @[
                                    @{@"title": @"First", @"color": [UIColor colorWithRed:0.4f green:0.8f blue:1 alpha:1]},
                                    @{@"title": @"Second", @"color": [UIColor colorWithRed:1 green:0.4f blue:0.8f alpha:1]},
                                    @{@"title": @"Third", @"color": [UIColor colorWithRed:1 green:0.8f blue:0.4f alpha:1]},
                                    ];
        configurations;
    });
    
    return self;
}

- (void)loadView {
    
    UIView *rootView = [[UIView alloc] init];
    rootView.backgroundColor = [UIColor blackColor];
    rootView.opaque = YES;
    
    self.privateContainerView = [[UIView alloc] init];
    self.privateContainerView.backgroundColor = [UIColor blackColor];
    self.privateContainerView.opaque = YES;
    
    self.privateButtonsView = [[UIView alloc] init];
    self.privateButtonsView.backgroundColor = [UIColor redColor];
    self.privateButtonsView.tintColor = [UIColor colorWithWhite:1 alpha:0.75];
    
    [self.privateContainerView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.privateButtonsView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [rootView addSubview:self.privateContainerView];
    [rootView addSubview:self.privateButtonsView];
    
    // Container view fills out entire root view.
    [rootView addConstraint:[NSLayoutConstraint constraintWithItem:self.privateContainerView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:rootView attribute:NSLayoutAttributeWidth multiplier:1 constant:0]];
    [rootView addConstraint:[NSLayoutConstraint constraintWithItem:self.privateContainerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:rootView attribute:NSLayoutAttributeHeight multiplier:1 constant:0]];
    [rootView addConstraint:[NSLayoutConstraint constraintWithItem:self.privateContainerView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:rootView attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
    [rootView addConstraint:[NSLayoutConstraint constraintWithItem:self.privateContainerView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:rootView attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
    
    // Place buttons view in the top half, horizontally centered.
    [rootView addConstraint:[NSLayoutConstraint constraintWithItem:self.privateButtonsView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:[self.viewControllers count] * kButtonSlotWidth]];
    [rootView addConstraint:[NSLayoutConstraint constraintWithItem:self.privateButtonsView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.privateContainerView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [rootView addConstraint:[NSLayoutConstraint constraintWithItem:self.privateButtonsView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:kButtonSlotHeight]];
    [rootView addConstraint:[NSLayoutConstraint constraintWithItem:self.privateButtonsView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.privateContainerView attribute:NSLayoutAttributeCenterY multiplier:0.4f constant:0]];
    
    [self _addChildViewControllerButtons];
    
    self.view = rootView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.selectedViewController = self.selectedViewController ? : self.viewControllers[0];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return  UIStatusBarStyleLightContent;
}


- (UIViewController *)childViewControllerForStatusBarStyle {
    return self.selectedViewController;
}

#pragma mark - pravite

- (void)_addChildViewControllerButtons {
    
    [self.viewControllers enumerateObjectsUsingBlock:^(UIViewController *childViewController, NSUInteger idx, BOOL *stop) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *icon = [UIImage imageNamed:_configrations[idx][@"title"]];
        [button setImage:icon forState:UIControlStateNormal];
        UIImage *selectedIcon = [UIImage imageNamed:[_configrations[idx][@"title"] stringByAppendingString:@" Selected"]];
        [button setImage:selectedIcon forState:UIControlStateSelected];
        
        button.tag = idx;
        [button addTarget:self action:@selector(_buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.privateButtonsView addSubview:button];
        [button setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [self.privateButtonsView addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.privateButtonsView attribute:NSLayoutAttributeLeading multiplier:1 constant:(idx + 0.5f) * kButtonSlotWidth]];
        [self.privateButtonsView addConstraint:[NSLayoutConstraint constraintWithItem:button attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.privateButtonsView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    }];
}


- (void)_buttonTapped:(UIButton *)sender {
    
    UIViewController *selectedViewController = self.viewControllers[sender.tag];
    self.selectedViewController = selectedViewController;
}

- (void)_transitionToChildViewController:(UIViewController *)toViewController {
    
    UIViewController *fromViewController = ([self.childViewControllers count] > 0 ? self.childViewControllers[0] : nil);
    
    if (toViewController == fromViewController || ![self isViewLoaded]) {
        return;
    }
    
    UIView *toView = toViewController.view;
    [toView setTranslatesAutoresizingMaskIntoConstraints:YES];
    toView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    toView.frame = self.privateContainerView.bounds;
    
    [fromViewController willMoveToParentViewController:nil];
    [self addChildViewController:toViewController];
    
    if (!fromViewController) {
        [self.privateContainerView addSubview:toViewController.view];
        [toViewController didMoveToParentViewController:self];
        return;
    }
    
    NSUInteger fromIndex = [self.viewControllers indexOfObject:fromViewController];
    NSUInteger toIndex = [self.viewControllers indexOfObject:toViewController];
    
    LIXBouncePresentAnimaion *animator = [[LIXBouncePresentAnimaion alloc] initWithType:LIXTransitionType_ScrollTabBar];
    animator.direction = toIndex > fromIndex ? ScrollTabBarDirection_right : ScrollTabBarDirection_left;
    
    LIXPrivateTransitionContext *transitionContext = [[LIXPrivateTransitionContext alloc] initWithFromViewController:fromViewController toViewController:toViewController goingRight:(toIndex > fromIndex)];
    transitionContext.animated = YES;
    transitionContext.interactive = NO;
    transitionContext.completionBlock = ^(BOOL didComplete) {
        [fromViewController.view removeFromSuperview];
        [fromViewController removeFromParentViewController];
        [toViewController didMoveToParentViewController:self];
        
        if ([animator respondsToSelector:@selector(animationEnded:)]) {
            [animator animationEnded:didComplete];
        }
        
        self.privateButtonsView.userInteractionEnabled = YES;
    };
    
    self.privateButtonsView.userInteractionEnabled = NO;
    [animator animateTransition:transitionContext];
    
}

- (void)_updateButtonSelection {
    
    [self.privateButtonsView.subviews enumerateObjectsUsingBlock:^(UIButton *button, NSUInteger idx, BOOL * stop) {
        
        button.selected = (self.viewControllers[idx] == self.selectedViewController);
    }];
}

#pragma mark - get & set method

- (void)setSelectedViewController:(UIViewController *)selectedViewController {
    NSParameterAssert(selectedViewController);
    
    [self _transitionToChildViewController:selectedViewController];
    
    _selectedViewController = selectedViewController;
    
    [self _updateButtonSelection];
}

@end
