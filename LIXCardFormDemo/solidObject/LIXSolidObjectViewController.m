//
//  LIXSolidObjectViewController.m
//  LIXCardFormDemo
//
//  Created by lixu on 2016/12/14.
//  Copyright © 2016年 lixuzong. All rights reserved.
//

#import "LIXSolidObjectViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <GLKit/GLKit.h>

#import "LIXTwoSolidObjectView.h"

static const CGFloat kSolidWidth = 100.0f;

#define LIGHT_DIRECTION 0,1,-0.5
#define AMBIENT_LIGHT 0.5

@interface LIXSolidObjectViewController ()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) NSArray<UIView *> *faces;

@property (nonatomic, assign) CATransform3D perspective;

@property (nonatomic, strong) LIXTwoSolidObjectView *twoSolidView;

@end

@implementation LIXSolidObjectViewController

#pragma mark - life cycle method
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]
                                            initWithItems:@[
                                                            @"solid",
                                                            @"twoSolid"
                                                            ]];
    [segmentedControl addTarget:self action:@selector(handleSegmentedControl:) forControlEvents:UIControlEventValueChanged];
    
    segmentedControl.selectedSegmentIndex = 0;
    self.navigationItem.titleView = segmentedControl;
    
    [self setupView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private method

- (void)handleSegmentedControl:(UISegmentedControl *)segmentedControl {
    switch (segmentedControl.selectedSegmentIndex) {
        case 0:
        {
            self.containerView.hidden = NO;
            self.twoSolidView.hidden = YES;
        }
            break;
        case 1:
        {
            self.twoSolidView.hidden = NO;
            self.containerView.hidden = YES;
        }
        default:
            break;
    }
}

- (void)setupView {
    
    [self.view addSubview:self.twoSolidView];
    [self.view addSubview:self.containerView];
}

- (void)addFace:(NSInteger)index withTransform:(CATransform3D)transform {
    
    UIView *face = self.faces[index];
    [self.containerView addSubview:face];
    
    CGSize containerSize = self.containerView.bounds.size;
    face.center = CGPointMake(containerSize.width / 2, containerSize.height / 2);
    
    face.layer.transform = transform;
    
//    [self applyLightingToFace:face.layer];
}

- (void)handlePanGesterRecognizer:(UIPanGestureRecognizer *)pan {
    
    CGPoint beginPoint;
    CATransform3D perspective = CATransform3DIdentity;
    
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
        {
            beginPoint = [pan translationInView:self.view];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint currentPoint = [pan translationInView:self.view];
            CGFloat xDistance = beginPoint.x - currentPoint.x;
            CGFloat yDistance = beginPoint.y - currentPoint.y;
            perspective = CATransform3DRotate(perspective, -xDistance * M_PI / 180, 1, 0, 0);
            perspective = CATransform3DRotate(perspective, -yDistance * M_PI / 180, 0, 1, 0);
            self.containerView.layer.sublayerTransform = perspective;
            
        }
            break;
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        {
            [pan setTranslation:CGPointZero inView:self.view];
        }
            break;
        default:
            break;
    }
}

- (void)applyLightingToFace:(CALayer *)face {
    
    CALayer *layer = [CALayer layer];
    layer.frame = face.bounds;
    [face addSublayer:layer];
    
    CATransform3D transform = face.transform;
    GLKMatrix4 matrix4 = * (GLKMatrix4 *)&transform;
    GLKMatrix3 matrix3 = GLKMatrix4GetMatrix3(matrix4);
    
    GLKVector3 normal = GLKVector3Make(0, 0, 1);
    normal = GLKMatrix3MultiplyVector3(matrix3, normal);
    normal = GLKVector3Normalize(normal);
    
    GLKVector3 light = GLKVector3Normalize(GLKVector3Make(LIGHT_DIRECTION));
    float dotProduct = GLKVector3DotProduct(light, normal);
    
    CGFloat shadow = 1 + dotProduct - AMBIENT_LIGHT;
    UIColor *color = [UIColor colorWithWhite:0 alpha:shadow];
    layer.backgroundColor = color.CGColor;
}

#pragma mark - get & set method

- (NSArray<UIView *> *)faces {
    if (_faces) {
        return _faces;
    }
    NSMutableArray *mArr = [NSMutableArray arrayWithCapacity:6];
    for (int i = 1; i <= 6; i ++) {
        UIView *face = ({
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSolidWidth *2, kSolidWidth * 2)];
            view.layer.borderWidth = 1;
            view.layer.borderColor = [UIColor redColor].CGColor;
            view.backgroundColor = [UIColor whiteColor];
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
            button.center = CGPointMake(view.bounds.size.width / 2, view.bounds.size.height / 2);
            [button setTitle:[NSString stringWithFormat:@"%d",i] forState:UIControlStateNormal];
            [button setBackgroundColor:[UIColor redColor]];
            [view addSubview:button];
            view;
        });
        [mArr addObject:face];
    }
    _faces = [mArr copy];
    return _faces;
}

- (UIView *)containerView {
    
    if (_containerView) {
        return _containerView;
    }
    
    _containerView = ({
       
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        view.backgroundColor = [UIColor grayColor];
        view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesterRecognizer:)];
        [view addGestureRecognizer:pan];
        
        view;
    });
    
    self.perspective = CATransform3DIdentity;
    _perspective.m34 = -1.0 / 500.0;
    _perspective = CATransform3DRotate(_perspective, -M_PI_4, 1, 0, 0);
    _perspective = CATransform3DRotate(_perspective, -M_PI_4, 0, 1, 0);
    self.containerView.layer.sublayerTransform = _perspective;
    
    CATransform3D transform = CATransform3DMakeTranslation(0, 0, kSolidWidth);
    [self addFace:0 withTransform:transform];
    
    transform = CATransform3DMakeTranslation(kSolidWidth, 0, 0);
    transform = CATransform3DRotate(transform, M_PI_2, 0, 1, 0);
    [self addFace:1 withTransform:transform];
    
    transform = CATransform3DMakeTranslation(0, -kSolidWidth, 0);
    transform = CATransform3DRotate(transform, M_PI_2, 1, 0, 0);
    [self addFace:2 withTransform:transform];
    
    transform = CATransform3DMakeTranslation(0, kSolidWidth, 0);
    transform = CATransform3DRotate(transform, -M_PI_2, 1, 0, 0);
    [self addFace:3 withTransform:transform];
    
    transform = CATransform3DMakeTranslation(-kSolidWidth, 0, 0);
    transform = CATransform3DRotate(transform, -M_PI_2, 0, 1, 0);
    [self addFace:4 withTransform:transform];
    
    transform = CATransform3DMakeTranslation(0, 0, -kSolidWidth);
    transform = CATransform3DRotate(transform, M_PI, 0, 1, 0);
    [self addFace:5 withTransform:transform];
    
    _perspective = transform;
    
    return _containerView;
}

- (LIXTwoSolidObjectView *)twoSolidView {
    if (_twoSolidView) {
        return _twoSolidView;
    }
    
    _twoSolidView = [[LIXTwoSolidObjectView alloc] initWithFrame:self.view.bounds];
    
    return _twoSolidView;
}

@end
