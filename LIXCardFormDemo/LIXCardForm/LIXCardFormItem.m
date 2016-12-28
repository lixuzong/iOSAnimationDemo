//
//  LIXCardFormItem.m
//  LIXCardFormDemo
//
//  Created by lixu on 2016/11/28.
//  Copyright © 2016年 lixuzong. All rights reserved.
//

#import "LIXCardFormItem.h"
#import "LIXCollectionViewCoverLayoutAttributes.h"

@implementation LIXCardFormItem
{
    UIView *maskView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (!(self = [super initWithFrame:frame])) {
        return nil;
    }
    
    maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
    maskView.backgroundColor = [UIColor blackColor];
    maskView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    maskView.alpha = 0.0f;
    [self.contentView addSubview:maskView];
    
    return self;
}

- (void)prepareForReuse {
    
    [super prepareForReuse];
    
    [self.content removeFromSuperview];
    self.content = nil;
    
}

- (void)setContent:(UIView *)content {
    
    _content = content;
    
    content.frame = CGRectInset(self.contentView.bounds, 10, 10);
    content.translatesAutoresizingMaskIntoConstraints = YES;
    content.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.contentView addSubview:content];
}


- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    
    [super applyLayoutAttributes:layoutAttributes];
    maskView.alpha = 0.0f;
    self.layer.shouldRasterize = NO;
    
    if (![layoutAttributes isKindOfClass:[LIXCollectionViewCoverLayoutAttributes class]]) {
        return;
    }
    
    LIXCollectionViewCoverLayoutAttributes *attributes = (LIXCollectionViewCoverLayoutAttributes *)layoutAttributes;
    self.layer.shouldRasterize = attributes.shouldRasterize;
    maskView.alpha = attributes.maskingValue;
    
}

@end
