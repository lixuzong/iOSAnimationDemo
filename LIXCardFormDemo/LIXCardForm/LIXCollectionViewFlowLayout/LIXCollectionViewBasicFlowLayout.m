//
//  LIXCollectionViewBasicFlowLayout.m
//  LIXCardFormDemo
//
//  Created by lixu on 2016/11/28.
//  Copyright © 2016年 lixuzong. All rights reserved.
//

#import "LIXCollectionViewBasicFlowLayout.h"
#import "LIXCollectionViewCoverFlowLayout.h"

@implementation LIXCollectionViewBasicFlowLayout

+ (instancetype)instanceOfType:(LIXCardFormType)type {
    
    LIXCollectionViewBasicFlowLayout *flowLayout;
    
    switch (type) {
        case LIXCardFormType_CoverFlow:
            
            flowLayout = [[LIXCollectionViewCoverFlowLayout alloc] init];
            break;
            
        case LIXCardFormType_Linear:
            flowLayout = [[LIXCollectionViewBasicFlowLayout alloc] init];
            break;
    }
    
    flowLayout.layoutType = type;
    
    return flowLayout;
}

- (instancetype)init {
    
    if(!(self = [super init])) return nil;
    
    self.itemSize = CGSizeMake(350, 350);
    self.minimumLineSpacing = 10.0f;
    self.minimumInteritemSpacing = 10.0f;
    self.sectionInset = UIEdgeInsetsMake(0, 20, 20, 20);
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    return self;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    
    CGFloat offsetAdjustment = MAXFLOAT;
    CGFloat horizontalCenter = proposedContentOffset.x + (CGRectGetWidth(self.collectionView.bounds) / 2.0);
    
    CGRect proposedRect = CGRectMake(proposedContentOffset.x, 0.0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    
    NSArray *array = [self layoutAttributesForElementsInRect:proposedRect];
    
    for (UICollectionViewLayoutAttributes *layoutAttributes in array) {
        
        if (layoutAttributes.representedElementCategory != UICollectionElementCategoryCell) {
            continue;
        }
        
        CGFloat itemHorizontalCenter = layoutAttributes.center.x;
        if (fabs(itemHorizontalCenter - horizontalCenter) < fabs(offsetAdjustment)) {
            
            offsetAdjustment = itemHorizontalCenter - horizontalCenter;
        }
    }
    
    return CGPointMake(proposedContentOffset.x + offsetAdjustment, proposedContentOffset.y);
}

@end
