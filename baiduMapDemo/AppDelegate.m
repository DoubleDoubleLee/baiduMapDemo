//
//  AppDelegate.m
//  baiduMapDemo
//
//  Created by csl on 16/1/11.
//  Copyright © 2016年 CSL. All rights reserved.
//

#import "AppDelegate.h"
#import <BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>

@interface AppDelegate ()<BMKGeneralDelegate>

@end

@implementation AppDelegate
{
    BMKMapManager * _mapManager;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    _mapManager = [[BMKMapManager alloc] init];
    
    //初始化百度地图,key必须和bundle标示一致
    if ([_mapManager start:@"fG7GhIUsGMdARuYZo8qipc3U" generalDelegate:self]) {
        NSLog(@"初始化成功");
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [BMKMapView willBackGround];//进入后台
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    //进入前台
    [BMKMapView didForeGround];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark------baidumapdelegate------
/**
 *返回网络错误
 *@param iError 错误号
 */
- (void)onGetNetworkState:(int)iError{
    if (0==iError) {
        NSLog(@"联网成功");
    }
    else{
        NSLog(@"联网失败");
    }
}

/**
 *返回授权验证错误
 *@param iError 错误号 : 为0时验证通过，具体参加BMKPermissionCheckResultCode
 */
- (void)onGetPermissionState:(int)iError{
    if (0==iError) {
        NSLog(@"授权成功");
    }
    else{
        NSLog(@"授权失败:%d",iError);
    }
}

@end
