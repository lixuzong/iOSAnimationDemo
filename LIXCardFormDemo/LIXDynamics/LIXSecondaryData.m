//
//  LIXSecondaryData.m
//  LIXCardFormDemo
//
//  Created by lixu on 2016/12/5.
//  Copyright © 2016年 lixuzong. All rights reserved.
//

#import "LIXSecondaryData.h"

NSString *const LIXScondaryIdentifier = @"LIXScondaryCell";

@implementation LIXSecondaryData

- (void)collectionView:(UICollectionView *)collectionView registerClass:(__unsafe_unretained Class)cellClass {
    
    [collectionView registerClass:cellClass forCellWithReuseIdentifier:LIXScondaryIdentifier];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 100;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:LIXScondaryIdentifier forIndexPath:indexPath];
    
    [cell setBackgroundColor:[UIColor blueColor]];
    
    return cell;
}

@end
