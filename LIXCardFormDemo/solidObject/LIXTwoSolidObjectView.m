//
//  LIXTwoSolidObjectView.m
//  LIXCardFormDemo
//
//  Created by lixu on 2016/12/15.
//  Copyright © 2016年 lixuzong. All rights reserved.
//

#import "LIXTwoSolidObjectView.h"

static const CGFloat kSolidWidth = 100.0f;

@interface LIXTwoSolidObjectView ()

@property (nonatomic, strong) UIView *containerView;

@end

@implementation LIXTwoSolidObjectView

- (instancetype)initWithFrame:(CGRect)frame {
    if(!(self = [super initWithFrame:frame])) return nil;
    
    self.backgroundColor = [UIColor grayColor];
    [self setupView];
    
    return self     ;
}

- (void)setupView {
    
    self.containerView = [[UIView alloc] initWithFrame:self.bounds];
    self.containerView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:_containerView];
    
    CATransform3D pt = CATransform3DIdentity;
    pt.m34 = -1.0 / 500;
    pt = CATransform3DTranslate(pt, 0, 100, 0);
    self.containerView.layer.sublayerTransform = pt;
    
    CATransform3D clt = CATransform3DIdentity;
    clt = CATransform3DTranslate(clt, kSolidWidth, 0, 0);
    CALayer *cube1 = [self cubeWithTransform:clt];
    [self.containerView.layer addSublayer:cube1];
    
    CATransform3D c2t = CATransform3DIdentity;
    c2t = CATransform3DTranslate(c2t, 5*kSolidWidth, 0, 0);
    c2t = CATransform3DRotate(c2t, -M_PI_4, 1, 0, 0);
    c2t = CATransform3DRotate(c2t, -M_PI_4, 0, 1, 0);
    CALayer *cube2 = [self cubeWithTransform:c2t];
    [self.containerView.layer addSublayer:cube2];
    
}

- (CALayer *)faceWithTransform:(CATransform3D)transform {
    
    CALayer *face = [CALayer layer];
    face.frame = CGRectMake(kSolidWidth, kSolidWidth, 2*kSolidWidth, 2*kSolidWidth);
    
    CGFloat red = (rand() / (double)INT_MAX);
    CGFloat green = (rand() / (double)INT_MAX);
    CGFloat blue = (rand() / (double)INT_MAX);
    
    face.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0f].CGColor;
    
    face.transform = transform;
    
    return face;
}

- (CALayer *)cubeWithTransform:(CATransform3D)perspective {
    
    CATransformLayer *cube = [CATransformLayer layer];
    
    CATransform3D transform = CATransform3DMakeTranslation(0, 0, kSolidWidth);
    [cube addSublayer:[self faceWithTransform:transform]];
    
    transform = CATransform3DMakeTranslation(kSolidWidth, 0, 0);
    transform = CATransform3DRotate(transform, M_PI_2, 0, 1, 0);
    [cube addSublayer:[self faceWithTransform:transform]];
    
    transform = CATransform3DMakeTranslation(0, -kSolidWidth, 0);
    transform = CATransform3DRotate(transform, M_PI_2, 1, 0, 0);
    [cube addSublayer:[self faceWithTransform:transform]];
    
    transform = CATransform3DMakeTranslation(0, kSolidWidth, 0);
    transform = CATransform3DRotate(transform, -M_PI_2, 1, 0, 0);
    [cube addSublayer:[self faceWithTransform:transform]];
    
    transform = CATransform3DMakeTranslation(-kSolidWidth, 0, 0);
    transform = CATransform3DRotate(transform, -M_PI_2, 0, 1, 0);
    [cube addSublayer:[self faceWithTransform:transform]];
    
    transform = CATransform3DMakeTranslation(0, 0, -kSolidWidth);
    transform = CATransform3DRotate(transform, M_PI, 0, 1, 0);
    [cube addSublayer:[self faceWithTransform:transform]];
    
    cube.transform = perspective;
    
    return cube;
}

@end
