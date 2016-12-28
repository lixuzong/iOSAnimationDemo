//
//  LIXCollectionViewLinerLayoutAttributes.m
//  LIXCardFormDemo
//
//  Created by lixu on 2016/11/29.
//  Copyright © 2016年 lixuzong. All rights reserved.
//

#import "LIXCollectionViewCoverLayoutAttributes.h"

@implementation LIXCollectionViewCoverLayoutAttributes

- (instancetype)copyWithZone:(NSZone *)zone {
    
    LIXCollectionViewCoverLayoutAttributes *attributes = [super copyWithZone:zone];
    
    attributes.shouldRasterize = self.shouldRasterize;
    attributes.maskingValue = self.maskingValue;
    
    return attributes;
}

- (BOOL)isEqual:(LIXCollectionViewCoverLayoutAttributes *)other {
    
    return [super isEqual:other]
        && (self.shouldRasterize == other.shouldRasterize)
        && self.maskingValue == other.maskingValue;
}

@end
