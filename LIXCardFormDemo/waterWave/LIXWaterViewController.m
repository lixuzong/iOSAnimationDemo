//
//  LIXWaterViewController.m
//  LIXCardFormDemo
//
//  Created by lixu on 2016/12/19.
//  Copyright © 2016年 lixuzong. All rights reserved.
//

#import "LIXWaterViewController.h"
#import "LIXWaterWaveView.h"

@interface LIXWaterViewController ()

@end

@implementation LIXWaterViewController

- (void)dealloc {
    NSLog(@" water view controller dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    
    LIXWaterWaveView *waterWaveView = [[LIXWaterWaveView alloc] initWithFrame:CGRectMake(0, 200, self.view.bounds.size.width, 200)];
    
    [self.view addSubview:waterWaveView];
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
