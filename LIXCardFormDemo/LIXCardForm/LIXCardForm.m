//
//  LIXCardForm.m
//  LIXCardFormDemo
//
//  Created by lixu on 2016/11/28.
//  Copyright © 2016年 lixuzong. All rights reserved.
//

#import "LIXCardForm.h"
#import "LIXCardFormItem.h"
#import "LIXCollectionViewBasicFlowLayout.h"
#import "LIXCollectionViewCoverFlowLayout.h"


static NSString *const kLIXCardFormItemCellIdentifier = @"LIXCardFormItemCellIdentifier";

static inline id safeObjectAtIndex(NSInteger index, NSArray *array) {
    
    return index < array.count ? array[index] : nil;
}

@interface LIXCardForm()

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *views;

@end

@implementation LIXCardForm

#pragma mark - life cycle method

- (instancetype)init {
    
    return [self initWithFrame:CGRectZero];
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if(!(self = [super initWithFrame:frame])) return nil;
    
    [self setupView];
    
    return self;
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    [self setupView];
}

#pragma mark - private method

- (void)setupView {
    
    self.views = [NSMutableArray array];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGestureRecognizer:)];
    [self.collectionView addGestureRecognizer:tap];
    
    [self addSubview:self.collectionView];

}

- (void)handleTapGestureRecognizer:(UITapGestureRecognizer *)recognizer {
    
    LIXCollectionViewBasicFlowLayout *flowLayout = (LIXCollectionViewBasicFlowLayout *)self.collectionView.collectionViewLayout;
    
    if (flowLayout.layoutType != LIXCardFormType_CoverFlow) {
        return;
    }
    
    if (recognizer.state != UIGestureRecognizerStateRecognized) {
        return;
    }
    
    CGPoint point = [recognizer locationInView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
    
    if (!indexPath) {
        return;
    }
    
    BOOL centered = [(LIXCollectionViewCoverFlowLayout *)flowLayout indexPathIsCentered:indexPath];
    
    if (centered) {
        
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
        
        [UIView transitionWithView:cell duration:0.5f options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
            cell.bounds = cell.bounds;
        } completion:nil];
    }
    else {
        
//        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:indexPath];
        CGPoint proposedOffset = CGPointMake(0, self.collectionView.contentOffset.y);
//        if (UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation)) {
        
//            proposedOffset.x = indexPath.item * (flowLayout.itemSize.width + flowLayout.minimumLineSpacing);
//        }
//        else {
        
            proposedOffset.x = indexPath.item * (flowLayout.itemSize.width + flowLayout.minimumLineSpacing);
//        }
        
        CGPoint contentOffset = [flowLayout targetContentOffsetForProposedContentOffset:proposedOffset withScrollingVelocity:CGPointMake(0, 0)];
        
        [self.collectionView setContentOffset:contentOffset animated:YES];
    }
}

- (void)configItem:(LIXCardFormItem *)item forIndexpath:(NSIndexPath *)indexPath {
    
    UIView *content = [self itemContentViewForIndexPath:indexPath];
    if (content) {
        item.content = content;
        return;
    }
    
    if (self.dataSource &&  [self.dataSource respondsToSelector:@selector(cardForm:viewForItemAtIndexPath:)]) {
        
        content = [self.dataSource cardForm:self viewForItemAtIndexPath:indexPath];
        item.content = content;
        [self.views addObject:content];
    }
}

- (UIView *)itemContentViewForIndexPath:(NSIndexPath *)indexPath {
    
    return safeObjectAtIndex(indexPath.row, self.views);
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _itemsCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    LIXCardFormItem *cell = (LIXCardFormItem *)[collectionView dequeueReusableCellWithReuseIdentifier:kLIXCardFormItemCellIdentifier forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor redColor];
    [self configItem:cell forIndexpath:indexPath];
    
    return cell;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    LIXCollectionViewBasicFlowLayout *myCollectionViewLayout = (LIXCollectionViewBasicFlowLayout *)collectionViewLayout;
    
    if (myCollectionViewLayout.layoutType == LIXCardFormType_Linear)
    {
        // A basic flow layout that will accommodate three columns in portrait
        return UIEdgeInsetsMake(10, 20, 10, 20);
    }
    else
    {
        if (UIDeviceOrientationIsPortrait([UIDevice currentDevice].orientation))
        {
            // Portrait is the same in either orientation
            return UIEdgeInsetsMake(0, 70, 0, 70);
        }
        else
        {
            // We need to get the height of the main screen to see if we're running
            // on a 4" screen. If so, we need extra side padding.
            if (CGRectGetHeight([[UIScreen mainScreen] bounds]) > 480)
            {
                return UIEdgeInsetsMake(0, 350, 0, 350);
            }
            else
            {
                return UIEdgeInsetsMake(0, 150, 0, 150);
            }
        }
    }
}


#pragma mark - set method

- (void)setDataSource:(id<LIXCardFormDataSource>)dataSource {
    
    if (_dataSource == dataSource) {
        return ;
    }
    _dataSource = dataSource;
    if (_dataSource && [_dataSource respondsToSelector:@selector(numberOfItemsInCardForm:)]) {
        self.itemsCount = [_dataSource numberOfItemsInCardForm:self];
    }
    [self.collectionView reloadData];
}

- (void)setType:(LIXCardFormType)type {
    switch (type) {
        case LIXCardFormType_Linear:
            self.collectionView.collectionViewLayout = [LIXCollectionViewBasicFlowLayout instanceOfType:LIXCardFormType_Linear];
            break;
            
        case LIXCardFormType_CoverFlow:
            self.collectionView.collectionViewLayout = [LIXCollectionViewBasicFlowLayout instanceOfType:LIXCardFormType_CoverFlow];
            break;
    }
    [self.collectionView.collectionViewLayout invalidateLayout];
}

#pragma mark - get method

- (UICollectionView *)collectionView {
   
    if(_collectionView) return _collectionView;
    
    _collectionView = ({
        LIXCollectionViewBasicFlowLayout *flowLayout = [LIXCollectionViewBasicFlowLayout instanceOfType:LIXCardFormType_CoverFlow];
        UICollectionView *collection = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:flowLayout];
        collection.translatesAutoresizingMaskIntoConstraints = YES;
        collection.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        collection.delegate = self;
        collection.dataSource = self;
        
        [collection registerClass:[LIXCardFormItem class] forCellWithReuseIdentifier:kLIXCardFormItemCellIdentifier];
        
        
        collection;
    });
    
    return _collectionView;
}


@end
