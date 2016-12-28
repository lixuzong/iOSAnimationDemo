//
//  LIXContainerViewController.h
//  LIXCardFormDemo
//
//  Created by lixu on 2016/12/21.
//  Copyright © 2016年 lixuzong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LIXContainerViewController : UIViewController

- (instancetype)initWithViewControllers:(NSArray *)viewControllers;

@property (nonatomic, strong) UIViewController *selectedViewController;
@property (nonatomic, strong) NSArray *viewControllers;

@end
