//
//  AppDelegate.m
//  LanuchAdvertDemo
//
//  Created by MacYin on 2018/2/4.
//  Copyright © 2018年 MacYin. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

//#import "YCLAdvertview.h"   /*#import "YCLAdvertview.h"  和 #import "YCLAdvertview.h" 不能同时引用  */
#import "ProgressAdvertView.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    UINavigationController *naVc = [[UINavigationController alloc] initWithRootViewController:[[ViewController alloc] init]];
    self.window.rootViewController = naVc;
    [self.window makeKeyAndVisible];
    //设置启动广告
    [self setupAdvert];
    return YES;
}

/**
 设置启动广告
 */
- (void) setupAdvert {
    // 1.判断沙盒中是否存在广告图片，如果存在，直接显示
    NSString *filePath = [self getFilePathWithImageName:[KUserDefaults valueForKey:adImageName]];
    BOOL isExist = [self isFileExistWithFilePath:filePath];
    if (isExist) {  //图片存在
//        YCLAdvertview *advertView = [[YCLAdvertview alloc] initWithFrame:self.window.bounds];
        ProgressAdvertView *advertView = [[ProgressAdvertView alloc] initWithFrame:self.window.bounds];
        advertView.filePath = filePath;
        [advertView showAdvert];
    }
    // 2.无论沙盒中是否存在广告图片，都需要重新调用广告接口，判断广告是否更新
    [self getAdvertisingImage];
}


/**
  根据图片名拼接文件路径
 */
- (NSString *) getFilePathWithImageName:(NSString *) imageName {
    if (imageName) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *filePath = [[paths objectAtIndex:0] stringByAppendingString:imageName];
        return filePath;
    }
    return nil;
}

/**
 *  判断文件是否存在
 */
- (BOOL)isFileExistWithFilePath:(NSString *)filePath {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirectory = FALSE;
    return [fileManager fileExistsAtPath:filePath isDirectory:&isDirectory];
}

/**
 *  初始化广告页面
 */
- (void)getAdvertisingImage {
    // TODO 请求广告接口
    // 这里原本应该采用广告接口，现在用一些固定的网络图片url代替
    NSArray *imageArray = @[
                            @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1517729260555&di=16e917e2762d463f98828e467fa49413&imgtype=0&src=http%3A%2F%2Fpic.orsoon.com%2Fuploads%2Fallimg%2F2015%2F11%2F30%2F6-95111448845545.png",
                            
                            @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1517729260554&di=8423f7e5973b1f38bd820ed103044f3c&imgtype=0&src=http%3A%2F%2Fpic.90sjimg.com%2Fdesign%2F00%2F05%2F93%2F57%2F56274479007ec.jpg",
                            
                            @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1517729260549&di=a77bc39dc17bebf82d0db2aa012608f0&imgtype=0&src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F0104bf56c596c932f875520f4d8e1f.jpg",
                            
                            @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1517729260548&di=4e99b2843f848409fdc145f10b89b977&imgtype=0&src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F01818555c8552a6ac7255808768387.jpg"
                            ];
    NSString *imageUrl = imageArray[arc4random() % imageArray.count];
    
    // 获取图片名:43-130P5122Z60-50.jpg
    NSArray *stringArr = [imageUrl componentsSeparatedByString:@"/"];
    NSString *imageName = stringArr.lastObject;
    
    // 拼接沙盒路径
    NSString *filePath = [self getFilePathWithImageName:imageName];
    BOOL isExist = [self isFileExistWithFilePath:filePath];
    if (!isExist){ // 如果该图片不存在，则删除老图片，下载新图片
        [self downloadAdImageWithUrl:imageUrl imageName:imageName];
    }
}
/**
 *  下载新图片
 */
- (void)downloadAdImageWithUrl:(NSString *)imageUrl imageName:(NSString *)imageName {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
        UIImage *image = [UIImage imageWithData:data];
        NSString *filePath = [self getFilePathWithImageName:imageName]; // 保存文件的名称
        
        if ([UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES]) {// 保存成功
            NSLog(@"保存成功");
            [self deleteOldImage];
            [KUserDefaults setValue:imageName forKey:adImageName];
            [KUserDefaults synchronize];
            // 如果有广告链接，将广告链接也保存下来
        }else{
            NSLog(@"保存失败");
        }
        
    });
}
/**
 *  删除旧图片
 */
- (void)deleteOldImage {
    
    NSString *imageName = [KUserDefaults valueForKey:adImageName];
    if (imageName) {
        NSString *filePath = [self getFilePathWithImageName:imageName];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:filePath error:nil];
    }
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
