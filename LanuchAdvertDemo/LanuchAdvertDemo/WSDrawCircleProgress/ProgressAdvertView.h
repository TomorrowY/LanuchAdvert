//
//  ProgressAdvertView.h
//  LanuchAdvertDemo
//
//  Created by MacYin on 2018/2/4.
//  Copyright © 2018年 MacYin. All rights reserved.
//

#import <UIKit/UIKit.h>

// 图片存储标识


static NSString *const adImageName = @"adImageName";
static NSString *const adUrl = @"adUrl";
@interface ProgressAdvertView : UIView


/**
 *  图片路径
 */
@property (nonatomic, copy) NSString *filePath;

/**
 显示广告页面
 */
- (void) showAdvert;

@end
