//
//  DrawCircleProgressButton.h
//  LanuchAdvertDemo
//
//  Created by MacYin on 2018/2/4.
//  Copyright © 2018年 MacYin. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DrawCircleProgressBlock)(void);

@interface DrawCircleProgressButton : UIButton

//set track color
@property (nonatomic,strong)UIColor    *trackColor;

//set progress color
@property (nonatomic,strong)UIColor    *progressColor;

//set track background color
@property (nonatomic,strong)UIColor    *fillColor;

//set progress line width
@property (nonatomic,assign)CGFloat    lineWidth;

//set progress duration
@property (nonatomic,assign)CGFloat    animationDuration;

/**
 *  set complete callback
 *
 *  @param block     block
 *  @param duration  time
 */
- (void)startAnimationDuration:(CGFloat)duration withBlock:(DrawCircleProgressBlock )block;

@end
