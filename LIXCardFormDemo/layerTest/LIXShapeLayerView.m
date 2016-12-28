//
//  LIXShapeLayerView.m
//  LIXCardFormDemo
//
//  Created by lixu on 2016/12/14.
//  Copyright © 2016年 lixuzong. All rights reserved.
//

#import "LIXShapeLayerView.h"

@interface LIXShapeLayerView ()

@property (nonatomic, strong) UIBezierPath *path;

@end

@implementation LIXShapeLayerView



+ (Class)layerClass {
    return [CAShapeLayer class];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self setUpView];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame])) {
        return nil;
    }
    
    [self setUpView];
    
    return self;
    
}

- (void)setUpView {
    
    self.backgroundColor = [UIColor whiteColor];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 60, self.bounds.size.width, 20);
    gradientLayer.colors = @[
                             (__bridge id)[UIColor redColor].CGColor,
                             (__bridge id)[UIColor blueColor].CGColor
                             ];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    
    [self.layer addSublayer:gradientLayer];
    
    self.path = [[UIBezierPath alloc] init];
    
    CAShapeLayer *shapeLayer = (CAShapeLayer *)self.layer;
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineJoin = kCALineJoinRound;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.lineWidth = 5;
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    CGPoint point = [[touches anyObject] locationInView:self];
    
    [self.path moveToPoint:point];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGPoint point = [[touches anyObject] locationInView:self];
    
    [self.path addLineToPoint:point];
    ((CAShapeLayer *)self.layer).path = self.path.CGPath;
}
@end
