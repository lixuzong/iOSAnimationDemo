//
//  LIXNiceGoodsLayout.m
//  LIXCardFormDemo
//
//  Created by lixu on 2016/12/20.
//  Copyright © 2016年 lixuzong. All rights reserved.
//

#import "LIXNiceGoodsLayout.h"

@implementation LIXNiceGoodsLayout

- (instancetype)init {
    
    if(!(self = [super init])) return nil;
    
    self.itemSize = CGSizeMake(100, 100);
    self.minimumLineSpacing = 50;
    self.minimumInteritemSpacing = 50;
    self.sectionInset = UIEdgeInsetsMake(50, 100, 50, 100);
    
    return self;
}

- (void)prepareLayout {
    
    [super prepareLayout];
}

//- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
//    
//    NSArray *layoutAttributesArray = [super layoutAttributesForElementsInRect:rect];
//    
//    NSMutableArray *tempArr = [NSMutableArray array];
//    
//    for (UICollectionViewLayoutAttributes *attributes in layoutAttributesArray) {
//        
//        if (attributes.indexPath.section == 1) {
//            attributes.size = CGSizeMake(300, 300);
//        }
//        [tempArr addObject:attributes];
//    }
//    
//    return tempArr;
//}


- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

//- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
//    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
//    if (indexPath.section == 0) {
//        
//        attributes.size = CGSizeMake(300, 300);
//    }
//    
//    return attributes;
//}

@end
