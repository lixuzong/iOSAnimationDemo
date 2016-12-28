//
//  LIXDynamicViewController.m
//  LIXCardFormDemo
//
//  Created by lixu on 2016/12/5.
//  Copyright © 2016年 lixuzong. All rights reserved.
//

#import "LIXDynamicViewController.h"
#import "LIXDynamicFlowLayout.h"
#import "LIXDetailFlowLayout.h"

#import "LIXSolidObjectViewController.h"
#import "LIXSecondaryData.h"

#import "LIXLayerTestViewController.h"
#import "LIXWaterViewController.h"

#import "LIXDIYMainViewController.h"

#import "LIXBouncePresentAnimaion.h"

static NSString *const kCellIdentifier = @"cell";

@interface LIXDynamicViewController ()<UINavigationControllerDelegate>

@property (nonatomic, strong) UICollectionView *collectioView;
@property (nonatomic, strong) LIXSecondaryData *data;
@property (nonatomic, assign) CGRect startRect;

@end

@implementation LIXDynamicViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kCellIdentifier];
    
    self.navigationController.delegate = self;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 10000;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    [cell setBackgroundColor:[UIColor orangeColor]];
    
    return cell;
}

#pragma mark - UICollectionDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *nextVC;
    switch (indexPath.row) {
        case 0:
        {
            LIXSolidObjectViewController *solidVC = [[LIXSolidObjectViewController alloc] init];
            nextVC = solidVC;
        }
            break;
        case 1:
        {
            LIXLayerTestViewController *layerTestVC = [[LIXLayerTestViewController alloc] init];
            nextVC = layerTestVC;
        }
            break;
        case 2:
        {
            LIXWaterViewController *waterVC = [[LIXWaterViewController alloc] init];
            nextVC = waterVC;
        }
            
            break;
        case 3:
        {
            self.startRect = [collectionView cellForItemAtIndexPath:indexPath].frame;
            LIXDIYMainViewController *diyVC = [[LIXDIYMainViewController alloc] init];
            nextVC = diyVC;
        }
            break;
        case 4:
        {
            self.startRect = [collectionView cellForItemAtIndexPath:indexPath].frame;
        }
        default:
        {
            [collectionView deselectItemAtIndexPath:indexPath animated:NO];
            nextVC = [self toCollectionViewController];
        }
            break;
    }
    
    [self.navigationController pushViewController:nextVC animated:YES];
    
}

- (UICollectionViewController *)toCollectionViewController {
    
    UICollectionViewFlowLayout *dynamicLayout = [[UICollectionViewFlowLayout alloc] init];
    dynamicLayout.minimumInteritemSpacing = 50;
    dynamicLayout.minimumLineSpacing = 50;
    dynamicLayout.itemSize = CGSizeMake(500, 500);
    dynamicLayout.sectionInset = UIEdgeInsetsMake(50, 50, 50, 50);
    UICollectionViewController *viewController = [[UICollectionViewController alloc] initWithCollectionViewLayout:dynamicLayout];
    viewController.useLayoutToLayoutNavigationTransitions = YES;
    
    return viewController;
}

#pragma mark - UINavigationControllerDelegate


- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    
    
    if (viewController == self) {
        
        UICollectionViewController *collectionVC = (UICollectionViewController *)viewController;
        [collectionVC.collectionViewLayout invalidateLayout];
        
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
    }
    else if([viewController isKindOfClass:[UICollectionViewController class]]){
        
        UICollectionViewController *collectionVC = (UICollectionViewController *)viewController;
        self.data = [LIXSecondaryData new];
        [_data collectionView:collectionVC.collectionView registerClass:[UICollectionViewCell class]];
        collectionVC.collectionView.delegate = _data;
        collectionVC.collectionView.dataSource = _data;
        
        [collectionVC.collectionViewLayout invalidateLayout];
    }

}


- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC {
    
    if ([toVC isKindOfClass:[LIXDIYMainViewController class]]) {
        
        LIXBouncePresentAnimaion *animator = [[LIXBouncePresentAnimaion alloc] initWithType:LIXTransitionType_Spring];
        animator.startRect = self.startRect;
        return animator;
    }
    return nil;
    
}


@end
