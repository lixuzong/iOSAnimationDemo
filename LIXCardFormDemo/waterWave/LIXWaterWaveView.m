//
//  LIXWaterWaveView.m
//  LIXCardFormDemo
//
//  Created by lixu on 2016/12/19.
//  Copyright © 2016年 lixuzong. All rights reserved.
//

#define rgba(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

#import "LIXWaterWaveView.h"

static const CGFloat kWaterWaveHeight = 200.0f;
static const CGFloat kAniamtionDuration = 20.0f;

@interface LIXWaterWaveView ()

@property (nonatomic, strong) CADisplayLink *displayLink;

@property (nonatomic, strong) CAShapeLayer *firstWaveLayer;
@property (nonatomic, strong) CAShapeLayer *secondeWaveLayer;
@property (nonatomic, strong) CAShapeLayer *thirdWaveLayer;

//控制属性
@property (nonatomic, assign) CGFloat waveAmplitude; //振幅
@property (nonatomic, assign) CGFloat waveCycle; //周期
@property (nonatomic, assign) CGFloat waveSpeed; //速度
@property (nonatomic, assign) CGFloat waterWaveHeight;
@property (nonatomic, assign) CGFloat waterWaveWidth;
@property (nonatomic, assign) CGFloat wavePointY;
@property (nonatomic, assign) CGFloat waveOffsetX;
@property (nonatomic, strong) UIColor *waveColor;

@property (nonatomic, assign) CGFloat waveSpeed2;

//缓冲控制
@property (nonatomic, assign) NSTimeInterval startTime;
@property (nonatomic, assign) NSTimeInterval lastTime;

@end

@implementation LIXWaterWaveView

- (instancetype)initWithFrame:(CGRect)frame {
    if(!(self = [super initWithFrame:frame])) return nil;
    
    self.backgroundColor = rgba(251, 91, 91, 1);
    self.layer.masksToBounds = YES;
    
    [self configParams];
    [self startWave];
    
    return self;
}

#pragma mark ========= private method =========
#pragma mark - 配置参数
- (void)configParams {
    
    self.waterWaveWidth = self.frame.size.width;
    self.waterWaveHeight = kWaterWaveHeight;
    self.waveColor = rgba(255, 255, 255, 0.1);
    self.waveSpeed = 0.25 / M_PI;
    self.waveSpeed2 = .03 / M_PI;
    self.waveOffsetX = 0;
    self.wavePointY = _waterWaveHeight - 50;
    self.waveAmplitude = 13;
    self.waveCycle = 1.29 * M_PI / _waterWaveWidth;
}

- (void)getCurrentWave {
    
    if (_lastTime - _startTime >= 10.0f) {
        [_displayLink invalidate];
        [_displayLink removeFromRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
    
    NSTimeInterval currentTime = CACurrentMediaTime();
    double delta = currentTime - _lastTime;
    _lastTime = currentTime;
    
    NSTimeInterval time = MIN(1.0f, (currentTime - _startTime) / kAniamtionDuration);
    delta = [self easeInOut:time];
    NSLog(@"%f ====== %f", (currentTime - _startTime) / kAniamtionDuration, delta);
    _waveOffsetX += _waveSpeed * delta + 0.25;
    
    [self configWaveLayerPath];
}


#pragma mark - 加载layer，绑定runLoop 帧刷新
- (void)startWave {
    
    self.startTime = CACurrentMediaTime();
    
    [self.layer addSublayer:self.firstWaveLayer];
    [self.layer addSublayer:self.secondeWaveLayer];
    [self.layer addSublayer:self.thirdWaveLayer];
    
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

#pragma mark - 每帧3个layer的位置计算

- (void)configWaveLayerPath {
    
    
    
    CGMutablePathRef path1 = CreateWavePath(_waveAmplitude, _waveOffsetX - 10, _wavePointY + 10, self.frame.size.width, kWaterWaveHeight, _waveCycle,_wavePointY);
    self.firstWaveLayer.path = path1;
    CGPathRelease(path1);
    
    CGMutablePathRef path2 = CreateWavePath(_waveAmplitude -2, _waveOffsetX, _wavePointY, self.frame.size.width, kWaterWaveHeight, _waveCycle,_wavePointY);
    self.secondeWaveLayer.path = path2;
    CGPathRelease(path2);
    
    CGMutablePathRef path3 = CreateWavePath(_waveAmplitude +2, _waveOffsetX + 20, _wavePointY - 10, self.frame.size.width, kWaterWaveHeight, _waveCycle,_wavePointY);
    self.thirdWaveLayer.path = path3;
    CGPathRelease(path3);
    
}

CGMutablePathRef CreateWavePath(CGFloat amplitude, CGFloat offsetX, CGFloat offsetY, CGFloat width,CGFloat height,CGFloat cycle, CGFloat originY) {
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGFloat y = originY;
    CGPathMoveToPoint(path, nil, 0, y);
    for (float x = 0.0f; x <= width; x ++) {
        y = amplitude * sin(cycle * x + offsetX) + offsetY;
        CGPathAddLineToPoint(path, nil, x, y);
    }
    
    CGPathAddLineToPoint(path, nil, width, height);
    CGPathAddLineToPoint(path, nil, 0, height);
    CGPathCloseSubpath(path);
    
    return path;
}

- (CGFloat)easeInOut:(CGFloat)time
{
    return (time < 0.5)? 0.5 * pow(time * 2.0, 3.0): 0.5 * pow(time * 2.0 - 2.0, 3.0);
}

#pragma mark - get & set method

- (CAShapeLayer *)firstWaveLayer {
    if (_firstWaveLayer) {
        return _firstWaveLayer;
    }
    
    _firstWaveLayer = ({
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.fillColor = self.waveColor.CGColor;
        layer;
    });
    
    return _firstWaveLayer;
}

- (CAShapeLayer *)secondeWaveLayer {
    if (_secondeWaveLayer) {
        return _secondeWaveLayer;
    }
    
    _secondeWaveLayer = ({
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.fillColor = self.waveColor.CGColor;
        layer;
    });
    
    return _secondeWaveLayer;
}

- (CAShapeLayer *)thirdWaveLayer {
    if (_thirdWaveLayer) {
        return _thirdWaveLayer;
    }
    
    _thirdWaveLayer = ({
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.fillColor = self.waveColor.CGColor;
        layer;
    });
    
    return _thirdWaveLayer;
}

- (CADisplayLink *)displayLink {
    if (_displayLink) {
        return  _displayLink;
    }
    
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(getCurrentWave)];
    
    return _displayLink;
}

@end
