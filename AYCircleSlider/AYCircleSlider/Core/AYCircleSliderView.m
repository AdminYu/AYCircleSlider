//
//  AYCircleSliderView.m
//  AYCircleSlider
//
//  Created by MacBook on 2019/7/5.
//  Copyright © 2019 MacBook. All rights reserved.
//

#import "AYCircleSliderView.h"
#import "NSString+Date.h"

#define unitAngle ((M_PI * 2) / (12 * 60.0))

typedef NS_ENUM(NSUInteger, SliderType) {
    SliderTypeNone = 0,
    SliderTypeStart,        //滑动起点
    SliderTypeEnd           //滑动终点
};

@interface AYCircleSliderView()
@property (nonatomic, assign) CGFloat startAngle;   //开始的角度
@property (nonatomic, assign) CGFloat endAngle;   //结束的角度

@property (nonatomic, strong) UIImageView *startImage; //开始点图片
@property (nonatomic, strong) UIImageView *endImage;  //结束点图片

@property (nonatomic, assign) CGFloat startLastAngle;  //滑动起点时上一刻的角度
@property (nonatomic, assign) CGFloat startCurrentAngle; //总共滑过的角度  计算滑过的圈数，从而计算是时间 24小时制

@property (nonatomic, assign) CGFloat endLastAngle; //滑动终点时上一刻的角度
@property (nonatomic, assign) CGFloat endCurrentAngle; //总共滑过的角度

@property (nonatomic, strong) UIImageView *bgImage;

@property (nonatomic, assign) SliderType type;
@end

@implementation AYCircleSliderView

- (instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        self.circleBgColor = [UIColor lightGrayColor];
        self.circleColor = [UIColor blueColor];
        self.circleWidth = 50;
        
        [self addSubview:self.bgImage];
        [self addSubview:self.startImage];
        [self addSubview:self.endImage];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.radius = self.frame.size.width / 2.0 - 40;
    
    self.bgImage.frame = (CGRect){0,0,self.radius + 2 * self.circleWidth,self.radius + 2 * self.circleWidth};
    self.bgImage.center = (CGPoint){self.frame.size.width / 2.0,self.frame.size.height / 2.0};
    
    self.startImage.frame = (CGRect){0,0,self.circleWidth,self.circleWidth};
    self.endImage.frame = (CGRect){0,0,self.circleWidth,self.circleWidth};
    
    self.startImage.layer.cornerRadius = self.circleWidth / 2.0;
    self.endImage.layer.cornerRadius = self.circleWidth / 2.0;
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    //背景圆环
    [self.circleBgColor set];
    UIBezierPath* bgPath = [UIBezierPath bezierPath];
    bgPath.lineWidth = self.circleWidth;
    bgPath.lineCapStyle = kCGLineCapRound;
    [bgPath addArcWithCenter:CGPointMake(rect.size.width / 2.0, rect.size.height / 2.0) radius:self.radius startAngle:0 endAngle:M_PI * 2 clockwise:YES];
    [bgPath stroke];
    
    //确定画的弧线的起始点
    [self.circleColor set];
    UIBezierPath* path = [UIBezierPath bezierPath];
    path.lineWidth = self.circleWidth;
    path.lineCapStyle = kCGLineCapRound;
    [path addArcWithCenter:CGPointMake(rect.size.width / 2.0, rect.size.height / 2.0) radius:self.radius startAngle:self.startAngle endAngle:self.endAngle clockwise:YES];
    [path stroke];
    
    self.startImage.center = [self pointWithAngle:self.startAngle];
    
    self.endImage.center = [self pointWithAngle:self.endAngle];
}

#pragma mark - 屏幕触摸
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self];
    
    //触摸点是起点
    if (CGRectContainsPoint(self.startImage.frame, currentPoint)) {
        self.type = SliderTypeStart;
        self.startLastAngle = self.startAngle;
    }
    
    //触摸点是终点
    if (CGRectContainsPoint(self.endImage.frame, currentPoint)) {
        self.type = SliderTypeEnd;
        self.endLastAngle = self.endAngle;
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self];
    
    if (self.type != SliderTypeNone) {
        if (self.type == SliderTypeStart) {
            //将当前的触摸点转换成角度
            self.startAngle = [self angleWithPoint:currentPoint];
            //计算当前时刻和上一时刻角度的差值
            CGFloat diffAngle = self.startAngle - self.startLastAngle;
            if ( diffAngle < -(M_PI / 2.0 * 3)) {  //比如由 356度 滑到了 5度
                diffAngle += M_PI * 2;
            }else if (diffAngle > M_PI / 2.0 * 3){ //比如由 5度 滑到了 356度
                diffAngle -= M_PI * 2;
            }
            self.startCurrentAngle += diffAngle;
            self.startLastAngle = self.startAngle; //将当前触摸记下，下一次使用
        }
        
        if (self.type == SliderTypeEnd) {
            self.endAngle = [self angleWithPoint:currentPoint];
            CGFloat diffAngle = self.endAngle - self.endLastAngle;
            if ( diffAngle < -(M_PI / 2.0 * 3)) {
                diffAngle += M_PI * 2;
            }else if (diffAngle > M_PI / 2.0 * 3){
                diffAngle -= M_PI * 2;
            }
            self.endCurrentAngle += diffAngle;
            self.endLastAngle = self.endAngle;
        }
        
        NSString *start = [self timeStringWithAngle:self.type == SliderTypeStart ? self.startCurrentAngle : self.startAngle];
        NSString *end = [self timeStringWithAngle:self.type == SliderTypeStart ? self.endAngle : self.endCurrentAngle];
        NSString *duration = [NSString durationTimeBetweenStartTime:start withEndTime:end];
        
        if ([_delegate respondsToSelector:@selector(circleSliderChangeWithStart:end:duration:)]) {
            [_delegate circleSliderChangeWithStart:start end:end duration:duration];
        }
        [self setNeedsDisplay];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if (self.type != SliderTypeNone) {
        
        NSString *start = [self timeStringWithAngle:self.type == SliderTypeStart ? self.startCurrentAngle : self.startAngle];
        NSString *end = [self timeStringWithAngle:self.type == SliderTypeStart ? self.endAngle : self.endCurrentAngle];
        NSString *duration = [NSString durationTimeBetweenStartTime:start withEndTime:end];
        
        if ([_delegate respondsToSelector:@selector(circleSliderChangeWithStart:end:duration:)]) {
            [_delegate circleSliderChangeWithStart:start end:end duration:duration];
        }
    }
    self.type = SliderTypeNone;
}

#pragma mark - private
//根据角度获得点
- (CGPoint)pointWithAngle:(CGFloat)angle{
    CGFloat y  = self.frame.size.height / 2.0 - sin(-angle) * self.radius;
    CGFloat x = self.frame.size.width / 2.0 + cos(-angle) * self.radius;
    return CGPointMake(x, y);
}

//根据点获取角度
- (CGFloat)angleWithPoint:(CGPoint)point{
    CGFloat angle;
    CGFloat xDifference = self.frame.size.width / 2.0 - point.x;
    CGFloat yDifference = self.frame.size.height / 2.0 - point.y;
    
    if (xDifference >= 0 && yDifference >= 0) {  //二
        angle = M_PI + atan( yDifference / xDifference);
    }else if(xDifference <= 0 && yDifference >= 0){  //一
        angle =  atan( yDifference / xDifference);
    }else if(xDifference >= 0 && yDifference <= 0){ //三
        angle =  M_PI + atan( yDifference / xDifference);
    }else{  //四
        angle = atan( yDifference / xDifference);
    }
    return angle;
}

//根据角度获取时间
- (NSString *)timeStringWithAngle:(CGFloat)floatAngle{
    int angle = ((int)(round((floatAngle + M_PI_2) * 180 / M_PI)) % 720) * 720 / 360;
    if (angle < 0) {
        angle += 720 * 2;
    }
    angle = (angle / 5) * 5;   //最小滑动单位 5 分钟
    int hour = angle / 60;
    int minute = angle % 60;
    return [NSString stringWithFormat:@"%02d:%02d",hour,minute];
}

#pragma mark - lazy
- (UIImageView *)bgImage{
    if (!_bgImage) {
        _bgImage = [[UIImageView alloc]init];
        _bgImage.image = [UIImage imageNamed:@"sleep_biaopan"];
    }
    return _bgImage;
}

- (UIImageView *)startImage{
    if (!_startImage) {
        _startImage = [[UIImageView alloc]init];
        _startImage.image = [UIImage imageNamed:@"bed"];
        _startImage.clipsToBounds = YES;
    }
    return _startImage;
}

- (UIImageView *)endImage{
    if (!_endImage) {
        _endImage = [[UIImageView alloc]init];
        _endImage.image = [UIImage imageNamed:@"wake"];
        _endImage.clipsToBounds = YES;
    }
    return _endImage;
}

#pragma mark - setter
- (void)setStartTime:(NSString *)startTime{
    _startTime = startTime;
    
    //时间换算为分钟
    int hour = [[startTime substringWithRange:NSMakeRange(0, 2)] intValue];
    int minute = [[startTime substringWithRange:NSMakeRange(3, 2)] intValue];
    int minuteValue = hour * 60 + minute;
    self.startAngle = minuteValue * unitAngle - M_PI / 2.0;
    
    self.startCurrentAngle = self.startAngle;
    
    if (self.endAngle) {
        [self setNeedsDisplay];
    }
}

- (void)setEndTime:(NSString *)endTime{
    _endTime = endTime;
    
    int hour = [[endTime substringWithRange:NSMakeRange(0, 2)] intValue];
    int minute = [[endTime substringWithRange:NSMakeRange(3, 2)] intValue];
    int minuteValue = hour * 60 + minute;
    self.endAngle = minuteValue * unitAngle - M_PI / 2.0;
    
    self.endCurrentAngle = self.endAngle;
    
    if (self.startAngle) {
        [self setNeedsDisplay];
    }
}

- (void)setCircleWidth:(CGFloat)circleWidth{
    _circleWidth = circleWidth;
}

- (void)setRadius:(CGFloat)radius{
    _radius = radius;
}

- (void)setCircleColor:(UIColor *)circleColor{
    _circleColor = circleColor;
}

- (void)setCircleBgColor:(UIColor *)circleBgColor{
    _circleBgColor = circleBgColor;
}

@end

