//
//  LIXCollectionViewLinerFlowLayout.m
//  LIXCardFormDemo
//
//  Created by lixu on 2016/11/28.
//  Copyright © 2016年 lixuzong. All rights reserved.
//

#import "LIXCollectionViewCoverFlowLayout.h"
#import "LIXCollectionViewCoverLayoutAttributes.h"

static const CGFloat ACTIVE_DISTANCE = 200.0f;
static const CGFloat TRANSLATE_DISTANCE = 200.0f;
static const CGFloat ZOOM_FACTOR = 0.2f;
static const CGFloat FLOW_OFFSET = 58.0f;
static const CGFloat INACTIVE_GREY_VALUE = 0.6f;

@implementation LIXCollectionViewCoverFlowLayout


- (instancetype)init {
    
    if(!(self = [super init])) return nil;
    
    self.minimumLineSpacing = -80.0f;
    self.minimumInteritemSpacing = 200;
    
    return self;
}

- (void)applyAttributes:(UICollectionViewLayoutAttributes *)attributes forVisibleRect:(CGRect)visibleRect {
    
    if (attributes.representedElementKind) return;

    CGFloat distanceFromVisibleRectToItem = CGRectGetMidX(visibleRect) - attributes.center.x;
    
    CGFloat normalizedDistance = distanceFromVisibleRectToItem / ACTIVE_DISTANCE;
    
    BOOL isLeft = (distanceFromVisibleRectToItem > 0);
    
    CATransform3D transform = CATransform3DIdentity;
    CGFloat maskAlpha = 0.0f;
    
    if (fabs(distanceFromVisibleRectToItem) < ACTIVE_DISTANCE) {
        
        transform = CATransform3DTranslate(transform, (isLeft ? - FLOW_OFFSET : FLOW_OFFSET) * ABS(distanceFromVisibleRectToItem / TRANSLATE_DISTANCE), 0, (1 - fabs(normalizedDistance) * 4000 + (isLeft ? 200 : 0)));
        transform.m34 = -1 / (4.6777f * self.itemSize.width);
        
        CGFloat zoom = 1 + ZOOM_FACTOR * (1 - ABS(normalizedDistance));
        
        transform = CATransform3DRotate(transform, (isLeft ? 1 : -1) * fabs(normalizedDistance) * 45 * M_PI / 180, 0, 1, 0);
        
        transform = CATransform3DScale(transform, zoom, zoom, 1);
        attributes.zIndex = 1;
        
        CGFloat ratioToCenter = (ACTIVE_DISTANCE - fabs(distanceFromVisibleRectToItem)) / ACTIVE_DISTANCE;
        
        maskAlpha = INACTIVE_GREY_VALUE + ratioToCenter * (-INACTIVE_GREY_VALUE);
    }
    
    else {
        
        transform.m34 = -1 / (4.6777f * self.itemSize.width);
        transform = CATransform3DTranslate(transform, isLeft ? - FLOW_OFFSET : FLOW_OFFSET, 0, 0);
        transform = CATransform3DRotate(transform, (isLeft ? 1 : -1) * 45 * M_PI / 180, 0, 1, 0);
        attributes.zIndex = 0;
        
        maskAlpha = INACTIVE_GREY_VALUE;
    }
    
    attributes.transform3D = transform;
    
    [(LIXCollectionViewCoverLayoutAttributes *)attributes setShouldRasterize:YES];
    [(LIXCollectionViewCoverLayoutAttributes *)attributes setMaskingValue:maskAlpha];
}

+ (Class)layoutAttributesClass {
    
    return [LIXCollectionViewCoverLayoutAttributes class];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    
    return YES;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSArray *layoutAttrtibutesArray = [super layoutAttributesForElementsInRect:rect];
    
    CGRect visibleRect = CGRectMake(self.collectionView.contentOffset.x, self.collectionView.contentOffset.y,CGRectGetWidth(self.collectionView.bounds), CGRectGetHeight(self.collectionView.bounds));
    
    for (UICollectionViewLayoutAttributes *attributes in layoutAttrtibutesArray) {
        
        if (CGRectIntersectsRect(attributes.frame, rect)) {
            
            [self applyAttributes:attributes forVisibleRect:visibleRect];
        }
    }
    
    return layoutAttrtibutesArray;
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    
    CGRect visibleRect = CGRectMake(self.collectionView.contentOffset.x, self.collectionView.contentOffset.y, CGRectGetWidth(self.collectionView.bounds), CGRectGetHeight(self.collectionView.bounds));
    
    [self applyAttributes:attributes forVisibleRect:visibleRect];
    
    return attributes;
}

-(BOOL)indexPathIsCentered:(NSIndexPath *)indexPath {
    
    CGRect visibleRect = CGRectMake(self.collectionView.contentOffset.x, self.collectionView.contentOffset.y, CGRectGetWidth(self.collectionView.frame), CGRectGetHeight(self.collectionView.frame));
    
    UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:indexPath];
    CGFloat distanceFromVisibleRectToItem = CGRectGetMidX(visibleRect) - attributes.center.x;
    
    return fabs(distanceFromVisibleRectToItem) < 1;
    
}

@end
