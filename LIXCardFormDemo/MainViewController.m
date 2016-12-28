//
//  MainViewController.m
//  LIXCardFormDemo
//
//  Created by lixu on 2016/12/5.
//  Copyright © 2016年 lixuzong. All rights reserved.
//

#import "MainViewController.h"
#import "ViewController.h"
#import "LIXDynamicViewController.h"
#import "LIXDynamicFlowLayout.h"

#import "LIXNiceGoodsCollectionViewController.h"
#import "LIXNiceGoodsLayout.h"
#import "LIXDynamicFlowLayout.h"
#import "LIXScrollTabBarController.h"
#import "LIXContainerViewController.h"

static NSString *const kCellIdentifier = @"CellIdentifier";

@interface MainViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation MainViewController

- (void)loadView {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.dataSource = @[
                        @"transform3D效果",
                        @"UIKit dynamics效果",
                        @"好东西布局",
                        @"scroll tab bar",
                        @"自定义转场"
                        ];
    
    self.view = _tableView;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITabeleViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
    
    cell.textLabel.text = _dataSource[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        ViewController *vc = [[ViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.row == 1) {
        
        UICollectionViewFlowLayout *dynamicLayout = [[UICollectionViewFlowLayout alloc] init];
        dynamicLayout.minimumInteritemSpacing = 50;
        dynamicLayout.minimumLineSpacing = 50;
        dynamicLayout.itemSize = CGSizeMake(240, 240);
        dynamicLayout.sectionInset = UIEdgeInsetsMake(50, 50, 50, 50);
        
//        LIXDynamicViewController *vc = [[LIXDynamicViewController alloc] initWithCollectionViewLayout:dynamicLayout];
        LIXDynamicViewController *vc = [[LIXDynamicViewController alloc] initWithCollectionViewLayout:[[LIXDynamicFlowLayout alloc] init]];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else if (indexPath.row == 2) {
        
        LIXNiceGoodsCollectionViewController *goodsVC = [[LIXNiceGoodsCollectionViewController alloc] initWithCollectionViewLayout:[LIXDynamicFlowLayout new]];
        
        [self.navigationController pushViewController:goodsVC animated:YES];
    }
    
    else if(indexPath.row == 3) {
        
        LIXScrollTabBarController *tabBar = [[LIXScrollTabBarController alloc] init];
        
        NSMutableArray *temArr = [NSMutableArray array];
        for (int i = 0; i <= 3; i ++) {
            
            LIXDynamicViewController *vc = [[LIXDynamicViewController alloc] initWithCollectionViewLayout:[[LIXDynamicFlowLayout alloc] init]];
            vc.title = [NSString stringWithFormat:@"VC %d",i];
            
            [temArr addObject:vc];
        }
        
        tabBar.viewControllers = temArr;
        
        [self.navigationController pushViewController:tabBar animated:YES];
        
    }
    
    else if(indexPath.row == 4) {
        
        NSMutableArray *temArr = [NSMutableArray array];
        for (int i = 0; i <= 2; i ++) {
            
            UIViewController *vc = [[UIViewController alloc] init];
            vc.title = [NSString stringWithFormat:@"VC %d",i];
            
            CGFloat red = arc4random() / (CGFloat)INT_MAX;
            CGFloat blue = arc4random() / (CGFloat)INT_MAX;
            CGFloat green = arc4random() / (CGFloat)INT_MAX;
            vc.view.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1];
            
            [temArr addObject:vc];
        }
        
        LIXContainerViewController *containerVC = [[LIXContainerViewController alloc] initWithViewControllers:temArr];
        
        [self.navigationController pushViewController:containerVC animated:YES];
    }
}

@end
