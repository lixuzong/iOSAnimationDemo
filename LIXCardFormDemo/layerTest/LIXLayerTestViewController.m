//
//  LIXLayerTestViewController.m
//  LIXCardFormDemo
//
//  Created by lixu on 2016/12/14.
//  Copyright © 2016年 lixuzong. All rights reserved.
//

#import "LIXLayerTestViewController.h"
#import "LIXShapeLayerView.h"

@interface LIXLayerTestViewController ()

//用于测试render layer和Model layer的区别
@property (nonatomic, strong) UIView *renderLayerView;
@property (nonatomic, strong) CALayer *colorLayer;


//CAShapeLayer
@property (nonatomic, strong) LIXShapeLayerView *shapeView;


/**
 在info.plist文件中设置（Renders with group opacity）, 默认为YES，iOS6之前为NO
 */
@property (nonatomic , strong) UIView *groupView;

@end

@implementation LIXLayerTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc]
                                            initWithItems:@[@"render&modelLayer",
                                                            @"CAShapeLayer",
                                                            @"groupView"
                                                            ]
                                            ];
    [segmentedControl addTarget:self action:@selector(handleChangedOfSegmentedControl:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segmentedControl;
    
    [self implicitAnimaionTest];
    
    [self setUpSubViews];
    
    segmentedControl.selectedSegmentIndex = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private method

- (void)setUpSubViews {
    
    [self.view addSubview:self.groupView];
    [self.view addSubview:self.shapeView];
    [self.view addSubview:self.renderLayerView];
    
}

- (void)implicitAnimaionTest {
    
    NSLog(@"OutSide: %@",[self.view actionForLayer:self.view.layer forKey:@"backgroundColor"]);
    [UIView beginAnimations:nil context:nil];
    
    NSLog(@"InSide: %@",[self.view actionForLayer:self.view.layer forKey:@"backgroundColor"]);
    
    [UIView commitAnimations];
    
}

- (CAReplicatorLayer *)createReplicator {
    
    CAReplicatorLayer *replicator = [CAReplicatorLayer layer];
    replicator.frame = CGRectMake(0, 300, self.view.bounds.size.width, self.view.bounds.size.height - 300);
    
    replicator.instanceCount = 10;
    
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DTranslate(transform, 0, 200, 0);
    transform = CATransform3DRotate(transform, M_PI / 5.0, 0, 0,1);
    transform = CATransform3DTranslate(transform, 0, -200, 0);
    replicator.instanceTransform = transform;
    
    replicator.instanceBlueOffset = -0.1;
    replicator.instanceGreenOffset = -0.1;
    
    CALayer *layer = [CALayer layer];
    layer.frame = CGRectMake(100.0f, 100.0f, 100.0f, 100.0f);
    layer.backgroundColor = [UIColor whiteColor].CGColor;
    
    [replicator addSublayer:layer];
    
    return replicator;
}

- (UIButton *)customButton {
    CGRect frame = CGRectMake(0, 0, 150, 150);
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    button.backgroundColor = [UIColor whiteColor];
    button.layer.cornerRadius = 10;
    
    frame = CGRectMake(20, 10, 110, 30);
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = @"Hello World";
    label.backgroundColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [button addSubview:label];
    
    return button;
}

- (void)handleChangedOfSegmentedControl:(UISegmentedControl *)segmentedControl {
    switch (segmentedControl.selectedSegmentIndex) {
        case 0:
        {
            self.renderLayerView.hidden = NO;
            self.shapeView.hidden = YES;
            self.groupView.hidden = YES;
            
        }
            break;
        case 1:
        {
            self.groupView.hidden = YES;
            self.renderLayerView.hidden = YES;
            self.shapeView.hidden = NO;
        }
            break;
        case 2:
        {
            self.groupView.hidden = NO;
            self.renderLayerView.hidden = YES;
            self.shapeView.hidden = YES;
            
        }
            break;
        default:
            break;
    }
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    CGPoint point = [[touches anyObject] locationInView:self.renderLayerView];
    
    if ([self.colorLayer.presentationLayer hitTest:point]) {
        
        CGFloat red = arc4random() / (CGFloat)INT_MAX;
        CGFloat blue = arc4random() / (CGFloat)INT_MAX;
        CGFloat green = arc4random() / (CGFloat)INT_MAX;
        self.colorLayer.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1].CGColor;
    }
    else {
        
        [CATransaction begin];
        [CATransaction setAnimationDuration:4.0f];
        self.colorLayer.position = point;
        [CATransaction commit];
    }
}

#pragma mark - get & set method
- (UIView *)renderLayerView {
    if (_renderLayerView) {
        return  _renderLayerView;
    }
    
    _renderLayerView = ({
        
        UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
        view.backgroundColor = [UIColor whiteColor];
        
        self.colorLayer = [CALayer layer];
        self.colorLayer.frame = CGRectMake(0, 0, 100, 100);
        self.colorLayer.position = CGPointMake(view.bounds.size.width / 2, view.bounds.size.height / 2);
        self.colorLayer.backgroundColor = [UIColor redColor].CGColor;
        [view.layer addSublayer:self.colorLayer];
        
        self.colorLayer.cornerRadius = 20.0f;
        //这个方法会切掉阴影
        self.colorLayer.masksToBounds = YES;
        
        self.colorLayer.borderColor = [UIColor blackColor].CGColor;
        self.colorLayer.borderWidth = 5.0f;
        
        self.colorLayer.shadowOpacity = 0.8;
        self.colorLayer.shadowOffset = CGSizeMake(4, 4);
        self.colorLayer.shadowRadius = 10;
        self.colorLayer.shadowColor = [UIColor yellowColor].CGColor;
        
        view;
    });
    
    return _renderLayerView;
}

- (LIXShapeLayerView *)shapeView {
    if (_shapeView) {
        return  _shapeView;
    }
    
    _shapeView = [[LIXShapeLayerView alloc] initWithFrame:self.view.bounds];
    
    return _shapeView;
}

- (UIView *)groupView {
    
    if (_groupView) {
        return _groupView;
    }
    
    _groupView = ({
        UIView *view = [[UIView alloc] initWithFrame:self.view.bounds];
        view.backgroundColor = [UIColor grayColor];
        
        UIButton *button1 = [self customButton];
        button1.center = CGPointMake(250, 150);
        [view addSubview:button1];
        
        UIButton *button2 = [self customButton];
        button2.center = CGPointMake(450, 150);
        button2.alpha = 0.5;
        [view addSubview:button2];
        
        UIButton *button3 = [self customButton];
        button3.center = CGPointMake(650, 150);
        button3.alpha = 0.5;
        button3.layer.shouldRasterize = YES;
        button3.layer.rasterizationScale = [UIScreen mainScreen].scale;
        [view addSubview:button3];
        
        [view.layer addSublayer:[self createReplicator]];
        
        view;
    });
    
    return _groupView;
}

@end
