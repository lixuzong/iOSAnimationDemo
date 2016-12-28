//
//  LIXDIYModalViewController.m
//  LIXCardFormDemo
//
//  Created by lixu on 2016/12/19.
//  Copyright © 2016年 lixuzong. All rights reserved.
//

#import "LIXDIYModalViewController.h"

@interface LIXDIYModalViewController ()

@property (nonatomic, strong) UIButton *dismissButton;
@property (nonatomic, strong) UITextField *textField;

@end

@implementation LIXDIYModalViewController

- (void)loadView {
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    view.backgroundColor = [UIColor lightGrayColor];
    
    self.dismissButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.alpha = 0;
        button.frame = CGRectMake(80, 120, 160, 40);
        [button setTitle:@"Dismiss me!" forState:UIControlStateNormal];
        [button addTarget:self  action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        button;
    });
    [view addSubview:_dismissButton];
    
    self.textField = ({
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(230, 200, 0, 60)];
        textField.backgroundColor = [UIColor whiteColor];
        textField.placeholder = @"test text field";
        textField;
    });
    [view addSubview:_textField];
    
    self.view = view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.textField.frame = CGRectMake(200, 200, 100, 60);
        self.dismissButton.alpha = 1;
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)buttonClick:(id)sender {
    
    [UIView animateWithDuration:0.25 animations:^{
        self.textField.frame = CGRectMake(230, 200, 0, 60);
        self.dismissButton.alpha = 0;
    }];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(modalViewControllerDidClickedDismissButton:)]) {
        [self.delegate modalViewControllerDidClickedDismissButton:self];
    }
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
