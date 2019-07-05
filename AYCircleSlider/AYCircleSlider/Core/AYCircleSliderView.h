//
//  AYCircleSliderView.h
//  AYCircleSlider
//
//  Created by MacBook on 2019/7/5.
//  Copyright © 2019 MacBook. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AYCircleSliderViewDelegate<NSObject>
- (void)circleSliderChangeWithStart:(NSString *)start end:(NSString *)end duration:(NSString *)duration;
@end

@interface AYCircleSliderView : UIView
/**
 开始时间
 */
@property (nonatomic, strong) NSString *startTime;

/**
 结束时间
 */
@property (nonatomic, strong) NSString *endTime;

/**
 圆环宽
 */
@property (nonatomic, assign) CGFloat circleWidth;

/**
 圆环半径
 */
@property (nonatomic, assign) CGFloat radius;

/**
 圆环颜色
 */
@property (nonatomic, strong) UIColor *circleColor;

/**
 圆环背景颜色
 */
@property (nonatomic, strong) UIColor *circleBgColor;

@property (nonatomic, weak) id<AYCircleSliderViewDelegate> delegate;
@end

