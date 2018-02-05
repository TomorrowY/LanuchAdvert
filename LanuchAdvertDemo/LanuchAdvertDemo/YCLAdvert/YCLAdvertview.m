//
//  YCLAdvertview.m
//  LanuchAdvertDemo
//
//  Created by MacYin on 2018/2/4.
//  Copyright © 2018年 MacYin. All rights reserved.
//

#import "YCLAdvertview.h"

@interface YCLAdvertview ()
@property (nonatomic, strong) UIImageView *adView;

@property (nonatomic, strong) UIButton *countBtn;

@property (nonatomic, strong) NSTimer *countTimer;

@property (nonatomic, assign) int count;

@end

// 广告显示的时间
static int const showtime = 3;

@implementation YCLAdvertview

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _adView = [[UIImageView alloc] initWithFrame:frame];
        _adView.userInteractionEnabled = YES;
        _adView.contentMode = UIViewContentModeScaleToFill;
        _adView.clipsToBounds = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToAdvertVc)];
        [_adView addGestureRecognizer:tap];
        
        //添加跳过按钮
        CGFloat butWidth = 60;
        CGFloat butHeight = 30;
        _countBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _countBtn.frame = CGRectMake(IPHONE_WIDTH - butWidth - 20, 30, butWidth, butHeight);
        [_countBtn addTarget:self action:@selector(removeAdvertView) forControlEvents:UIControlEventTouchUpInside];
        [_countBtn setTitle:[NSString stringWithFormat:@"跳过%d", showtime] forState:UIControlStateNormal];
        _countBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_countBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _countBtn.backgroundColor = [UIColor colorWithRed:38 /255.0 green:38 /255.0 blue:38 /255.0 alpha:0.6];
        _countBtn.layer.cornerRadius = 4;
        
        [self addSubview:_adView];
        [self addSubview:_countBtn];
        
    }
    return self;
}

- (void)setFilePath:(NSString *)filePath {
    _filePath = filePath;
    _adView.image = [UIImage imageWithContentsOfFile:filePath];
    
}
#pragma mark 进入广告
- (void) pushToAdvertVc {
    [self removeAdvertView];
    //发出通知调用进入广告界面方法
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ZLPushToAdvert" object:nil userInfo:nil];
}
#pragma mark 显示广告界面启动定时器
- (void)showAdvert {
    
//    [self startCoundown]     //使用GCD计时
    //启动定时器自减
    [self startTimer];
    UIWindow *widow = [UIApplication sharedApplication].keyWindow;
    [widow addSubview:self];
}
#pragma  mark 启动定时器倒计时
- (void)startTimer {
    _count = showtime;
    [[NSRunLoop mainRunLoop] addTimer:self.countTimer forMode:NSRunLoopCommonModes];
}

#pragma mark - 定时器方法
#pragma mark 创建定时器
- (NSTimer *)countTimer {
    if (!_countTimer) {
        _countTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(countDown) userInfo:nil repeats:YES];
    }
    return _countTimer;
    
}
#pragma mark 定时器自减
- (void) countDown {
    _count --;
    [_countBtn setTitle:[NSString stringWithFormat:@"跳过%d",_count] forState:UIControlStateNormal];
    if (0 == _count) {
        [self removeAdvertView];
    }
    
}

#pragma mark - 方法2。 GCD计时
- (void)startCoundown {
    __weak __typeof(self) weakSelf = self;
    __block int timeout = showtime + 1; //倒计时时间 + 1
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0 * NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout <= 0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf removeAdvertView];
            });
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [_countBtn setTitle:[NSString stringWithFormat:@"跳过%d",timeout] forState:UIControlStateNormal];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

#pragma mark 移除广告
- (void) removeAdvertView {
    // 停掉定时器
    [self.countTimer invalidate];
    self.countTimer = nil;
    [UIView animateWithDuration:0.3f animations:^{
        self.alpha = 0.f;
        
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
