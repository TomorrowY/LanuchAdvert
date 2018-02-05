//
//  ViewController.m
//  LanuchAdvertDemo
//
//  Created by MacYin on 2018/2/4.
//  Copyright © 2018年 MacYin. All rights reserved.
//

#import "ViewController.h"

#import "AdvetViewController.h"

@interface ViewController () 

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"首页";
    //监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushToAd) name:@"ZLPushToAdvert" object:nil];
    
}

// 进入广告链接页
- (void)pushToAd {
    AdvetViewController *adVc = [[AdvetViewController alloc] init];
    adVc.adUrl = @"http://www.kugou.com";
    [self.navigationController pushViewController:adVc animated:YES];
}



/**
 移除通知
 */
- (void)dealloc {
    [self removeObserver:self forKeyPath:@"ZLPushToAdvert"];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
