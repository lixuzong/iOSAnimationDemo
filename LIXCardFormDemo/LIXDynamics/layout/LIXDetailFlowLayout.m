//
//  LIXDetailFlowLayout.m
//  LIXCardFormDemo
//
//  Created by lixu on 2016/12/5.
//  Copyright © 2016年 lixuzong. All rights reserved.
//

#import "LIXDetailFlowLayout.h"

@implementation LIXDetailFlowLayout

- (instancetype)init {
    if(!(self = [super init])) return nil;
    
    self.itemSize = CGSizeMake(50, 50);
    self.minimumLineSpacing = 30;
    self.minimumInteritemSpacing = 30;
    self.sectionInset = UIEdgeInsetsMake(30, 30, 30, 30);
    
    return self;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    return attributes;
}

@end
