//
//  LIXDynamicFlowLayout.m
//  LIXCardFormDemo
//
//  Created by lixu on 2016/12/5.
//  Copyright © 2016年 lixuzong. All rights reserved.
//

#import "LIXDynamicFlowLayout.h"

@interface LIXDynamicFlowLayout ()

@property (nonatomic, strong) UIDynamicAnimator *dynamicAniamtor;

@property (nonatomic, strong) NSMutableSet *visibleIndexPathsSet;
@property (nonatomic, assign) CGFloat lastestDelta;

@end

@implementation LIXDynamicFlowLayout

- (instancetype)init {
    
    if (!(self = [super init])) return nil;
    
    self.minimumInteritemSpacing = 50;
    self.minimumLineSpacing = 50;
    self.itemSize = CGSizeMake(240, 240);
    self.sectionInset = UIEdgeInsetsMake(50, 50, 50, 50);
    
    self.dynamicAniamtor = [[UIDynamicAnimator alloc] initWithCollectionViewLayout:self];
    self.visibleIndexPathsSet = [NSMutableSet set];
    
    return self     ;
    
}

- (void)prepareLayout {
    [super prepareLayout];
    
    CGRect visibleRect = CGRectInset((CGRect){
        .origin = self.collectionView.bounds.origin, .size = self.collectionView.frame.size
    }, -100, -100);
    
    NSArray *itemsInVisibleRectArray = [super layoutAttributesForElementsInRect:visibleRect];
    
    NSSet *itemsIndexPathsInVisibleRectSet = [NSSet setWithArray:[itemsInVisibleRectArray valueForKey:@"indexPath"]];
    
    NSArray *noLongerVisibleBehavious = [self.dynamicAniamtor.behaviors filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UIAttachmentBehavior *behavior, NSDictionary *bindings) {
        
        BOOL currentVisible = [itemsIndexPathsInVisibleRectSet member:[(UICollectionViewLayoutAttributes *)[[behavior items] firstObject] indexPath]] != nil;
        
        return !currentVisible;
    }]];
    
    [noLongerVisibleBehavious enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        
        [self.dynamicAniamtor removeBehavior:obj];
        [self.visibleIndexPathsSet removeObject:[(UICollectionViewLayoutAttributes *)[[obj items] firstObject] indexPath]];
    }];
    
    NSArray *newlyVisibleItems = [itemsInVisibleRectArray filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(UICollectionViewLayoutAttributes *item, NSDictionary *bindings) {
        
        BOOL currentlyVisible = [self.visibleIndexPathsSet member:item.indexPath] != nil;
        
        return !currentlyVisible;
        
    }]];
    
    CGPoint touchLocation = [self.collectionView.panGestureRecognizer locationInView:self.collectionView];
    
    [newlyVisibleItems enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes *item, NSUInteger idx, BOOL *stop) {
        
        CGPoint center = item.center;
        UIAttachmentBehavior *springBehavior = [[UIAttachmentBehavior alloc] initWithItem:item attachedToAnchor:center];
        
        springBehavior.length = 0.0f;
        springBehavior.damping = 0.8f;
        springBehavior.frequency = 1.0f;
        
        if (!CGPointEqualToPoint(CGPointZero, touchLocation)) {
            
            CGFloat yDistanceFromTouch = fabs(touchLocation.y - springBehavior.anchorPoint.y);
            CGFloat xDistanceFromTouch = fabs(touchLocation.x - springBehavior.anchorPoint.x);
            CGFloat scrollResistance = (yDistanceFromTouch + xDistanceFromTouch)/ 1500.0f;
            
            if (self.lastestDelta < 0) {
                center.y += MAX(self.lastestDelta, self.lastestDelta * scrollResistance);
            }
            else {
                
                center.y += MIN(self.lastestDelta, self.lastestDelta * scrollResistance);
            }
            item.center = center;
        }
        
        [self.dynamicAniamtor addBehavior:springBehavior];
        [self.visibleIndexPathsSet addObject:item.indexPath];
    }];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    return [self.dynamicAniamtor itemsInRect:rect];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.dynamicAniamtor layoutAttributesForCellAtIndexPath:indexPath];
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    
    UIScrollView *scrollView = self.collectionView;
    CGFloat delta = newBounds.origin.y - scrollView.bounds.origin.y;
    
    self.lastestDelta = delta;
    
    CGPoint touchLocation = [self.collectionView.panGestureRecognizer locationInView:self.collectionView];
    
    [self.dynamicAniamtor.behaviors enumerateObjectsUsingBlock:^(UIAttachmentBehavior *springBehavior, NSUInteger idx, BOOL *stop) {
        
        CGFloat yDistanceFromTouch = fabs(touchLocation.y - springBehavior.anchorPoint.y);
        CGFloat xDistanceFromTouch = fabs(touchLocation.x - springBehavior.anchorPoint.x);
        CGFloat scrollResistance = (yDistanceFromTouch + xDistanceFromTouch) / 1500.0f;
        
        UICollectionViewLayoutAttributes *item = (UICollectionViewLayoutAttributes *)[springBehavior.items firstObject];
        CGPoint center = item.center;
        if (delta < 0) {
            center.y += MAX(delta, delta * scrollResistance);
        }
        else {
            center.y += MIN(delta, delta * scrollResistance);
        }
        item.center = center;
        
        [self.dynamicAniamtor updateItemUsingCurrentState:item];
    }];
    
    return NO;
}

@end
