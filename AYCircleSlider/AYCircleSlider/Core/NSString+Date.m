//
//  NSString+Date.m
//  AYCircleSlider
//
//  Created by MacBook on 2019/7/5.
//  Copyright © 2019 MacBook. All rights reserved.
//

#import "NSString+Date.h"

@implementation NSString (Date)
+ (NSString *)currentDate{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"] ];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentTime = [formatter stringFromDate:[NSDate date]];
    return currentTime;
}

+ (NSString *)intervalDate:(NSString *)date interval:(NSInteger)interval{
    NSString *dateString = date;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *selectDate = [formatter dateFromString:dateString];
    
    NSDate *yesterday = [NSDate dateWithTimeInterval:interval * 60 * 60 * 24 sinceDate:selectDate];
    return [formatter stringFromDate:yesterday];
}

/**
 比较两个时间的大小、前后
 返回YES endTime > startTime
 */
+ (BOOL)compareWithStartTime:(NSString *)startTime endTime:(NSString *)endTime{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH:mm";
    NSDate *startDate = [formatter dateFromString:startTime];
    NSDate *endDate = [formatter dateFromString:endTime];
    
    NSComparisonResult result = [startDate compare:endDate];
    if (result == NSOrderedAscending || result == NSOrderedSame) {   //没过期  end大于start
        return  YES;
    }
    return NO;
}


//获取两个时间之间的差值(多少分钟)
+ (NSString *)durationTimeBetweenStartTime:(NSString *)startTime withEndTime:(NSString *)endTime{
    BOOL flag = [self compareWithStartTime:startTime endTime:endTime];
    /**
     当flag为YES时表示 endTime > startTime在同一天比较，
     当flag为NO时表示 endTime < startTime差一天比较
     */
    NSString *endDay = [NSString currentDate];
    NSString *startDay = flag ? endDay : [NSString intervalDate:endDay interval:-1];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd HH:mm";
    NSDate *startDate = [formatter dateFromString:[NSString stringWithFormat:@"%@ %@",startDay,startTime]];
    NSDate *endDate = [formatter dateFromString:[NSString stringWithFormat:@"%@ %@",endDay,endTime]];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit type = NSCalendarUnitHour | NSCalendarUnitMinute;
    NSDateComponents *cmps = [calendar components:type fromDate:startDate toDate:endDate options:0];
    
    NSString *duration = [NSString stringWithFormat:@"%02ld小时%02ld分钟",cmps.hour,cmps.minute];
    return duration;
}
@end
