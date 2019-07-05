//
//  NSString+Date.h
//  AYCircleSlider
//
//  Created by MacBook on 2019/7/5.
//  Copyright © 2019 MacBook. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Date)
/**
 获取今天的日期
 */
+ (NSString *)currentDate;

/**
 获取距离今天某一天的日期
 */
+ (NSString *)intervalDate:(NSString *)date interval:(NSInteger)interval;

/**
 比较两个时间的大小、前后
 返回YES endTime >= startTime
 返回NO endTime < startTime
 */
+ (BOOL)compareWithStartTime:(NSString *)startTime endTime:(NSString *)endTime;
/**
 获取两个时间之间的差值(单位:分钟)
 */
+ (NSString *)durationTimeBetweenStartTime:(NSString *)startTime withEndTime:(NSString *)endTime;
@end

