//
//  LIXDIYMainViewController.m
//  LIXCardFormDemo
//
//  Created by lixu on 2016/12/19.
//  Copyright © 2016年 lixuzong. All rights reserved.
//

#import "LIXDIYMainViewController.h"

#import "LIXDIYModalViewController.h"

#import "LIXBouncePresentAnimaion.h"

@interface LIXDIYMainViewController ()<LIXModalViewControllerDelegate, UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) LIXBouncePresentAnimaion *presentAnimation;

@end

@implementation LIXDIYMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(80, 120, 160, 40);
    [button setTitle:@"Spring!" forState:UIControlStateNormal];
    [button addTarget:self  action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *customButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    customButton.frame = CGRectMake(80, 200, 160, 40);
    [customButton setTitle:@"Custom !" forState:UIControlStateNormal];
    [customButton addTarget:self  action:@selector(customButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:customButton];
    
    [self.view addSubview:button];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)customButtonClick:(UIButton *)sender {
    
    self.presentAnimation = [[LIXBouncePresentAnimaion alloc] initWithType:LIXTransitionType_Custom];

    LIXDIYModalViewController *mvc = [[LIXDIYModalViewController alloc] init];
    mvc.delegate = self;
    mvc.transitioningDelegate = self;
    mvc.modalPresentationStyle = UIModalPresentationCustom;
    
    [self presentViewController:mvc animated:YES completion:nil];
}

- (void)buttonClick:(UIButton *)sender {
    
    self.presentAnimation = [[LIXBouncePresentAnimaion alloc] initWithType:LIXTransitionType_Spring];
    
    LIXDIYModalViewController *mvc = [[LIXDIYModalViewController alloc] init];
    mvc.delegate = self;
    mvc.transitioningDelegate = self;
# warning custom的时候containerView不是presentingView的父view。所以动画结束之后未被移除，在dimiss的时候注意不要重复添加,会导致presentingView被移除。
    mvc.modalPresentationStyle = UIModalPresentationFullScreen;
//    mvc.modalPresentationStyle = UIModalPresentationCustom;
    
    [self presentViewController:mvc animated:YES completion:nil];
}


#pragma mark - model delegate 

- (void)modalViewControllerDidClickedDismissButton:(LIXDIYModalViewController *)viewController {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - trasition delegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    
    return self.presentAnimation;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return  self.presentAnimation;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
