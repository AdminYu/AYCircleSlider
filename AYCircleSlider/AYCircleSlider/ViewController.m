//
//  ViewController.m
//  AYCircleSlider
//
//  Created by MacBook on 2019/7/5.
//  Copyright © 2019 MacBook. All rights reserved.
//

#import "ViewController.h"
#import "AYCircleSliderView.h"

#define ColorA(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

@interface ViewController ()<AYCircleSliderViewDelegate>
@property (nonatomic, strong) UILabel *sleepLabel;
@property (nonatomic, strong) UILabel *wakeLabel;
@property (nonatomic, strong) UILabel *durationLabel;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    
    AYCircleSliderView *circleView = [[AYCircleSliderView alloc]init];
    circleView.frame = (CGRect){0,0,self.view.frame.size.width,self.view.frame.size.width};
    circleView.center = (CGPoint){self.view.frame.size.width / 2.0,self.view.frame.size.height / 2.0 + 50};
    circleView.startTime = @"23:00";
    circleView.endTime = @"06:18";
    circleView.circleColor = ColorA(252, 192, 11, 1);
    circleView.delegate = self;
    circleView.backgroundColor = [UIColor blackColor];
    circleView.circleBgColor = [UIColor darkGrayColor];
    circleView.circleWidth = 40;
    [self.view addSubview:circleView];
    
    self.sleepLabel.text = [NSString stringWithFormat:@"睡觉时间: %@",@"23:00"];
    self.wakeLabel.text = [NSString stringWithFormat:@"起床时间: %@",@"06:18"];
    self.durationLabel.text = [NSString stringWithFormat:@"时长: %@",@"07小时18分钟"];
    
}


- (void)circleSliderChangeWithStart:(NSString *)start end:(NSString *)end duration:(NSString *)duration{
    self.sleepLabel.text = [NSString stringWithFormat:@"睡觉时间: %@",start];
    self.wakeLabel.text = [NSString stringWithFormat:@"起床时间: %@",end];
    self.durationLabel.text = [NSString stringWithFormat:@"时长: %@",duration];
}

- (UILabel *)sleepLabel{
    if (!_sleepLabel) {
        _sleepLabel = [[UILabel alloc]init];
        _sleepLabel.frame = (CGRect){0,40,self.view.frame.size.width,40};
        _sleepLabel.textColor = [UIColor whiteColor];
        _sleepLabel.font = [UIFont systemFontOfSize:20];
        _sleepLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_sleepLabel];
    }
    return _sleepLabel;
}

- (UILabel *)wakeLabel{
    if (!_wakeLabel) {
        _wakeLabel = [[UILabel alloc]init];
        _wakeLabel.frame = (CGRect){0,90,self.view.frame.size.width,40};
        _wakeLabel.textColor = [UIColor whiteColor];
        _wakeLabel.font = [UIFont systemFontOfSize:20];
        _wakeLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_wakeLabel];
    }
    return _wakeLabel;
}

- (UILabel *)durationLabel{
    if (!_durationLabel) {
        _durationLabel = [[UILabel alloc]init];
        _durationLabel.frame = (CGRect){0,140,self.view.frame.size.width,40};
        _durationLabel.textColor = [UIColor whiteColor];
        _durationLabel.font = [UIFont systemFontOfSize:20];
        _durationLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_durationLabel];
    }
    return _durationLabel;
}





@end
