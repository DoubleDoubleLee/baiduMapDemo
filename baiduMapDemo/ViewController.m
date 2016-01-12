//
//  ViewController.m
//  baiduMapDemo
//
//  Created by csl on 16/1/11.
//  Copyright © 2016年 CSL. All rights reserved.
//

#import "ViewController.h"
#import "CSLAnnotation.h"

#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//定位服务
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//搜索服务

@interface ViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,BMKPoiSearchDelegate>

@property (weak, nonatomic) IBOutlet BMKMapView *mapView;
@property(nonatomic,strong) BMKLocationService * locationService;//定位服务
@property(nonatomic,strong) BMKGeoCodeSearch *geoCodeSearch;//地理编码搜索
@property(nonatomic,strong) BMKPoiSearch * poiSearch;//poi检索

-(void) customToolBar;//定制工具栏
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"百度地图";
    _mapView.showsUserLocation = YES;//显示用户当前位置
//    _mapView.showMapScaleBar = YES;//显示比例尺
    _mapView.compassPosition = CGPointMake(10, 20);
    
    //工具栏打开
    self.navigationController.toolbarHidden = NO;//
    [self customToolBar];
    
    //实例化定位服务对象
    _locationService = [[BMKLocationService alloc] init];
    _locationService.distanceFilter = 5;//距离过滤
    _locationService.desiredAccuracy = kCLLocationAccuracyBest;//定位精度
    
    //地理编码搜索对象
    _geoCodeSearch = [[BMKGeoCodeSearch alloc] init];
    
    //poi检索
    _poiSearch = [[BMKPoiSearch alloc] init];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void) viewWillAppear:(BOOL)animated{
    [_mapView viewWillAppear];//生命周期管理
    _mapView.delegate = self;//设置代理
    _locationService.delegate = self;
    _geoCodeSearch.delegate = self;
    _poiSearch.delegate = self;
}
-(void) viewWillDisappear:(BOOL)animated{
    [_mapView viewWillDisappear];
    _mapView.delegate = nil;//代理置空
    _locationService.delegate = nil;
    _geoCodeSearch.delegate = nil;
    _poiSearch.delegate = nil;
}

//工具栏定制
-(void) customToolBar{
    UIBarButtonItem * item1 = [[UIBarButtonItem alloc] initWithTitle:@"标注" style:UIBarButtonItemStylePlain target:self action:@selector(addAnntotation)];
    UIBarButtonItem * item2 = [[UIBarButtonItem alloc] initWithTitle:@"定位" style:UIBarButtonItemStylePlain target:self action:@selector(locate)];
    UIBarButtonItem * item3 = [[UIBarButtonItem alloc] initWithTitle:@"图形" style:UIBarButtonItemStylePlain target:self action:@selector(addGraphic)];
    UIBarButtonItem * item4 = [[UIBarButtonItem alloc] initWithTitle:@"周边检索" style:UIBarButtonItemStylePlain target:self action:@selector(roundSearch)];
    self.toolbarItems = @[item1,item2,item3,item4];
    
}


//增加标注
-(void) addAnntotation{
//    //标注数据
//    BMKPointAnnotation * annotation = [[BMKPointAnnotation alloc] init];
//    annotation.title = @"我是标注";
//    annotation.coordinate = CLLocationCoordinate2DMake(39.104, 116.123);
//    
//    //给地图增加标注，这不会显示，地图会调用代理方法绘制
//    [_mapView addAnnotation:annotation];
//    //[_mapView addAnnotations:<#(NSArray *)#>];//添加多个大头针
//    
//    _mapView.centerCoordinate = annotation.coordinate;
    
    //清除原来的标注
    NSArray * allAnntations = _mapView.annotations;
    [_mapView removeAnnotations:allAnntations];
    
    CSLAnnotation * annotation1 = [[CSLAnnotation alloc] init];
    annotation1.title = @"新标注1";
    annotation1.coordinate = CLLocationCoordinate2DMake(39.109, 116.234);
    
    [_mapView addAnnotation:annotation1];
    _mapView.centerCoordinate = annotation1.coordinate;
    
    
}


//在地图上添加图形
-(void) addGraphic{
    //1.定义图形对象，保存绘制数据
    //2.在mapView overLay代理方法里绘制图形，显示
    //绘制圆的对象
    BMKCircle *circle = [[BMKCircle alloc] init];
    circle.coordinate = CLLocationCoordinate2DMake(39.9116, 116.41);//中心点坐标
    circle.radius = 10000;//半径
    [_mapView addOverlay:circle];
    
    //折线
    CLLocationCoordinate2D coors[3] = {{39.9116,116.41},{40.123,117.09},{41.09,115.9}};
    BMKPolyline * line = [BMKPolyline polylineWithCoordinates:coors count:3];
    [_mapView addOverlay:line];
    
    
}

#pragma --------地图代理--------

//负责根据用户提供的标注数据在地图上显示标注
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation{
    if ([annotation isMemberOfClass:[BMKUserLocation class]]) {
        return nil;
    }
    //判定是否是用户增加的大头针，如果有多重类型，需要分开判断
    if ([annotation isMemberOfClass:[BMKPointAnnotation class]]) {
        //标准标注
        //和tableview的原理一样，可以复用
        BMKPinAnnotationView * annotationView = (BMKPinAnnotationView * )[mapView dequeueReusableAnnotationViewWithIdentifier:@"annotation1"];
        if (!annotationView) {//没有就创建
            annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"annotation1"];
            //标注颜色
//            annotationView.pinColor = BMKPinAnnotationColorGreen;
            annotationView.animatesDrop = YES;//下落时有动画效果
            annotationView.canShowCallout = YES;//显示气泡
            
            //气泡上加右视图
            UIButton * rightBtn = [UIButton buttonWithType:UIButtonTypeContactAdd];
            annotationView.rightCalloutAccessoryView = rightBtn;
        }
        return annotationView;
    }
    else if ([annotation isMemberOfClass:[CSLAnnotation class]]){
        BMKPinAnnotationView * annotationView = (BMKPinAnnotationView * )[mapView dequeueReusableAnnotationViewWithIdentifier:@"annotation2"];
        if (!annotationView) {//没有就创建
            annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"annotation2"];
            //标注颜色
            //            annotationView.pinColor = BMKPinAnnotationColorGreen;
            annotationView.animatesDrop = YES;//下落时有动画效果
            annotationView.canShowCallout = YES;//显示气泡
        }
        return annotationView;
    }
    return nil;
}
//点击泡泡时触发
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view{
    NSLog(@"click it");
}

#pragma mark ------图层覆盖物---------
/**
 *根据overlay生成对应的View
 *@param mapView 地图View
 *@param overlay 指定的overlay
 *@return 生成的覆盖物View
 */
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay{
    if ([overlay isKindOfClass:[BMKCircle class]]) {
        //画圆
        BMKCircleView * circleVeiw = [[BMKCircleView alloc] initWithCircle:overlay];
        circleVeiw.fillColor = [UIColor colorWithRed:0.9 green:0.8 blue:0.7 alpha:0.3];//填充色
        circleVeiw.lineWidth = 5;//线宽
        circleVeiw.strokeColor = [UIColor yellowColor];//线的颜色
        return circleVeiw;
    }
    else if ([overlay isKindOfClass:[BMKPolyline class]]){
        BMKPolylineView * lineView = [[BMKPolylineView alloc] initWithPolyline:overlay];
        lineView.lineWidth = 3;
        lineView.strokeColor = [UIColor blueColor];
        return lineView;
    }
    return nil;
}

#pragma mark-----定位服务----------

-(void) locate{
    [_locationService startUserLocationService];//开启定位服务
}
/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    NSLog(@"用户位置：(%.4f,%.4f)",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    //得到用户后，进行自己的业务处理
    //搜索选项
    BMKReverseGeoCodeOption * option = [[BMKReverseGeoCodeOption alloc] init];
    option.reverseGeoPoint = userLocation.location.coordinate;//指定坐标
    
    if ([_geoCodeSearch reverseGeoCode:option]==YES) {
        NSLog(@"发起反向地理编码成功");
    }else{
         NSLog(@"发起反向地理编码失败");
    }
}
/**
 *返回反地理编码搜索结果
 *@param searcher 搜索对象
 *@param result 搜索结果
 *@param error 错误号，@see BMKSearchErrorCode
 */
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    NSLog(@"%@",result);
    NSArray * places = result.poiList;
    for (BMKPoiInfo * place in places) {
        NSLog(@"%@",place);
        NSLog(@"%@  %@  %@",place.name,place.address,place.city);
    }
    [_locationService stopUserLocationService];
}

#pragma mark------周边检索---------
-(void) roundSearch{
    BMKCitySearchOption * cityOption = [[BMKCitySearchOption alloc] init];
    cityOption.city = @"北京市";
    cityOption.keyword = @"北京科技职业学院";
    cityOption.pageIndex = 0;
    cityOption.pageCapacity = 10;
    if ([_poiSearch poiSearchInCity:cityOption]) {
        NSLog(@"发起城市检索成功");
    }
    else{
        NSLog(@"发起城市检索失败");
    }
}


/**
 *返回POI搜索结果
 *@param searcher 搜索对象
 *@param poiResult 搜索结果列表
 *@param errorCode 错误号，@see BMKSearchErrorCode
 */
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResult errorCode:(BMKSearchErrorCode)errorCode{
    for (BMKPoiInfo *info in poiResult.poiInfoList) {
        NSLog(@"%@  %@  %@",info.name,info.address,info.city);
    }
}

@end
