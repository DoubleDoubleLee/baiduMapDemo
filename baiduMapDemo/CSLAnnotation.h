//
//  CSLAnnotation.h
//  baiduMapDemo
//
//  Created by csl on 16/1/12.
//  Copyright © 2016年 CSL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
@interface CSLAnnotation : NSObject<BMKAnnotation>
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property(nonatomic,copy) NSString*title;
@property(nonatomic,strong) NSDictionary * info;

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;
@end
