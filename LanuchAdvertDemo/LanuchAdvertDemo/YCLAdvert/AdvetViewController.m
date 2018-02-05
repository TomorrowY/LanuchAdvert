//
//  AdvetViewController.m
//  LanuchAdvertDemo
//
//  Created by MacYin on 2018/2/4.
//  Copyright © 2018年 MacYin. All rights reserved.
//

#import "AdvetViewController.h"


@interface AdvetViewController ()

/** UIWebview */
@property (nonatomic, strong) UIWebView * webViwe;
@end

@implementation AdvetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"酷酷狗平台";
    self.webViwe = [[UIWebView alloc] initWithFrame:self.view.bounds];
    self.webViwe.backgroundColor = [UIColor whiteColor];
    
    if (!self.adUrl) {
        self.adUrl = @"http://www.baidu.com";
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.adUrl]];
    [self.webViwe loadRequest:request];
    [self.view addSubview:self.webViwe];
}

- (void)setAdUrl:(NSString *)adUrl {
    _adUrl = adUrl;
}





@end
