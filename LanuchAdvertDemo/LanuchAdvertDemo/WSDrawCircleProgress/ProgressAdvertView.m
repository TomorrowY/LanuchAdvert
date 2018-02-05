//
//  ProgressAdvertView.m
//  LanuchAdvertDemo
//
//  Created by MacYin on 2018/2/4.
//  Copyright © 2018年 MacYin. All rights reserved.
//

#import "ProgressAdvertView.h"
#import "DrawCircleProgressButton.h"

#import <AVFoundation/AVFoundation.h>   //音乐


@interface ProgressAdvertView ()

@property (nonatomic, strong) UIImageView *adView;

@property (nonatomic, strong) DrawCircleProgressButton *DrawProgreBut;

@property (nonatomic, assign) int count;

@end

@implementation ProgressAdvertView

// 广告显示的时间
static int const showtime = 3;

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _adView = [[UIImageView alloc] initWithFrame:frame];
        _adView.userInteractionEnabled = YES;
        _adView.contentMode = UIViewContentModeScaleToFill;
        _adView.clipsToBounds = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToAdvertVc)];
        [_adView addGestureRecognizer:tap];
        //设置进度圈
        _DrawProgreBut = [[DrawCircleProgressButton alloc]initWithFrame:CGRectMake(IPHONE_WIDTH - 55, 30, 40, 40)];
        _DrawProgreBut.lineWidth = 2;
        [_DrawProgreBut setTitle:@"跳过" forState:UIControlStateNormal];
        [_DrawProgreBut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _DrawProgreBut.titleLabel.font = [UIFont systemFontOfSize:14];
        [_DrawProgreBut addTarget:self action:@selector(removeAdvertView) forControlEvents:UIControlEventTouchUpInside];
        [_DrawProgreBut startAnimationDuration:showtime withBlock:^{
            [self removeAdvertView];
        }];
        [self addSubview:_adView];
        [self addSubview:_DrawProgreBut];
        
    }
    return self;
}
- (void)setFilePath:(NSString *)filePath {
    _filePath = filePath;
    _adView.image = [UIImage imageWithContentsOfFile:filePath];
}

#pragma mark 显示广告界面启动定时器
- (void)showAdvert {
    UIWindow *widow = [UIApplication sharedApplication].keyWindow;
    [widow addSubview:self];
    [self playMuic];
}

#pragma mark 进入广告
- (void) pushToAdvertVc {
    [self removeAdvertView];
    //发出通知调用进入广告界面方法
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ZLPushToAdvert" object:nil userInfo:nil];
}
#pragma mark 移除广告
- (void) removeAdvertView {
    [UIView animateWithDuration:0.3f animations:^{
        self.alpha = 0.f;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


- (void) playMuic {
    //1.获得音效文件的全路径
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"classic.wav" withExtension:nil];
    //2.加载音效文件，创建音效ID（SoundID,一个ID对应一个音效文件）
    SystemSoundID soundID = 0;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &soundID);
    //3.03.播放音效
    AudioServicesPlaySystemSound(soundID);
}

@end
