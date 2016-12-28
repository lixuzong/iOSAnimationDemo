//
//  LIXDIYModalViewController.h
//  LIXCardFormDemo
//
//  Created by lixu on 2016/12/19.
//  Copyright © 2016年 lixuzong. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LIXDIYModalViewController;

@protocol LIXModalViewControllerDelegate <NSObject>

- (void)modalViewControllerDidClickedDismissButton:(LIXDIYModalViewController *)viewController;

@end

@interface LIXDIYModalViewController : UIViewController

@property (nonatomic, weak) id<LIXModalViewControllerDelegate> delegate;

@end
